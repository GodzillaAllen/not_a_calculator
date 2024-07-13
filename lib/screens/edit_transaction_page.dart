import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';
import '../data/models/transaction_data.dart';

class EditTransactionPage extends StatefulWidget {
  final TransactionData transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  // ignore: library_private_types_in_public_api
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final TransactionController controller = Get.find<TransactionController>();
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: widget.transaction.amount.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                double newAmount = double.tryParse(amountController.text) ??
                    widget.transaction.amount;
                TransactionData updatedTransaction = TransactionData(
                  id: widget.transaction.id,
                  description: widget.transaction.description,
                  amount: newAmount,
                  date: widget.transaction.date,
                );
                controller.updateTransaction(updatedTransaction);
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
