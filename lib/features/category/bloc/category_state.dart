part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, failure }

class CategoryState extends Equatable {
  const CategoryState(
      {this.status = CategoryStatus.initial,
      this.categories = const <Categories>[],
      this.errorMessage = '',
      this.category = ''});
  final CategoryStatus status;
  final List<Categories> categories;
  final String category;
  final String errorMessage;

  CategoryState copyWith(
          {CategoryStatus? status,
          List<Categories>? categories,
          String? category,
          String? errorMessage}) =>
      CategoryState(
          status: status ?? this.status,
          categories: categories ?? this.categories,
          category: category ?? this.category,
          errorMessage: errorMessage ?? this.errorMessage);
  @override
  List<Object> get props => [status, categories, errorMessage, category];
}
