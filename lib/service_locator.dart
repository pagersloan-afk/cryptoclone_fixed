import 'package:ecommerce_app/data/auth/repository/auth_repository_impl.dart';
import 'package:ecommerce_app/data/auth/source/auth_firebase_service.dart';
import 'package:ecommerce_app/data/category/repository/category.dart';
import 'package:ecommerce_app/data/category/source/category_firebase_service.dart';
import 'package:ecommerce_app/domain/auth/repository/auth.dart';
import 'package:ecommerce_app/domain/auth/usecases/get_ages.dart';
import 'package:ecommerce_app/domain/auth/usecases/get_user.dart';
import 'package:ecommerce_app/domain/auth/usecases/is_logged_in.dart';
import 'package:ecommerce_app/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce_app/domain/auth/usecases/siginup.dart';
import 'package:ecommerce_app/domain/auth/usecases/signin.dart';
import 'package:ecommerce_app/domain/category/repository/category.dart';
import 'package:ecommerce_app/domain/category/usecases/get_categories.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> initializeDependencies() async {
  // Services

  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  sl.registerSingleton<CategoryFirebaseService>(CategoryFirebaseServiceImpl());

  // Repositories

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  sl.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());

  // Usecases

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<GetAgesUseCase>(GetAgesUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  sl.registerSingleton<SendPasswordResetEmailUseCase>(
    SendPasswordResetEmailUseCase(),
  );

  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());

  sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase());
}
