import 'package:ecommerce_app/core/configs/assets/app_images.dart';
import 'package:ecommerce_app/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:ecommerce_app/presentation/home/bloc/user_info_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
      builder: (context, state) {
        if (state is UserInfoLoading) {
          return const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is UserInfoLoaded) {
          final user = state.user;

          return Container(
            color: AppColors.background, // Match AppBar background
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _profileImage(user.image),
                _gender(user.gender),
                _card(user.firstName),
              ],
            ),
          );
        }

        return const SizedBox(height: 40); // fallback height
      },
    );
  }

  Widget _profileImage(String imageUrl) {
    final hasNetworkImage = imageUrl.isNotEmpty;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: hasNetworkImage
              ? NetworkImage(imageUrl)
              : AssetImage(AppImages.profile) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _gender(int gender) {
    final genderLabel = gender == 1
        ? 'Male'
        : gender == 2
        ? 'Female'
        : 'Other';

    return Container(
      width: 70,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Center(
        child: Text(
          genderLabel,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }

  Widget _card(String firstName) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Tooltip(
        message: 'Hi, $firstName',
        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
      ),
    );
  }
}
