const errorHandler = (err, req, res, next) => {
  console.error(err);

  res.status(err.status || 500).json({
    success: false,
    message: err.message || "terjadi kesalahan pada server",
  });
};

const notFound = (req, res) => {
  res.status(404).json({
    success: false,
    message: `route ${req.method} ${req.originalUrl} tidak ditemukan`,
  });
};

module.exports = { errorHandler, notFound };
