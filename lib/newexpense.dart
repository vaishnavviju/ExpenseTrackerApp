import 'package:expensetrackerapp/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expensetrackerapp/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.addExpense, {super.key});
  final void Function(Expense expense) addExpense;
  @override
  State<NewExpense> createState() {
    return NewExpenseState();
  }
}

class NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amtController = TextEditingController();
  DateTime? selecteddate;
  Category selectedCategory = Category.leisure;
  void datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final chosenDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      selecteddate = chosenDate;
    });
  }

  void submitData() {
    final enteredAmount = double.tryParse(_amtController.text);
    final amountInvalid =
        enteredAmount == null || enteredAmount <= 0 ? true : false;
    if (_titleController.text.trim().isEmpty ||
        amountInvalid ||
        selecteddate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please make sure entered details are valid."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"))
          ],
        ),
      );
      return;
    }
    widget.addExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: selecteddate!,
          category: selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyspace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyspace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amtController,
                          maxLength: 5,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              selectedCategory = value;
                            });
                          }),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selecteddate == null
                                  ? 'No date selected'
                                  : formatter.format(selecteddate!),
                            ),
                            IconButton(
                                onPressed: datePicker,
                                icon: const Icon(Icons.calendar_month)),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amtController,
                          maxLength: 5,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$',
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              selecteddate == null
                                  ? 'No date selected'
                                  : formatter.format(selecteddate!),
                            ),
                            IconButton(
                                onPressed: datePicker,
                                icon: const Icon(Icons.calendar_month)),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: submitData,
                        child: const Text("Save Expense"),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                          value: selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value == null) {
                                return;
                              }
                              selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: submitData,
                        child: const Text("Save Expense"),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
