
import 'package:flutter/material.dart';

import '../Home/Home.dart';

void main(){
  runApp(MaterialApp(home: Onboarding(),));
}
class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  static const Color teal = Color(0xFF348780);
  static const Color mint = Color(0xFFEAF6F4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top illustration
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: mint,
                child: Image.asset(
                  'assets/images/Screenshot 2026-10-29 111553.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 120,
                      color: teal,
                    );
                  },
                ),
              ),
            ),

            // Bottom content
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Spend Smarter\nSave More',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.15,
                        fontWeight: FontWeight.bold,
                        color: teal,
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  Home(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5BAFA5),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: teal.withValues(alpha: 0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


