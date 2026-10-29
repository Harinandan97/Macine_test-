import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/model.dart';
import '../../controller/controller.dart';
import '../editTransaction/edit.dart';


class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final HomeController controller = Get.find<HomeController>();

  static const Color primaryTeal = Color(0xFF337976);
  static const Color creditGreen = Color(0xFF2E9465);
  static const Color debitRed = Color(0xFFF05252);

  int? activeActionExpenseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryTeal,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryTeal),
          );
        }

        if (controller.expenses.isEmpty) {
          return const Center(
            child: Text(
              'No transactions recorded yet.',
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
            ),
          );
        }

        return RefreshIndicator(
          color: primaryTeal,
          onRefresh: () => controller.loadExpenses(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemCount: controller.expenses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              final expense = controller.expenses[index];
              return _buildTransactionRow(expense);
            },
          ),
        );
      }),
    );
  }

  Widget _buildTransactionRow(Expense item) {
    final bool isIncome = item.type.toLowerCase() == 'income';
    final amountText = isIncome
        ? '+ ₹ ${item.amount.toStringAsFixed(2)}'
        : '- ₹ ${item.amount.toStringAsFixed(2)}';
    final amountColor = isIncome ? creditGreen : debitRed;
    final isActionsVisible = activeActionExpenseId == item.id;

    return InkWell(
      onTap: () {
        setState(() {
          activeActionExpenseId = isActionsVisible ? null : item.id;
        });
      },
      child: Row(
        children: [
          // Title & Formatted Date
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E2428),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.formatTransactionDate(item.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Amount
          Padding(
            padding: EdgeInsets.only(
              right: isActionsVisible ? 12.0 : 20.0,
            ),
            child: Text(
              amountText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
          ),

          // Edit & Delete Action Buttons
          if (isActionsVisible) ...[
            Container(
              width: 44,
              height: 46,
              color: const Color(0xFFE2E4E8),
              child: IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.black87),
                onPressed: () {
                  setState(() => activeActionExpenseId = null);
                  Get.to(() => EditTransactionScreen(expense: item));
                },
              ),
            ),
            Container(
              width: 44,
              height: 46,
              color: const Color(0xFFEF4444),
              child: IconButton(
                icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                onPressed: () async {
                  if (item.id != null) {
                    await controller.deleteExpense(item.id!);
                    setState(() => activeActionExpenseId = null);
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}