import { Request, Response } from "express";
import {loginSchema, regsiterSchema,} from "../../validations/auth.validation";
import { eq } from "drizzle-orm";
import { users } from "../../config/schema";
import { db } from "../../config/db";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

export class AuthController {
  register = async (req: Request, res: Response) => {
    try {
      const validatedData = regsiterSchema.parse(req.body);
      const { username, email, password } = validatedData;

      const [existingEmail] = await db
        .select()
        .from(users)
        .where(eq(users.email, email))
        .limit(1);

      if (existingEmail) {
        return res.status(409).json({
          success: false,
          message: "Email already exists",
        });
      }

      const hashedPassword = await bcrypt.hash(password, 10);

      const [insertedUser] = await db
        .insert(users)
        .values({
          username: username,
          email: email,
          password: hashedPassword,
        })
        .$returningId();

      const newUser = await db.query.users.findFirst({
        where: eq(users.id, insertedUser.id),
      });

      return res.status(201).json({
        success: true,
        message: "Register successful",
        data: {
          user: {
            id: newUser?.id,
            username: newUser?.username,
            email: newUser?.email,
            role: newUser?.role,
          },
        },
      });
    } catch (error: any) {
      console.error(error);

      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };

  login = async (req: Request, res: Response) => {
    try {
      const validatedData = loginSchema.parse(req.body);
      const { email, password } = validatedData;

      const user = await db.query.users.findFirst({
        where: eq(users.email, email),
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          message: "Email or password incorrect",
        });
      }

      const isPasswordValid = await bcrypt.compare(password, user.password);

      if (!isPasswordValid) {
        return res.status(401).json({
          success: false,
          message: "Email or password incorrect",
        });
      }

      const token = jwt.sign(
        {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
        },
        process.env.JWT_SECRET as string,
        {
          expiresIn: "7d",
        },
      );

      return res.status(200).json({
        success: true,
        message: "Login successful",
        data: {
          token: token,
          user: {
            id: user.id,
            username: user.username,
            email: user.email,
            role: user.role,
          },
        },
      });
    } catch (error: any) {
      return res.status(500).json({
        success: false,
        message: "Internal server error",
        error: error.message,
      });
    }
  };
}

export default new AuthController();