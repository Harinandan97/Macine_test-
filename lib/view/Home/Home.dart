import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/model.dart';
import '../../controller/controller.dart';
import '../../custom_widget/BottomNavigationbar.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Obx(() {
        if (controller.screens.isEmpty) {
          return const Center(
            child: Text('Expenzia Home'),
          );
        }

        final index = controller.selectedIndex.value;

        if (index < 0 || index >= controller.screens.length) {
          return const Center(child: Text('Screen not found'));
        }

        return controller.screens[index];
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        backgroundColor: const Color(0xFF5BAFA5),
        foregroundColor: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
        child: const Icon(Icons.add, size: 30),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Obx(
            () => CustomBottomBar(
          selectedIndex: controller.selectedIndex.value,
          onItemSelected: controller.changeTab,
          onAddPressed: () => _showAddExpenseDialog(context),
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final categoryController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Expense'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Expense title',
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                ),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final amount = double.tryParse(
                amountController.text.trim(),
              );
              final category = categoryController.text.trim();

              if (title.isEmpty ||
                  amount == null ||
                  amount <= 0 ||
                  category.isEmpty) {
                Get.snackbar(
                  'Invalid input',
                  'Enter a title, valid amount, and category.',
                );
                return;
              }

              await controller.addExpense(
                Expense(
                  title: title,
                  amount: amount,
                  category: category,
                  date: DateTime.now().toIso8601String(),
                ),
              );

              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      titleController.dispose();
      amountController.dispose();
      categoryController.dispose();
    });
  }
}