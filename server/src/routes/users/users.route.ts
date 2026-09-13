import { Router } from "express";
import { authenticate } from "../../middleware/auth.middleware";
import UsersController from "../../controllers/users/users.controller";

const router = Router();

// User : Get all data (posts)
router.get('/:userId' , authenticate, UsersController.getPostsByUserId);

// User : Get data by Id
router.get('/:userId/posts/:postId', authenticate, UsersController.getUsersPost);

export default router;