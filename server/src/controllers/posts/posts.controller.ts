import { Request, Response } from "express";
import {
  createPostSchema,
  postIdSchema,
  updatePostParamsSchema,
  updatePostSchema,
} from "../../validations/post.validation";
import { db } from "../../config/db";
import { postsTable } from "../../config/schema";
import { and, desc, eq } from "drizzle-orm";
import {
  deleteFromCloudinary,
  uploadToCloudinary,
} from "../../services/cloudinary.service";

export class PostsController {
  createPost = async (req: Request, res: Response) => {
    try {
      // 1. validation
      const validatedData = createPostSchema.parse(req.body);
      const { userId, title, content, categoryId } = validatedData;
      let imageUrl: string | undefined;
      let imagePublicId: string | undefined;
      // 2. Jika ada file yang di-upload, kirim ke Cloudinary
      if (req.file) {
        const uploadResult = await uploadToCloudinary(req.file.buffer);
        imageUrl = uploadResult.secure_url;
        imagePublicId = uploadResult.public_id;
      }
      // 3. Create New Post
      const [insertedPost] = await db
        .insert(postsTable)
        .values({ userId, title, content, imageUrl, imagePublicId, categoryId })
        .$returningId();
      // 4. Ambil Post yg baru di buat tadi
      const newPost = await db.query.postsTable.findFirst({
        where: eq(postsTable.id, insertedPost.id),
      });
      // 5. Tampilkan dalam API
      return res.status(201).json({
        success: true,
        message: "Post created successfully",
        data: {
          post: newPost,
        },
      });
    } catch (error: any) {
      console.error("Create post error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // READ
  // GUEST : Get Posts
  getPosts = async (req: Request, res: Response) => {
    try {
      const posts = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.status, "published"))
        .orderBy(desc(postsTable.createdAt));

      return res.status(200).json({
        success: true,
        message: "Get Posts Successfully",
        data: {
          posts: posts,
        },
      });
    } catch (error: any) {
      console.error("Get posts error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // GUEST : Get Post By ID
  getPostById = async (req: Request, res: Response) => {
    try {
      const validatedParams = postIdSchema.parse(req.params);
      const { id } = validatedParams;

      const [post] = await db
        .select()
        .from(postsTable)
        .where(and(eq(postsTable.id, id), eq(postsTable.status, "published")));

      if (!post) {
        return res.status(404).json({
          success: false,
          message: "Posts Not Found",
        });
      }

      return res.status(200).json({
        success: true,
        message: "Post retrieved successfully",
        data: {
          post: post,
        },
      });
    } catch (error: any) {
      console.error("Get posts error:", error);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan pada server",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // UPDATE
  updatePost = async (req: Request, res: Response) => {
    try {
      // =====================================
      // 1. VALIDATE PARAMS
      // =====================================
      const validatedParams = updatePostParamsSchema.parse(req.params);
      const { id } = validatedParams;

      // =====================================
      // 2. VALIDATE BODY
      // =====================================
      const validatedData = updatePostSchema.parse(req.body);
      const { title, content } = validatedData;

      // =====================================
      // 3. CHECK POST
      // =====================================
      const [existingPost] = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.id, id));

      if (!existingPost) {
        return res.status(404).json({
          success: false,
          message: "Post not found",
        });
      }

      // =====================================
      // 4. SIAPKAN DATA UPDATE
      // =====================================
      let imageUrl = existingPost.imageUrl;
      let imagePublicId = existingPost.imagePublicId;

      // =====================================
      // 5. JIKA ADA IMAGE BARU
      // =====================================
      if (req.file) {
        const uploadResult = await uploadToCloudinary(req.file.buffer);

        imageUrl = uploadResult.secure_url;
        imagePublicId = uploadResult.public_id;

        // =====================================
        // HAPUS IMAGE LAMA
        // =====================================
        if (existingPost.imagePublicId) {
          await deleteFromCloudinary(existingPost.imagePublicId);
        }
      }

      // =====================================
      // 6. UPDATE DATABASE
      // =====================================
      await db
        .update(postsTable)
        .set({
          ...(title !== undefined && { title }),
          ...(content !== undefined && { content }),
          ...(req.file && { imageUrl, imagePublicId }),
        })
        .where(eq(postsTable.id, id));

      // =====================================
      // 7. AMBIL DATA TERBARU
      // =====================================
      const [updatedPost] = await db
        .select()
        .from(postsTable)
        .where(eq(postsTable.id, id));

      // =====================================
      // 8. RESPONSE
      // =====================================
      return res.status(200).json({
        success: true,
        message: "Post updated successfully",
        data: {
          post: updatedPost,
        },
      });
    } catch (error: any) {
      console.error("Update post error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error instanceof Error ? error.message : error,
      });
    }
  };

  // DELETE
  deletePost = async (req: Request, res: Response) => {
    try {
      // =====================================
      // 1. VALIDATE POST ID
      // =====================================
      const validatedParams = postIdSchema.parse(req.params);
      const { id } = validatedParams;

      // =====================================
      // 2. CHECK POST
      // =====================================
      const existingPost = await db.query.postsTable.findFirst({
        where: eq(postsTable.id, id),
      });

      if (!existingPost) {
        return res.status(404).json({
          success: false,
          message: "Post not found",
        });
      }

      // =====================================
      // 3. SOFT DELETE
      // =====================================
      await db
        .update(postsTable)
        .set({ status: "delete" })
        .where(eq(postsTable.id, id));

      // =====================================
      // 4. RESPONSE
      // =====================================
      return res.status(200).json({
        success: true,
        message: "Post deleted successfully",
      });
    } catch (error: any) {
      console.error("Delete post error:", error);
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };
}

export default new PostsController();
