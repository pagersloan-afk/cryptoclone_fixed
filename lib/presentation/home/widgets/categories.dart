import 'package:ecommerce_app/common/bloc/categories/categories_display_cubit.dart';
import 'package:ecommerce_app/common/bloc/categories/categories_display_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesDisplayCubit()..displayCategories(),
      child: BlocBuilder<CategoriesDisplayCubit, CategoriesDisplayState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return const CircularProgressIndicator();
          }
          if (state is CategoriesLoaded) {
            return Column(
              children: [_seaALL(), const SizedBox(height: 20), _categories()],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _seaALL() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text('See All', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _categories() {
    final categories = [
      {'icon': Icons.phone_android, 'label': 'Phones'},
      {'icon': Icons.laptop, 'label': 'Laptops'},
      {'icon': Icons.headset, 'label': 'Headsets'},
      {'icon': Icons.watch, 'label': 'Watches'},
      {'icon': Icons.tablet, 'label': 'Tablets'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  category['icon'] as IconData,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(category['label'] as String),
            ],
          );
        },
      ),
    );
  }
}
