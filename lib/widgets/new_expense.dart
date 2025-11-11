import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/rendering.dart';

// import 'package:intl/intl.dart';        'badel ma jib hadol l satren mn l file expense.dart,'
// final formatter = DateFormat.yMd();     'jebet l import l asesi te3u fa sar 3ndi access 3layon'

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}
// lama nesta3mel 'TextEditingController()' lezem dayman nesta3mel ma3a 'dispose()'
// fa mn5aber flutter eno lezem nem7iya lama ma ykun fi de3i la este3mela,
// la2ena betdal bel memory 7ata law batalna sheyfina
// kif mne3mel hal shi?  mn 5ilel 'dispose()'

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate; // variable of type date.
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    // dispose btesta3mal bas bel state class
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      // sta3malna await 7ata yentor l user la ye5tar date, w mn doun async ma fina nestamel await.
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      // hon 3m 2ul 8ayerli '_selectedDate' lal pickedDate (yalli 5taro l user) w ba3den 7ades l screen w 3redli yeh,
      _selectedDate =
          pickedDate; // mn dun 'setState' ra7 yet8ayar l date fe3liyan bs ma ra7 tet7adas l UI.
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(
      _amountController.text,
    ); // tryParse('hello') => null, tryParse('1.12') => 1.12
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'please make shure a valid title, amount, date and category was entered.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return; // la2en l input is invalid fa 'return' hon betwa2ef tenfiz l function
      // byu2af l code w ma bya3mel save lal data.
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount, // 3amlinlou validation
        date:
            _selectedDate!, // dart mfakertu momken ykun null lahek nehna akadna eno ma 7a ykun null bel '!'.
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, Constraints) {
        final width = Constraints.maxWidth;

        return SizedBox(
          height: double.infinity, // ya3ne bye5od l max height
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                _titleController, // hayde 3melneha bas la yet7afaz l 7aki bel textField
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            controller:
                                _amountController, // hayde 3melneha bas la yet7afaz l 7aki bel textField
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$', // byetla3li shakel dollar
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller:
                          _titleController, // hayde 3melneha bas la yet7afaz l 7aki bel textField
                      maxLength: 50,
                      decoration: const InputDecoration(label: Text('Title')
                      ),
                    ),
                  if (width >= 600)
                    Row(children: [
                      DropdownButton(
                        value:
                            _selectedCategory, // hala2 hek t2akadet eno l value ra7 yezhar 3al screen, hayde kenet e5er 5etwe 3melta.
                        items: Category.values
                            .map(
                              (
                                category,
                              ) // map sta3malta la 7awel kel 3onsor mn 'Category.values' la widget mn no3 'DropdownMenuItem',
                              => DropdownMenuItem(
                                // hayde el 'DropdownMenuItem' betmasel kel 3onsor bel list w byen3erdu 3al screen mn 5ilela.
                                value: category,
                                child: Text(
                                  // child l 3onsor l mar2i yalli bshufu 3al screen, 3adatan text.
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(), // ba3ed este5dem map bikun l result Iterable ye3ne mesh list,
                        // bas 'items' l mawjude bi 'DropdownButton' bte7tej list lahek 3melna call la 'toList'.
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            // hayde ma btetnafaz ella iza l value ma ken null.
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            // _selectedDate iza ken null, ma 7edadet date w traktu fadi tba3li 'No date selected',
                            // iza ma ken fadi 7etelli l selectedDate lakan w jbarto ma ykun null bi haydi '!'.
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ])
                  else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller:
                              _amountController, // hayde 3melneha bas la yet7afaz l 7aki bel textField
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$', // byetla3li shakel dollar
                            label: Text('Amount'),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            // _selectedDate iza ken null, ma 7edadet date w traktu fadi tba3li 'No date selected',
                            // iza ma ken fadi 7etelli l selectedDate lakan w jbarto ma ykun null bi haydi '!'.
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); //cancel
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ])
                  else
                  Row(
                    children: [
                      DropdownButton(
                        value:
                            _selectedCategory, // hala2 hek t2akadet eno l value ra7 yezhar 3al screen, hayde kenet e5er 5etwe 3melta.
                        items: Category.values
                            .map(
                              (
                                category,
                              ) // map sta3malta la 7awel kel 3onsor mn 'Category.values' la widget mn no3 'DropdownMenuItem',
                              => DropdownMenuItem(
                                // hayde el 'DropdownMenuItem' betmasel kel 3onsor bel list w byen3erdu 3al screen mn 5ilela.
                                value: category,
                                child: Text(
                                  // child l 3onsor l mar2i yalli bshufu 3al screen, 3adatan text.
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(), // ba3ed este5dem map bikun l result Iterable ye3ne mesh list,
                        // bas 'items' l mawjude bi 'DropdownButton' bte7tej list lahek 3melna call la 'toList'.
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            // hayde ma btetnafaz ella iza l value ma ken null.
                            _selectedCategory = value;
                          });
                        },
                      ),

                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); //cancel
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
