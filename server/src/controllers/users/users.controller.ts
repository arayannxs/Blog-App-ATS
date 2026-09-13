import { Request, Response } from "express";
import {
  userIdSchema,
  userPostParamsSchema,
} from "../../validations/post.validation";
import { db } from "../../config/db";
import { postsTable } from "../../config/schema";
import { and, desc, eq } from "drizzle-orm";

export class UsersController {
  // USER : Get All Data (posts)
  getPostsByUserId = async (req: Request, res: Response) => {
    try {
      const validatedParams = userIdSchema.parse(req.params);

      const { userId } = validatedParams;

      const posts = await db.query.postsTable.findMany({
        where: and(
          eq(postsTable.userId, Number(userId)),
          eq(postsTable.status, "published"),
        ),
        orderBy: [desc(postsTable.createdAt)],
        with: {
          category: true,
        },
      });

      return res.status(200).json({
        success: true,
        message: "User posts retrieved successfully",
        data: {
          posts,
        },
      });
    } catch (error: any) {
      console.error("Get posts by user ID error:", error);
    }
  };

  // USER : Get Post By Id
  getUsersPost = async (req: Request, res: Response) => {
    try {
      const validatedParams = userPostParamsSchema.parse(req.params);
      const { userId, postId } = validatedParams;

      const post = await db.query.postsTable.findFirst({
      where: and(
        eq(postsTable.id, postId),
        eq(postsTable.userId, userId),
        eq(postsTable.status, "published")
      ),
      with: {
        category: true,
      },
    });

      if (!post) {
        return res.status(404).json({
          success: false,
          message: "Post not found",
        });
      }

      return res.status(200).json({
        success: true,
        message: "Post retrieved successfully",
        data: {
          post,
        },
      });
    } catch (error: any) {
      console.error("Get user post error:", error);

      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };
}

export default new UsersController();