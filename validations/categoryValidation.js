const { z } = require("zod");

const createCategorySchema = z.object({
  name: z
    .string({ required_error: "name wajib diisi" })
    .trim()
    .min(2, "name minimal 2 karakter")
    .max(100, "name maksimal 100 karakter"),
});

const updateCategorySchema = createCategorySchema
  .partial()
  .refine((data) => Object.keys(data).length > 0, {
    message: "minimal satu field harus diisi",
  });

module.exports = {
  createCategorySchema,
  updateCategorySchema,
};
