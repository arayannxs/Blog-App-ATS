import { Request, Response } from "express";
import { db } from "../../config/db"; 
import { categories } from "../../config/schema"; 
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
    const { name } = req.body;

    // Validasi input
    if (!name || name.trim() === "") {
      return res.status(400).json({
        message: "Nama kategori tidak boleh kosong!",
      });
    }

    // Insert ke database
    const [newCategory] = await db.insert(categories).values({ name }).$returningId();

    return res.status(201).json({
      message: "Kategori berhasil ditambahkan",
      data: {
        id: newCategory.id,
        name,
      },
    });
  } catch (error) {
    return res.status(500).json({
      message: "Gagal menambahkan kategori",
      error: error instanceof Error ? error.message : error,
    });
  }
};

// GET Kategori Berdasarkan ID
export const getCategoryById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const category = await db.select().from(categories).where(eq(categories.id, Number(id)));

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