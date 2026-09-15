const { z } = require("zod");

const createPostSchema = z.object({
  category_id: z
    .number({
      required_error: "category_id wajib diisi",
      invalid_type_error: "category_id harus berupa angka",
    })
    .int()
    .positive(),
  title: z
    .string({ required_error: "title wajib diisi" })
    .trim()
    .min(3, "title minimal 3 karakter")
    .max(255, "title maksimal 255 karakter"),
  content: z
    .string({ required_error: "content wajib diisi" })
    .trim()
    .min(10, "content minimal 10 karakter"),
  thumbnail: z
    .string()
    .trim()
    .max(255, "thumbnail maksimal 255 karakter")
    .nullable()
    .optional(),
});

const updatePostSchema = createPostSchema
  .partial()
  .refine((data) => Object.keys(data).length > 0, {
    message: "minimal satu field harus diisi",
  });

module.exports = {
  createPostSchema,
  updatePostSchema,
};
