// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_managment/models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbfunctions {
  Future<List<CategoryModel>> getCategories();

  Future<void> insertCategory(CategoryModel value);

  Future<void> deleteCategory(String categoryid);
}

class CategoryDB implements CategoryDbfunctions {
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryList = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryList = ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  @override
  Future<void> deleteCategory(String categoryid) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.delete(categoryid);
    refreshUI();
  }

  Future<void> refreshUI() async {
    final _getAllCategories = await getCategories();
    incomeCategoryList.value.clear();
    expenseCategoryList.value.clear();

    await Future.forEach(
      _getAllCategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.value.add(category);
        } else {
          expenseCategoryList.value.add(category);
        }
      },
    );

    incomeCategoryList.notifyListeners();
    expenseCategoryList.notifyListeners();
  }
}
