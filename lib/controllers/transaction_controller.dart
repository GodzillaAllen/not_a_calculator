import 'package:get/get.dart';
import '../data/database_helper.dart';
import '../data/models/transaction_data.dart';

class TransactionController extends GetxController {
  var transactions = <TransactionData>[].obs;
  var filteredTransactions = <TransactionData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void fetchTransactions() async {
    final dbHelper = DatabaseHelper();
    final result = await dbHelper.queryAllTransactions();
    transactions.value = result.map((e) => TransactionData.fromMap(e)).toList();
    filteredTransactions.value = transactions;
  }

  void addTransaction(TransactionData transaction) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.insertTransaction(transaction.toMap());
    fetchTransactions();
  }

  void deleteTransaction(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteTransaction(id);
    fetchTransactions();
  }

  void filterTransactions(DateTime startDate, DateTime endDate) {
    filteredTransactions.value = transactions.where((transaction) {
      return transaction.date.isAfter(startDate) &&
          transaction.date.isBefore(endDate);
    }).toList();
  }

  double calculateTotalAmount(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return transactions.fold(0, (sum, item) => sum + item.amount);
    }
    return filteredTransactions.fold(0, (sum, item) => sum + item.amount);
  }

  void updateTransaction(TransactionData transaction) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.updateTransaction(transaction);
    fetchTransactions();
  }
}
