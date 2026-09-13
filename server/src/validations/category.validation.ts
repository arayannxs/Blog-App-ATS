import { z } from "zod";

export const categoryIdSchema = z.object({
  id: z.coerce.number().int().positive(),
});

export const createCategorySchema = z.object({
  categoryName: z
    .string()
    .min(3, "Nama kategori minimal 3 karakter")
    .max(100, "Nama kategori maksimal 100 karakter"),

  descriptionCategory: z
    .string()
    .max(500, "Deskripsi maksimal 500 karakter")
    .optional()
    .nullable(),
});

export const updateCategorySchema = z.object({
  categoryName: z
    .string()
    .min(3, "Nama kategori minimal 3 karakter")
    .max(100, "Nama kategori maksimal 100 karakter")
    .optional(),

  descriptionCategory: z
    .string()
    .max(500, "Deskripsi maksimal 500 karakter")
    .optional()
    .nullable(),
});