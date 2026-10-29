import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../DB/database.dart';
import '../Model/model.dart';
import '../view/HomePage/homePage.dart';
import '../view/TransactionHistory/transaction.dart';
import '../view/profile/profile.dart';
import '../view/wallet/wallet.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  late final List<Widget> screens;

  final RxList<Expense> expenses = <Expense>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final ExpenseDatabase _database = ExpenseDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    screens = [
      const HomeScreen(),
      const TransactionHistoryScreen(),
      const CreditScreen(),
      const ProfileScreen(),
    ];
    loadExpenses();
  }

  void changeTab(int index) {
    if (index >= 0 && index < screens.length) {
      selectedIndex.value = index;
    }
  }

  // --- Dynamic Financial Calculations from SQLite records ---

  double get totalIncome => expenses
      .where((e) => e.type.toLowerCase() == 'income')
      .fold(0.0, (sum, item) => sum + item.amount);

  double get totalExpense => expenses
      .where((e) => e.type.toLowerCase() == 'expense')
      .fold(0.0, (sum, item) => sum + item.amount);

  // Total balance = Income - Expenses
  double get totalBalance => totalIncome - totalExpense;

  // Daily Average (Calculated based on today's expenses)
  double get dailyAverage {
    final now = DateTime.now();
    final todayExpenses = expenses.where((e) {
      try {
        final date = DateTime.parse(e.date);
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day &&
            e.type.toLowerCase() == 'expense';
      } catch (_) {
        return false;
      }
    });

    if (todayExpenses.isEmpty) return 0.0;
    return todayExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Weekly Total (Calculated for the last 7 days)
  double get weeklyAverage {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final weekExpenses = expenses.where((e) {
      try {
        final date = DateTime.parse(e.date);
        return date.isAfter(weekAgo) && e.type.toLowerCase() == 'expense';
      } catch (_) {
        return false;
      }
    });

    if (weekExpenses.isEmpty) return 0.0;
    return weekExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Helper date formatter
  String formatTransactionDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        return 'Today';
      } else if (date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day) {
        return 'Yesterday';
      }
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  // READ: Load saved expenses from SQLite
  Future<void> loadExpenses() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _database.getExpenses();
      expenses.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Unable to load expenses.';
      debugPrint('Load expenses error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // CREATE: Save a new expense
  Future<void> addExpense(Expense expense) async {
    try {
      final id = await _database.insertExpense(expense);

      expenses.insert(
        0,
        Expense(
          id: id,
          title: expense.title,
          amount: expense.amount,
          category: expense.category,
          date: expense.date,
          type: expense.type,
        ),
      );

      Get.snackbar('Success', 'Transaction saved successfully.');
    } catch (e) {
      debugPrint('Add expense error: $e');
      Get.snackbar('Error', 'Could not save transaction.');
    }
  }

  // UPDATE: Edit an existing expense
  Future<void> updateExpense(Expense expense) async {
    try {
      final rows = await _database.updateExpense(expense);

      if (rows > 0) {
        final index = expenses.indexWhere((item) => item.id == expense.id);
        if (index != -1) {
          expenses[index] = expense;
        }
        Get.snackbar('Success', 'Transaction updated.');
      } else {
        Get.snackbar('Info', 'Transaction not found.');
      }
    } catch (e) {
      debugPrint('Update expense error: $e');
      Get.snackbar('Error', 'Could not update transaction.');
    }
  }

  // DELETE: Remove an expense
  Future<void> deleteExpense(int id) async {
    try {
      final rows = await _database.deleteExpense(id);

      if (rows > 0) {
        expenses.removeWhere((item) => item.id == id);
        Get.snackbar('Success', 'Transaction deleted.');
      } else {
        Get.snackbar('Info', 'Transaction not found.');
      }
    } catch (e) {
      debugPrint('Delete expense error: $e');
      Get.snackbar('Error', 'Could not delete transaction.');
    }
  }
}