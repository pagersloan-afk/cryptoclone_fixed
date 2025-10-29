import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/activity_widget.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // ✅ Send, Exchange, Deposit
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            'Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Colors.white,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Send'),
              Tab(text: 'Exchange'),
              Tab(text: 'Deposit'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ActivityWidget(), // Send
            ActivityWidget(), // Exchange
            ActivityWidget(), // Deposit
          ],
        ),
      ),
    );
  }
}
