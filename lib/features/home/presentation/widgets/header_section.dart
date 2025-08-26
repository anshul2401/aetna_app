import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Section
            Center(child: Image.asset('assets/images/logo.png', height: 32)),

            // Row(
            //   children: [
            //     Container(
            //       height: 32,
            //       width: 80,
            //       decoration: const BoxDecoration(
            //         color: Color(0xFF6B2C91),
            //         borderRadius: BorderRadius.all(Radius.circular(4)),
            //       ),
            //       child: const Center(
            //         child: Text(
            //           'aetna',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Container(
            //       height: 32,
            //       width: 50,
            //       decoration: const BoxDecoration(
            //         color: Color(0xFFE31837),
            //         borderRadius: BorderRadius.all(Radius.circular(4)),
            //       ),
            //       child: const Center(
            //         child: Text(
            //           'CVS',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const Spacer(),
            //     IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         Icons.account_circle_outlined,
            //         size: 28,
            //         color: Colors.grey[600],
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 18),

            // Welcome Section
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your benefits and claims',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
