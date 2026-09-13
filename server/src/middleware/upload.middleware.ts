import multer from "multer";
import path from "path";

const storage = multer.memoryStorage();

export const uploadSingleImage = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // Maksimal 5MB
  },
  fileFilter: (_req, file, cb) => {
    // 1. Cek ekstensi file
    const extName = path.extname(file.originalname).toLowerCase();
    const allowedExts = [".png", ".jpg", ".jpeg", ".webp"];
    const isAllowedExt = allowedExts.includes(extName);

    // 2. Cek MIME type (sertakan application/octet-stream)
    const isAllowedMime = 
      file.mimetype.startsWith("image/") || 
      file.mimetype === "application/octet-stream";

    // Jika ekstensi valid DAN MIME type sesuai
    if (isAllowedExt && isAllowedMime) {
      cb(null, true);
    } else {
      cb(new Error(`Tipe file tidak valid (${file.mimetype}). Hanya gambar (.png, .jpg, .jpeg, .webp) yang diperbolehkan!`));
    }
  },
}).single("image");