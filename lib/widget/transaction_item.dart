import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';


class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transactions,
    required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child:
                FittedBox(child: Text('\$ ${transactions.amount}')),
          ),
        ),
        title: Text(
          '${transactions.title}',
          style: Theme.of(context).textTheme.title,
        ),
        subtitle:
            Text('${DateFormat.yMMMEd().format(transactions.date)}'),
        trailing: MediaQuery.of(context).size.width > 300
            ? FlatButton.icon(
                onPressed: () => deleteTransaction(transactions.id),
                icon: Icon(Icons.delete),
                textColor: Theme.of(context).errorColor,
                label: const Text('Delete'))
            : IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => deleteTransaction(transactions.id),
              ),
      ),
    );
  }
}
