import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreditItem {
  final String title;
  final String dueDate;
  final bool isDueToday;
  final String planType;
  final double amount;

  CreditItem({
    required this.title,
    required this.dueDate,
    this.isDueToday = false,
    required this.planType,
    required this.amount,
  });
}

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});

  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  static const Color primaryTeal = Color(0xFF2C7E77);

  String selectedCreditType = 'Subscriptions';
  final List<String> creditTypes = ['Subscriptions', 'Loans', 'Bills', 'Personal'];

  final TextEditingController toController = TextEditingController(text: 'Netflix');

  DateTime selectedDate = DateTime(2026, 2, 22);

  String selectedPlanType = 'Monthly';
  final List<String> planTypes = ['Monthly', 'One-Time', 'Weekly', 'Yearly'];

  // Sample Saved Lists matching the design
  final List<CreditItem> savedLists = [
    CreditItem(
      title: 'Netflix',
      dueDate: 'Today',
      isDueToday: true,
      planType: 'Monthly',
      amount: 850.00,
    ),
    CreditItem(
      title: 'Rohith',
      dueDate: 'Due On 10/12/26',
      isDueToday: false,
      planType: 'One-Time',
      amount: 18500.00,
    ),
  ];

  @override
  void dispose() {
    toController.dispose();
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Credit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Form Container
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CREDIT TYPE
                    _buildFieldLabel('CREDIT TYPE'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedCreditType,
                      items: creditTypes,
                      onChanged: (val) {
                        if (val != null) setState(() => selectedCreditType = val);
                      },
                    ),
                    const SizedBox(height: 18),

                    // TO
                    _buildFieldLabel('TO'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: toController,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFE5E5EA), width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: primaryTeal, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // DATE
                    _buildFieldLabel('DATE'),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                              style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                            ),
                            const Icon(Icons.calendar_today, size: 18, color: Color(0xFF8E8E93)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // PLAN TYPE
                    _buildFieldLabel('PLAN TYPE'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedPlanType,
                      items: planTypes,
                      onChanged: (val) {
                        if (val != null) setState(() => selectedPlanType = val);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle save action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryTeal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
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
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Your Saved Lists Section Header
              const Text(
                'Your Saved Lists',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Saved Lists ListView
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: savedLists.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = savedLists[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title & Due Tag
                      Column(
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
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
                              children: [
                                if (item.isDueToday) ...[
                                  const TextSpan(text: 'Due '),
                                  const TextSpan(
                                    text: 'Today',
                                    style: TextStyle(
                                      color: Color(0xFFE55353),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ] else ...[
                                  TextSpan(text: item.dueDate),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Plan Type & Amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.planType,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8E8E93),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹ ${NumberFormat('#,##,##0.00').format(item.amount)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2428),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF8E8E93),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8E8E93)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}