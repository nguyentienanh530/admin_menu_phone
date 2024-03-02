import 'package:admin_menu_mobile/features/category/dtos/category_model.dart';
import 'package:category_repository/category_repository.dart';

class CategoryRepo {
  final CategoryRepository _categoryRepository;

  CategoryRepo({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  Future<List<Categories>> getAllCategory() async {
    try {
      var categories = <Categories>[];
      var res = await _categoryRepository.getAllCategory();
      categories
          .addAll(res.docs.map((e) => Categories.fromJson(e.data())).toList());
      return categories;
    } catch (e) {
      throw '$e';
    }
  }
}
