import './transaction_item.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionsList;
  final Function deleteTransaction;

  TransactionList(
      {required this.transactionsList, required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return transactionsList.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: [
                Text('No Transaction added yet.',
                    style: Theme.of(context).textTheme.title),
                SizedBox(
                  height: 10,
                ), //Empty box for spacing purpose
                Container(
                  height: constraint.maxHeight * 0.6,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(
                  transactions: transactionsList[index],
                  deleteTransaction: deleteTransaction);
            },
            itemCount: transactionsList.length,
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
