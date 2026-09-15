# SRS (Software Requirements Specification)

## 1. Pendahuluan

Dokumen ini merupakan spesifikasi kebutuhan perangkat lunak untuk aplikasi blog backend berbasis REST API. Sistem ini dibangun menggunakan Express.js, MySQL, dan validasi input dengan Zod. Tujuan utama dari aplikasi ini adalah menyediakan layanan manajemen kategori dan artikel blog melalui API yang mudah digunakan oleh frontend atau client lain.

## 2. Tujuan

Tujuan dari pengembangan aplikasi ini adalah:

- Menyediakan API untuk mengelola data kategori blog.
- Menyediakan API untuk mengelola data artikel blog.
- Memastikan validasi input yang konsisten dan aman.
- Menyediakan data yang terstruktur dan mudah diakses oleh aplikasi client.
- Mendukung operasi CRUD (Create, Read, Update, Delete) pada data utama.

## 3. Lingkup Sistem

Sistem mencakup:

- Pengelolaan data kategori blog.
- Pengelolaan data artikel blog.
- Filter artikel berdasarkan kategori.
- Validasi data sebelum masuk ke database.
- Penanganan error dan response standar.

Sistem tidak mencakup:

- Autentikasi pengguna.
- Role-based access control.
- UI frontend.
- Sistem komentar, like, atau fitur blog lanjutan lainnya.

## 4. Definisi, Istilah, dan Singkatan

- API: Application Programming Interface.
- CRUD: Create, Read, Update, Delete.
- REST: Representational State Transfer.
- Backend: Bagian server yang memproses request dan mengelola data.
- Kategori: Kelompok artikel yang dikelompokkan berdasarkan tema.
- Artikel: Konten utama blog berisi judul dan isi.
- SRS: Software Requirements Specification.

## 5. Deskripsi Umum

Aplikasi backend blog ini digunakan untuk menangani data kategori dan artikel. Data disimpan di MySQL dan diakses melalui endpoint HTTP. API ini dirancang agar dapat dipakai oleh frontend seperti React, Vue, atau aplikasi mobile.

### 5.1. Pengguna Sistem

Pengguna utama sistem adalah admin atau operator yang melakukan pengelolaan konten blog melalui API. Dalam konteks saat ini, sistem belum menerapkan login atau otorisasi pengguna.

### 5.2. Ruang Lingkup Fungsional

Sistem menyediakan layanan berikut:

1. Menampilkan semua kategori.
2. Menampilkan kategori berdasarkan ID.
3. Menambah kategori baru.
4. Mengubah data kategori.
5. Menghapus kategori.
6. Menampilkan semua artikel.
7. Menampilkan artikel berdasarkan ID.
8. Menambah artikel baru.
9. Mengubah data artikel.
10. Menghapus artikel.
11. Memfilter artikel berdasarkan kategori.

## 6. Karakteristik Pengguna

### 6.1. Admin/Operator

- Mengelola konten blog.
- Menggunakan API untuk menambah, melihat, memperbarui, dan menghapus kategori serta artikel.
- Diharapkan memahami format JSON dan struktur data API.

## 7. Kebutuhan Fungsional

### 7.1. Manajemen Kategori

#### F-01: Melihat daftar kategori

- Sistem harus menampilkan seluruh data kategori yang tersimpan.
- Endpoint: GET /api/categories
- Response success: status 200 dengan data kategori.

#### F-02: Melihat kategori berdasarkan ID

- Sistem harus menampilkan kategori sesuai dengan ID yang diminta.
- Jika kategori tidak ditemukan, sistem mengembalikan status 404.
- Endpoint: GET /api/categories/:id

#### F-03: Menambah kategori baru

- Sistem harus menerima data nama kategori.
- Sistem harus memvalidasi keberadaan nama kategori.
- Jika nama kategori sudah ada, sistem menolak dengan status 409.
- Endpoint: POST /api/categories

#### F-04: Mengubah data kategori

- Sistem harus menerima data nama kategori baru.
- Sistem hanya akan memperbarui kategori yang sudah ada.
- Jika ID tidak ditemukan, sistem mengembalikan status 404.
- Endpoint: PUT /api/categories/:id

#### F-05: Menghapus kategori

- Sistem harus menghapus data kategori sesuai ID.
- Jika ID tidak ditemukan, sistem mengembalikan status 404.
- Endpoint: DELETE /api/categories/:id

### 7.2. Manajemen Artikel

#### F-06: Melihat daftar artikel

- Sistem harus menampilkan seluruh artikel beserta nama kategori terkait.
- Jika parameter category_id diberikan, sistem hanya menampilkan artikel dari kategori tertentu.
- Endpoint: GET /api/posts
- Query: category_id

#### F-07: Melihat artikel berdasarkan ID

- Sistem harus menampilkan detail artikel berdasarkan ID.
- Jika artikel tidak ditemukan, sistem mengembalikan status 404.
- Endpoint: GET /api/posts/:id

