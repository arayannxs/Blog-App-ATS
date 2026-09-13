import { Router } from "express";
import { getAllCategories, createCategory, getCategoryById } from "../../controllers/categories/category.controller";

const router = Router();

router.get("/", getAllCategories);
router.get("/:id", getCategoryById);
router.post("/", createCategory);

export default router;