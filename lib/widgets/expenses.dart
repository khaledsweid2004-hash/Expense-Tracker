import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),

    Expense(
      title: 'cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true, // bet5aliya tefta7 3al screen kella.
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
       // showModalBottomSheet(context: context, builder: (ctx)
      // hayde l func b7eta metel ma hiye hek hiye 3ibara 3an war2a btetla3li w hek ye3ne return => betraje3li yalli badi ye
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(
      expense,
    ); // sta3malna l index 7ata lama nerja3 na3mel undo yerja3 l expense ma7alo mn 5ilel l index.
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar message fiya information btetla3li 3al screen
      SnackBar(
        duration: const Duration(seconds: 3), // undo betdal 3 seconds
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(
                expenseIndex,
                expense,
              ); // hon lama ekbos undo byerja3 l expense yalli nma7a ma7alo 7asab l index.
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; // MediaQuery hiye class bi flutter bta3tini info 3an l screen metel width, height...

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: width < 600 // 7atayna condition   (MediaQuery)
          ? Column(     // iza as8ar bidal column
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(        // iza akbar bye2lob row
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)), // hon 3melna wrap with expanded lal chart 
                Expanded(child: mainContent),                          // la2en ken fi error wa2et l run.
              ],
            ),
    );
  }
}