import 'package:expensetrackerapp/models/expense.dart';
import 'package:expensetrackerapp/widgets/expenselist/expenseitem.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.removeExpense});
  final List<Expense> expenses;
  final void Function(Expense expense) removeExpense;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
                vertical: 6),
          ),
          key: ValueKey(expenses[index]),
          onDismissed: (direction) {
            removeExpense(expenses[index]);
          },
          child: ExpenseItem(expenses[index])),
    );
  }
}
