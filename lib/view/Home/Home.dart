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

      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseDialog(context),
        backgroundColor: const Color(0xFF5BAFA5),
        foregroundColor: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: Colors.white, width: 4),
        ),
        child: const Icon(Icons.add, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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
    Get.dialog(
      const _AddExpenseDialogContent(),
      barrierDismissible: true,
    );
  }
}


class _AddExpenseDialogContent extends StatefulWidget {
  const _AddExpenseDialogContent();

  @override
  State<_AddExpenseDialogContent> createState() => _AddExpenseDialogContentState();
}

class _AddExpenseDialogContentState extends State<_AddExpenseDialogContent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final HomeController _controller = Get.find<HomeController>();

  @override
  void dispose() {

    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {

    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());
    final category = _categoryController.text.trim();

    if (title.isEmpty || amount == null || amount <= 0 || category.isEmpty) {
      Get.snackbar(
        'Invalid input',
        'Enter a title, valid amount, and category.',
      );
      return;
    }


    Navigator.of(context, rootNavigator: true).pop();

    // 3. Save to database
    await _controller.addExpense(
      Expense(
        title: title,
        amount: amount,
        category: category,
        date: DateTime.now().toIso8601String(),
        type: 'Expense',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Expense'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense title',
              ),
            ),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
              ),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}