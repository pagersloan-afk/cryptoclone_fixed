import 'package:ecommerce_app/common/bloc/categories/categories_display_state.dart';
import 'package:ecommerce_app/domain/category/usecases/get_categories.dart';
import 'package:ecommerce_app/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesDisplayCubit extends Cubit<CategoriesDisplayState> {
  CategoriesDisplayCubit() : super(CategoriesLoading());

  void displayCategories() async {
    var returnedData = await sl<GetCategoriesUseCase>().call();
    returnedData.fold(
      (error) {
        emit(LoadCategoryFailure());
      },
      (data) {
        emit(CategoriesLoaded(categories: data));
      },
    );
  }
}
