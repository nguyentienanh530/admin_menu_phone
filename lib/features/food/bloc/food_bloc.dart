import 'dart:async';

import 'package:admin_menu_mobile/features/food/data/food_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(FoodInitial()) {
    on<GetFoods>(_fetchFoods);
  }

  FutureOr<void> _fetchFoods(GetFoods event, Emitter<FoodState> emit) async {
    emit(FoodInProgress());
    try {
      var foods = await FoodRepo(
              foodRepository:
                  FoodRepository(firebaseFirestore: FirebaseFirestore.instance))
          .getFoods();
      emit(FoodSuccess(foods: foods));
    } catch (e) {
      emit(FoodFailue(error: e.toString()));
    }
  }
}
