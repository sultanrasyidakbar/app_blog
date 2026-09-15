const pool = require("../config/db");

const baseSelect = `
  select posts.id, posts.category_id, posts.title, posts.content,
    posts.thumbnail, categories.name as category_name
  from posts
  join categories on posts.category_id = categories.id
`;

const getAllPosts = async (req, res, next) => {
  try {
    const { category_id } = req.query;

    let query = baseSelect;
    const params = [];

    if (category_id) {
      query += " where posts.category_id = ?";
      params.push(category_id);
    }

    query += " order by posts.id desc";

    const [rows] = await pool.query(query, params);
    res.status(200).json({ success: true, data: rows });
  } catch (err) {
    next(err);
  }
};

const getPostById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [rows] = await pool.query(`${baseSelect} where posts.id = ?`, [id]);

    if (rows.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "artikel tidak ditemukan" });
    }

    res.status(200).json({ success: true, data: rows[0] });
  } catch (err) {
    next(err);
  }
};

const createPost = async (req, res, next) => {
  try {
    const { category_id, title, content, thumbnail } = req.body;

    const [category] = await pool.query(
      "select id from categories where id = ?",
      [category_id],
    );
    if (category.length === 0) {
      return res.status(400).json({
        success: false,
        message: "category_id tidak valid / tidak ditemukan",
      });
    }

    const [result] = await pool.query(
      "insert into posts (category_id, title, content, thumbnail) values (?, ?, ?, ?)",
      [category_id, title, content, thumbnail ?? null],
    );

    const [rows] = await pool.query(`${baseSelect} where posts.id = ?`, [
      result.insertId,
    ]);
    res.status(201).json({
      success: true,
      message: "artikel berhasil dibuat",
      data: rows[0],
    });
  } catch (err) {
    next(err);
  }
};

const updatePost = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { category_id, title, content, thumbnail } = req.body;

    const [existing] = await pool.query("select id from posts where id = ?", [
      id,
    ]);
    if (existing.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "artikel tidak ditemukan" });
    }

    if (category_id !== undefined) {
      const [category] = await pool.query(
        "select id from categories where id = ?",
        [category_id],
      );
      if (category.length === 0) {
        return res.status(400).json({
          success: false,
          message: "category_id tidak valid / tidak ditemukan",
        });
      }
    }

    const updates = [];
    const values = [];

    if (category_id !== undefined) {
      updates.push("category_id = ?");
      values.push(category_id);
    }
    if (title !== undefined) {
      updates.push("title = ?");
      values.push(title);
    }
    if (content !== undefined) {
      updates.push("content = ?");
      values.push(content);
    }
    if (thumbnail !== undefined) {
      updates.push("thumbnail = ?");
      values.push(thumbnail);
    }
    values.push(id);
    await pool.query(
      `update posts set ${updates.join(", ")} where id = ?`,
      values,
    );

    const [rows] = await pool.query(`${baseSelect} where posts.id = ?`, [id]);
    res.status(200).json({
      success: true,
      message: "artikel berhasil diupdate",
      data: rows[0],
    });
  } catch (err) {
    next(err);
  }
};

const deletePost = async (req, res, next) => {
  try {
    const { id } = req.params;
    const [existing] = await pool.query("select * from posts where id = ?", [
      id,
    ]);

    if (existing.length === 0) {
      return res
        .status(404)
        .json({ success: false, message: "artikel tidak ditemukan" });
    }

    await pool.query("delete from posts where id = ?", [id]);
    res
      .status(200)
      .json({ success: true, message: "artikel berhasil dihapus" });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getAllPosts,
  getPostById,
  createPost,
  updatePost,
  deletePost,
};
