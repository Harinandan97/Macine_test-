
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onAddPressed;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onAddPressed,
  });

  static const Color teal = Color(0xFF30847E);
  static const Color fadedTeal = Color(0xFF5BAFA5);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: teal,
      height: 62,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      notchMargin: 7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(Icons.home_outlined, 0),
          _buildItem(Icons.history, 1),

          const SizedBox(width: 55),

          _buildItem(Icons.account_balance_wallet_outlined, 2),
          _buildItem(Icons.person_outline, 3),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, int index) {
    return IconButton(
      onPressed: () => onItemSelected(index),
      icon: Icon(
        icon,
        size: 25,
        color: selectedIndex == index
            ? Colors.white
            : Colors.white54,
      ),
    );
  }
}
