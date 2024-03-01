import 'package:flutter_bloc/flutter_bloc.dart';

class TotalPriceCubit extends Cubit<num> {
  TotalPriceCubit() : super(0);
  onTotalPriceChanged(num value) => emit(value);
}
