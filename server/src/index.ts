import express, { Request, Response } from "express";
import { drizzle } from "drizzle-orm/mysql2";
import mysql from "mysql2/promise";
import * as schema from "./config/schema";
import cors from "cors";
import dotenv from "dotenv";

import authRouter from "./routes/auth/auth.route";
import postsRouter from "./routes/posts/posts.route";
import usersRouter from "./routes/users/users.route";
import categoryRouter from "./routes/categories/category.route";

const app = express();
const port = 5000;

dotenv.config();

const poolConnection = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: Number(process.env.DB_PORT) || ***REDACTED***,
});

export const db = drizzle(poolConnection, { schema, mode: "default" });

app.use(cors());

app.use(express.json());

app.use("/api/v1/auth", authRouter);
app.use("/api/v1/posts", postsRouter);
app.use("/api/v1/users", usersRouter);
app.use("/api/v1/categories", categoryRouter);

app.get("/", (req: Request, res: Response) => {
  res.send("Hello World!");
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});