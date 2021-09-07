import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NewUserTransaction extends StatefulWidget {
  final Function addNewTransaction;

  NewUserTransaction({required this.addNewTransaction});

  @override
  _NewUserTransactionState createState() => _NewUserTransactionState();
}

class _NewUserTransactionState extends State<NewUserTransaction> {
  final _titleInputController = TextEditingController();
  final _amountInputController = TextEditingController();
  DateTime? _selectedDate;

  void submitData() {
    if (_amountInputController.text.isEmpty) return;
    var title = _titleInputController.text;
    var amount = double.parse(_amountInputController.text);

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addNewTransaction(
      title,
      amount,
      _selectedDate
    );

    //hide the modal dialog after adding the transaction
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate == null) return;
      setState(() {
        _selectedDate = selectedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleInputController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountInputController,
              keyboardType: TextInputType.number,
              //onSubmitted -> keyboard done functionality
              // onSubmitted: (value)=> submitData(), it requires parameter
              //#case2 onSubmitted: submitData, => other way we can use onSubmitted , we need to define in such a way that , method should receive parameter
              onSubmitted: (_) =>
                  submitData(), // I don't care about the parameter , at that case we can use _ operator
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date Selected'
                        : 'Picked Date ${DateFormat.yMMMd().format(_selectedDate!)}',
                  ),
                ),
                FlatButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
            RaisedButton(
              color: Colors.purple,
              textColor: Colors.white,
              onPressed: submitData,
              child: Text("Add Transaction"),
            )
          ],
        ),
      ),
    );
  }
}
