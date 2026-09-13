import { Router } from "express";
import { getAllCategories, createCategory, getCategoryById, updateCategory } from "../../controllers/categories/category.controller";

const router = Router();

router.get("/", getAllCategories);
router.get("/:id", getCategoryById);
router.post("/", createCategory);
router.put("/:id", updateCategory); // 2. Tambahkan route PUT ini

export default router;