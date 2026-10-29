import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Model/model.dart';
import '../../controller/controller.dart';

class EditTransactionScreen extends StatefulWidget {
  final Expense expense;

  const EditTransactionScreen({super.key, required this.expense});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final HomeController controller = Get.find<HomeController>();

  static const Color primaryTeal = Color(0xFF2C7E77);

  late String selectedType;
  final List<String> transactionTypes = ['Expense', 'Income', 'Transfer'];

  late TextEditingController nameController;
  late TextEditingController amountController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    // Normalize type to match dropdown options
    selectedType = transactionTypes.firstWhere(
          (t) => t.toLowerCase() == widget.expense.type.toLowerCase(),
      orElse: () => 'Expense',
    );
    nameController = TextEditingController(text: widget.expense.title);
    amountController = TextEditingController(
      text: widget.expense.amount.toStringAsFixed(2),
    );

    try {
      selectedDate = DateTime.parse(widget.expense.date);
    } catch (_) {
      selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryTeal,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryTeal,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Transaction',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TRANSACTION TYPE
                      const Text(
                        'TRANSACTION TYPE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFE5E5EA),
                            width: 1.2,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedType,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF8E8E93),
                            ),
                            items: transactionTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(
                                  type,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => selectedType = newValue);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // NAME
                      const Text(
                        'NAME',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF333333),
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E5EA),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: primaryTeal,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // AMOUNT
                      const Text(
                        'AMOUNT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: primaryTeal,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          prefixText: '₹ ',
                          prefixStyle: const TextStyle(
                            fontSize: 14,
                            color: primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                          suffixIcon: TextButton(
                            onPressed: () => amountController.clear(),
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                color: primaryTeal,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: primaryTeal,
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: primaryTeal,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // DATE
                      const Text(
                        'DATE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE5E5EA),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('EEE, dd MMM yyyy')
                                    .format(selectedDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Color(0xFF8E8E93),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Full-width Save Pill Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final amount = double.tryParse(amountController.text.trim());

                    if (name.isEmpty || amount == null || amount <= 0) {
                      Get.snackbar(
                        'Invalid input',
                        'Please enter a valid title and amount.',
                      );
                      return;
                    }

                    await controller.updateExpense(
                      Expense(
                        id: widget.expense.id,
                        title: name,
                        amount: amount,
                        category: widget.expense.category,
                        date: selectedDate.toIso8601String(),
                        type: selectedType,
                      ),
                    );

                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}