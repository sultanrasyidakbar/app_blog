const pool = require("../config/db");

const getAllCategories = async (req, res, next) => {
  try {
    const [rows] = await pool.query(
      "select id, name from categories order by id desc",
    );
    res.status(200).json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

const getCategoryById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(
      "select id, name from categories where id = ?",
      [id],
    );

    if (rows.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "kategori tidak ditemukan" });
    }

    res.status(200).json({ success: true, data: rows[0] });
  } catch (err) {
    next(err);
  }
};

const createCategory = async (req, res, next) => {
  try {
    const { name } = req.body;
    const [result] = await pool.query(
      "insert into categories (name) values (?)",
      [name],
    );
    const [rows] = await pool.query(
      "select id, name from categories where id = ?",
      [result.insertId],
    );

    res.status(201).json({
      success: true,
      message: "kategori berhasil dibuat",
      data: rows[0],
    });
  } catch (err) {
    if (err.code === "ER_DUP_ENTRY") {
      return res
        .status(409)
        .json({ success: false, message: "nama kategori sudah ada" });
    }
    next(err);
  }
};

const updateCategory = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name } = req.body;

    const [existing] = await pool.query(
      "select * from categories where id = ?",
      [id],
    );
    if (existing.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "kategori tidak ditemukan" });
    }

    await pool.query(
      "update categories set name = coalesce(?, name) where id = ?",
      [name, id],
    );
    const [rows] = await pool.query(
      "select id, name from categories where id = ?",
      [id],
    );

    res.status(200).json({
      success: true,
      message: "kategori berhasil diupdate",
      data: rows[0],
    });
  } catch (err) {
    if (err.code === "ER_DUP_ENTRY") {
      return res
        .status(409)
        .json({ success: false, message: "nama kategori sudah ada" });
    }
    next(err);
  }
};

const deleteCategory = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [existing] = await pool.query(
      "select * from categories where id = ?",
      [id],
    );

    if (existing.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "kategori tidak ditemukan" });
    }

    await pool.query("delete from categories where id = ?", [id]);
    res
      .status(200)
      .json({ success: true, message: "kategori berhasil dihapus" });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getAllCategories,
  getCategoryById,
  createCategory,
  updateCategory,
  deleteCategory,
};
