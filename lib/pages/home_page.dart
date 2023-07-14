import 'package:expense/components/expense_summary.dart';
import 'package:expense/components/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';
import '../models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //  text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseRupeesController = TextEditingController();
  final newExpensePaiseController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // prepare data on startup
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  // add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense name",
              ),
            ),

            // expense amount
            Row(
              children: [
                // rupees
                Expanded(
                  child: TextField(
                    controller: newExpenseRupeesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Rupees",
                    ),
                  ),
                ),

                // paise
                Expanded(
                  child: TextField(
                    controller: newExpensePaiseController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Paise",
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        // save button
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          // cancel button
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  // save
  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseRupeesController.text.isNotEmpty &&
        newExpensePaiseController.text.isNotEmpty) {
      String amount =
          '${newExpenseRupeesController.text}.${newExpensePaiseController.text}';

      // create expense
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      // add the new expense
      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseRupeesController.clear();
    newExpensePaiseController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              // weekly summary
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),

              const SizedBox(
                height: 20,
              ),

              // expense list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                  name: value.getAllExpenseList()[index].name,
                  amount: value.getAllExpenseList()[index].amount,
                  dateTime: value.getAllExpenseList()[index].dateTime,
                  deleteTapped: (p0) => deleteExpense(
                    value.getAllExpenseList()[index],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
