import { mysqlTable, mysqlEnum, int, varchar, text, timestamp } from "drizzle-orm/mysql-core";
import { relations } from "drizzle-orm";

export const USER_ROLES = ["user", "admin",] as const;

export const POST_STATUS = ["delete", "published",] as const;


// USERS
export const users = mysqlTable("users", {
id: int("id").autoincrement().primaryKey(),
username: varchar("username", { length: 50 }).notNull(),
email: varchar("email", { length: 100 }).notNull().unique(),
password: varchar("password", { length: 255 }).notNull(),
role: mysqlEnum("role", USER_ROLES).notNull().default("user"),
createdAt: timestamp("created_at").defaultNow(),
updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
});


// POSTS
export const postsTable = mysqlTable("posts", {
id: int("id").autoincrement().primaryKey(),
userId: int("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
title: varchar("title", { length: 255 }).notNull(),
content: text("content").notNull(),
imageUrl: text("image_url"), // Kolom untuk simpan URL gambar
imagePublicId: varchar("image_public_id", { length: 255 }), // Kolom untuk simpan Public ID Cloudinary
categoryId: int("category_id").notNull().references(() => categories.id, { onDelete: "cascade" }),
status: mysqlEnum("status", POST_STATUS).notNull().default("published"),
createdAt: timestamp("created_at").defaultNow(),
updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
});


// COMMENTS
export const commentsTable = mysqlTable("comments", {
id: int("id").autoincrement().primaryKey(),
postId: int("post_id").notNull().references(() => postsTable.id, { onDelete: "cascade" }),
userId: int("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
comment: text("comment").notNull(),
createdAt: timestamp("created_at").defaultNow(),
updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
});

// CATEGORIES
export const categories = mysqlTable("categories", {
id: int("id").autoincrement().primaryKey(),
categoryName: varchar("category_name", { length: 100 }).notNull(),
descriptionCategory: text("description_category"),
createdAt: timestamp("created_at").defaultNow(),
updatedAt: timestamp("updated_at").defaultNow().onUpdateNow(),
});

// Definisi Relasi untuk postsTable -> categoriesTable (Many to One)
export const postsRelations = relations(postsTable, ({ one }) => ({
	category: one(categories, {
		fields: [postsTable.categoryId],
		references: [categories.id],
	}),
}));