import 'package:flutter/material.dart';

class Category {
  static const List<String> _types = ["학과", "강의", "분반"];
}

class ChooseCategory extends StatelessWidget {
  final Function(Category) onCategorySelected;

  // ignore: prefer_const_constructors_in_immutables
  ChooseCategory({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
