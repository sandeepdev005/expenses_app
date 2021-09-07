import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactionList;

  Chart({required this.transactionList});

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < transactionList.length; i++) {
        if (transactionList[i].date.day == weekDay.day &&
            transactionList[i].date.month == weekDay.month &&
            transactionList[i].date.year == weekDay.year) {
          totalSum += transactionList[i].amount;
        }
      }

      print("Weekday $weekDay");
      print("amount: $totalSum");
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 6,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  data['day'].toString(),
                  (data['amount'] as double),
                  totalSpending == 0
                      ? 0
                      : ((data['amount'] as double) / totalSpending),
                ),
              );
            }).toList()),
      ),
    );
  }
}
