const express = require("express");
const router = express.Router();
const validate = require("../middleware/validate");
const {
  createPostSchema,
  updatePostSchema,
} = require("../validations/postValidation");
const {
  getAllPosts,
  getPostById,
  createPost,
  updatePost,
  deletePost,
} = require("../controllers/postController");

router.get("/", getAllPosts);

router.get("/:id", getPostById);

router.post("/", validate(createPostSchema), createPost);

router.put("/:id", validate(updatePostSchema), updatePost);

router.delete("/:id", deletePost);

module.exports = router;