#### F-08: Menambah artikel baru

- Sistem harus menerima category_id, title, dan content.
- Sistem harus memvalidasi bahwa category_id benar-benar ada di tabel categories.
- Jika kategori tidak valid, sistem mengembalikan status 400.
- Endpoint: POST /api/posts

#### F-09: Mengubah artikel

- Sistem harus menerima data baru seperti category_id, title, dan content.
- Sistem hanya memperbarui field yang dikirim.
- Jika artikel tidak ditemukan, sistem mengembalikan status 404.
- Jika category_id tidak valid, sistem mengembalikan status 400.
- Endpoint: PUT /api/posts/:id

#### F-10: Menghapus artikel

- Sistem harus menghapus artikel berdasarkan ID.
- Jika artikel tidak ditemukan, sistem mengembalikan status 404.
- Endpoint: DELETE /api/posts/:id

## 8. Kebutuhan Non-Fungsional

### 8.1. Kinerja

- API harus merespons dalam waktu yang wajar untuk operasi CRUD dasar.
- Query untuk data kategori dan artikel harus berjalan efisien.

### 8.2. Keandalan

- Sistem harus dapat menangani error dengan pesan yang jelas.
- Jika data tidak ditemukan, API harus mengembalikan response status yang tepat.

### 8.3. Validasi Data

- Input harus divalidasi sebelum diproses ke database.
- Nama kategori wajib diisi.
- category_id untuk artikel harus berupa angka dan valid.
- title dan content untuk artikel harus diberikan sesuai kebutuhan bisnis.

### 8.4. Keamanan

- Sistem harus mencegah data invalid masuk ke database.
- Data input harus dibatasi agar tidak menimbulkan error atau injeksi data yang tidak aman.
- API harus menangani error tanpa mengekspos detail internal yang tidak perlu.

### 8.5. Maintainability

- Struktur kode harus terorganisasi berdasarkan modul, seperti routes, controllers, validations, dan middleware.
- Logika bisnis dipisah dari routing dan validasi agar lebih mudah dikembangkan.

## 9. Batasan Sistem

- Sistem saat ini belum memiliki autentikasi dan otorisasi.
- Sistem belum menyediakan fitur upload gambar atau media.
- Sistem belum ada fitur komentar, tag, bookmark, atau user management.
- Sistem hanya fokus pada pengelolaan data kategori dan artikel blog.

## 10. Use Case

### 10.1. Use Case Utama

| ID    | Nama Use Case          | Aktor | Deskripsi                                                |
| ----- | ---------------------- | ----- | -------------------------------------------------------- |
| UC-01 | Melihat semua kategori | Admin | Admin melihat daftar seluruh kategori blog.              |
| UC-02 | Menambah kategori      | Admin | Admin menambahkan kategori baru.                         |
| UC-03 | Mengubah kategori      | Admin | Admin memperbarui nama kategori.                         |
| UC-04 | Menghapus kategori     | Admin | Admin menghapus kategori dari sistem.                    |
| UC-05 | Melihat semua artikel  | Admin | Admin melihat semua artikel beserta kategori.            |
| UC-06 | Menambah artikel       | Admin | Admin menambahkan artikel baru dengan kategori tertentu. |
| UC-07 | Mengubah artikel       | Admin | Admin memperbarui judul atau isi artikel.                |
| UC-08 | Menghapus artikel      | Admin | Admin menghapus artikel dari sistem.                     |

## 11. Struktur Data

### 11.1. Tabel categories

- id: integer, primary key
- name: string, unique

### 11.2. Tabel posts

- id: integer, primary key
- category_id: integer, foreign key ke categories.id
- title: string
- content: text

## 12. Format Response Umum

Sistem menggunakan format response JSON dengan struktur umum berikut:

### Success

```json
{
  "success": true,
  "message": "artikel berhasil dibuat",
  "data": {
    "id": 1,
    "category_id": 2,
    "title": "Judul Artikel",
    "content": "Isi artikel",
    "category_name": "Teknologi"
  }
}
```

### Error

```json
{
  "success": false,
  "message": "kategori tidak ditemukan"
}
```

## 13. Ringkasan SRS

Sistem ini merupakan backend REST API untuk aplikasi blog yang memiliki dua entitas utama, yaitu kategori dan artikel. Sistem menyediakan operasi CRUD lengkap untuk kedua entitas, dengan validasi input, pengecekan relasi category_id, dan response yang konsisten. Fokus utama sistem adalah kemudahan pengelolaan konten blog secara terstruktur dan siap dipakai oleh frontend.

## 14. Kesimpulan

Dokumen SRS ini menjadi dasar perancangan pengembangan aplikasi blog backend. Dengan kebutuhan yang sudah diidentifikasi, tim pengembang dapat mengimplementasikan fitur secara terarah dan terukur sesuai kebutuhan bisnis yang ada.
