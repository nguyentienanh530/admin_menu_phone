import 'dart:async';

import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/category/data/provider/remote/category_repo.dart';
import 'package:category_repository/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/model/category_model.dart';
part 'category_event.dart';

typedef Emit = Emitter<GenericBlocState<CategoryModel>>;

class CategoryBloc extends Bloc<CategoryEvent, GenericBlocState<CategoryModel>>
    with BlocHelper<CategoryModel> {
  CategoryBloc() : super(GenericBlocState.loading()) {
    on<CategoriesFetched>(_fetchCategories);
  }
  final _categoryRepo = CategoryRepo(
      categoryRepository:
          CategoryRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _fetchCategories(CategoriesFetched event, Emit emit) async {
    await getItems(_categoryRepo.getCategories(), emit);
  }
}
