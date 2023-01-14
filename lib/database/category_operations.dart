import 'package:guide_sqflite/database/database.dart';

class CategoryOperations {
  CategoryOperations? categoryOperations;

  final dbProvider = DatabaseRepository.instance;

  createCategory(Category category) async {
    final db = await dbProvider.database;
    db.insert('category', category.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db.query('category');
    List<Category> categories =
        allRows.map((category) => Category.fromMap(category)).toList();
    return categories;
  }
}

class Category {
  int? id;
  late String name;

  Category({
     this.id,
    required this.name,
  });

  Category.fromMap(dynamic obj) {
    id = obj['categoryId'];
    name = obj['categoryName'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'categoryName': name,
    };

    return map;
  }
}
