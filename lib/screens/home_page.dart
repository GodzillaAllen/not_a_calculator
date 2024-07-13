import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_controller.dart';
import 'add_transaction_page.dart';
import 'edit_transaction_page.dart';
import 'total_amount_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionController controller = Get.put(TransactionController());
  DateTimeRange? _selectedDateRange;

  void _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        controller.filterTransactions(picked.start, picked.end);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              Get.to(() => const TotalAmountPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactions[index];
            return ListTile(
              title: Text(transaction.description),
              subtitle: Text('\$${transaction.amount.toString()}'),
              trailing: Text(DateFormat('yyyy-MM-dd').format(transaction.date)),
              onTap: () {
                Get.to(() => EditTransactionPage(transaction: transaction));
              },
              onLongPress: () {
                controller.deleteTransaction(transaction.id!);
              },
              // onLongPress: () => controller.deleteTransaction(transaction.id!),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddTransactionPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
