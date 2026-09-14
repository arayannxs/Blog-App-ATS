class Category {
  final int id;
  final String categoryName;
  final String descriptionCategory;

  Category({
    required this.id,
    required this.categoryName,
    required this.descriptionCategory,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['categoryName'] ?? '',
      descriptionCategory: json['descriptionCategory'] ?? '',
    );
  }
}

class Post {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String? imageUrl;
  final int categoryId;
  final String status;
  final String createdAt;
  final Category? category;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.categoryId,
    required this.status,
    required this.createdAt,
    this.category,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'],
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }
}