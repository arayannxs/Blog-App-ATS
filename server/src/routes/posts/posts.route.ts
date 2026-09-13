import { Router } from "express";
import PostsController from "../../controllers/posts/posts.controller";
import { uploadSingleImage } from "../../middleware/upload.middleware";
import { authenticate } from "../../middleware/auth.middleware";

const router = Router();

// CREATE
router.post('/' , 
    authenticate, 
    uploadSingleImage, PostsController.createPost);

// GUEST    
router.get('/' , PostsController.getPosts);
router.get('/:id' , PostsController.getPostById);

// UPDATE
router.patch('/:id',
    authenticate,
    uploadSingleImage, PostsController.updatePost);

// DELETE
router.delete('/:id',
    authenticate,
    PostsController.deletePost);

export default router;