const express = require("express");
const router = express.Router();
const validate = require("../middleware/validate");
const {
  createCategorySchema,
  updateCategorySchema,
} = require("../validations/categoryValidation");
const {
  getAllCategories,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
} = require("../controllers/categoryController");

router.get("/", getAllCategories);

router.get("/:id", getCategoryById);

router.post("/", validate(createCategorySchema), createCategory);

router.put("/:id", validate(updateCategorySchema), updateCategory);

router.delete("/:id", deleteCategory);

module.exports = router;
