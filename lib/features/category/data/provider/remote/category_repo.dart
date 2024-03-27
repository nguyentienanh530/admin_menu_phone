import 'package:admin_menu_mobile/common/firebase/firebase_base.dart';
import 'package:admin_menu_mobile/common/firebase/firebase_result.dart';
import 'package:admin_menu_mobile/features/category/data/model/category_model.dart';
import 'package:category_repository/category_repository.dart';

class CategoryRepo extends FirebaseBase<CategoryModel> {
  final CategoryRepository _categoryRepository;

  CategoryRepo({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository;

  Future<FirebaseResult<List<CategoryModel>>> getCategories() async {
    return await getItems(
        await _categoryRepository.getCategories(), CategoryModel.fromJson);
  }
}
