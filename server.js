require("dotenv").config();
const express = require("express");
const cors = require("cors");

const categoryRoutes = require("./routes/categoryRoutes");
const postRoutes = require("./routes/postRoutes");
const { errorHandler, notFound } = require("./middleware/errorHandler");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "blog api jalan dengan baik",
  });
});

app.use("/api/categories", categoryRoutes);
app.use("/api/posts", postRoutes);

app.use(notFound);
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`server berjalan di http://localhost:${PORT}`);
});
