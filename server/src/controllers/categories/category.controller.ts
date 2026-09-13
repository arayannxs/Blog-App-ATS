import { Request, Response } from "express";
import { db } from "../../config/db";
import { categories } from "../../config/schema";
import { categoryIdSchema, createCategorySchema, updateCategorySchema } from "../../validations/category.validation";
import { eq } from "drizzle-orm";

// 1. GET: Ambil Semua Kategori
export const getAllCategories = async (req: Request, res: Response) => {
  try {
    const allCategories = await db.select().from(categories);

    return res.status(200).json({
      message: "Berhasil mengambil data kategori",
      data: allCategories,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Terjadi kesalahan pada server",
      error: error instanceof Error ? error.message : error,
    });
  }
};

// 2. POST: Tambah Kategori Baru
export const createCategory = async (req: Request, res: Response) => {
  try {
    // 1. Validasi Body pakai Zod Schema
    const validatedData = createCategorySchema.parse(req.body);
    const { categoryName, descriptionCategory } = validatedData;

    // 2. Insert ke database (masukkan categoryName & descriptionCategory)
    const [newCategory] = await db
      .insert(categories)
      .values({ 
        categoryName, 
        descriptionCategory 
      })
      .$returningId();

    // 3. Ambil data kategori yang baru dibuat
    const createdData = await db.query.categories.findFirst({
      where: eq(categories.id, newCategory.id),
    });

    return res.status(201).json({
      message: "Kategori berhasil ditambahkan",
      data: createdData,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Gagal menambahkan kategori",
      error: error instanceof Error ? error.message : error,
    });
  }
};

// 3. PUT: Update Kategori
export const updateCategory = async (req: Request, res: Response) => {
  try {
    // Validasi ID params & Body
    const { id } = categoryIdSchema.parse(req.params);
    const validatedData = updateCategorySchema.parse(req.body);
    const { categoryName, descriptionCategory } = validatedData;

    // Cek ketersediaan kategori
    const existingCategory = await db.query.categories.findFirst({
      where: eq(categories.id, id),
    });

    if (!existingCategory) {
      return res.status(404).json({ message: "Kategori tidak ditemukan" });
    }

    // Update data di database
    await db
      .update(categories)
      .set({
        ...(categoryName !== undefined && { categoryName }),
        ...(descriptionCategory !== undefined && { descriptionCategory }),
        updatedAt: new Date(),
      })
      .where(eq(categories.id, id));

    // Ambil data terbaru
    const updatedData = await db.query.categories.findFirst({
      where: eq(categories.id, id),
    });

    return res.status(200).json({
      message: "Kategori berhasil diperbarui",
      data: updatedData,
    });
  } catch (error) {
    return res.status(500).json({
      message: "Gagal memperbarui kategori",
      error: error instanceof Error ? error.message : error,
    });
  }
};

// GET Kategori Berdasarkan ID
export const getCategoryById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const category = await db
      .select()
      .from(categories)
      .where(eq(categories.id, Number(id)));

    if (category.length === 0) {
      return res.status(404).json({ message: "Kategori tidak ditemukan" });
    }

    return res.status(200).json({
      message: "Berhasil mengambil detail kategori",
      data: category[0],
    });
  } catch (error) {
    return res.status(500).json({ message: "Gagal mengambil data", error });
  }
};