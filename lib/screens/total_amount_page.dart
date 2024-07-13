import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_controller.dart';

class TotalAmountPage extends StatefulWidget {
  const TotalAmountPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TotalAmountPageState createState() => _TotalAmountPageState();
}

class _TotalAmountPageState extends State<TotalAmountPage> {
  final TransactionController controller = Get.find<TransactionController>();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = controller.calculateTotalAmount(
      _selectedDateRange?.start,
      _selectedDateRange?.end,
    );
    if (_selectedDateRange != null) {
      totalAmount = controller.calculateTotalAmount(
          _selectedDateRange!.start, _selectedDateRange!.end);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Amount'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _pickDateRange,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
