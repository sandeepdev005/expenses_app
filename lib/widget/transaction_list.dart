import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionsList;
  final Function deleteTransaction;

  TransactionList(
      {required this.transactionsList, required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: transactionsList.isEmpty
          ? Column(
              children: [
                Text('No Transaction added yet.',
                    style: Theme.of(context).textTheme.title),
                SizedBox(
                  height: 10,
                ), //Empty box for spacing purpose
                Container(
                  height: 200,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                            child:
                                Text('\$ ${transactionsList[index].amount}')),
                      ),
                    ),
                    title: Text(
                      '${transactionsList[index].title}',
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                        '${DateFormat.yMMMEd().format(transactionsList[index].date)}'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                      ),
                      onPressed: () =>
                          deleteTransaction(transactionsList[index].id),
                    ),
                  ),
                );
              },
              itemCount: transactionsList.length,
            ),
    );
  }
}

/* child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '\$${transactionsList[index].amount.toStringAsFixed(2)}',
                          /* style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),*/
                          style: Theme.of(context)
                              .textTheme
                              .title, //global text theme access from MaterialApp section
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactionsList[index].title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            // DateFormat('yyyy-MM-dd').format(tx.date),
                            // DateFormat().format(tx.date),
                            DateFormat.yMMMd()
                                .format(transactionsList[index].date),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),*/
