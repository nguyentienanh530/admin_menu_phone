import 'dart:async';
import 'package:admin_menu_mobile/features/category/data/category_repo.dart';
import 'package:category_repository/category_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dtos/category_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryState()) {
    on<FetchCategories>(_fetchCategories);
    on<CategoryChanged>(_categoryChanged);
  }

  FutureOr<void> _fetchCategories(
      FetchCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      var categories = await CategoryRepo(
              categoryRepository: CategoryRepository(
                  firebaseFirestore: FirebaseFirestore.instance))
          .getAllCategory();
      emit(state.copyWith(
          status: CategoryStatus.success, categories: categories));
      // ,
      // category: categories.first.name
    } catch (e) {
      emit(state.copyWith(
          status: CategoryStatus.failure, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _categoryChanged(
      CategoryChanged event, Emitter<CategoryState> emit) {
    emit(state.copyWith(category: event.category));
  }
}
