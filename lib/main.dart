import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './models/transaction.dart';
import './widget/transaction_list.dart';
import './widget/new_transaction.dart';
import './widget/chart.dart';

void main() {
  //Restrict the orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp()
        : MaterialApp(
            title: 'Expenses App',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
              fontFamily: 'Quicksand',
              errorColor: Colors.red,
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: "OpenSans"),
                  button: TextStyle(color: Colors.white)),
              appBarTheme: AppBarTheme(
                  textTheme: ThemeData.light().textTheme.copyWith(
                      title: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
            ),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;

  final titleInputController = TextEditingController();

  final amountInputController = TextEditingController();

  final List<Transaction> _userTransactions = [
    /* Transaction(
      id: "t1",
      title: "Shoes",
      amount: 23.63,
      date: DateTime.now(),
    ),
    Transaction(
      id: "t2",
      title: "Mobile",
      amount: 13.63,
      date: DateTime.now(),
    )*/
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }


  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String txTile, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTile,
      amount: txAmount,
      date: choosenDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void showAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {}, //Need to check use of tap
          child: NewUserTransaction(addNewTransaction: _addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  //builder methods returns single widget
  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Show Chart'),
        //use Switch.adaptive() -> Platform specific switch will be pick and display in the device
        Switch(
            value: _showChart,
            onChanged: (resultValue) {
              setState(() {
                _showChart = resultValue;
              });
            }),
      ],
    );
  }

  //call these methods as builder methods - returns multiple widget
  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        //MediaQuery.of(context).size.height -> includes status bar and appbar height
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                //MediaQuery.of(context).padding.top -> refers to status bar height
                mediaQuery.padding.top) *
            0.3,
        child: Chart(transactionList: _recentTransaction),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(
        context); //Maintain globally , if using more than one time
    final isLandScape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        "Flutter App",
        style: TextStyle(fontFamily: "Open Sans"),
      ),
      actions: [
        IconButton(
          onPressed: () => showAddNewTransaction(context),
          icon: Icon(
            Icons.add,
          ),
        )
      ],
    );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              //MediaQuery.of(context).padding.top -> refers to status bar height
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        transactionsList: _userTransactions,
        deleteTransaction: _deleteTransaction,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //optimized
            if (isLandScape) _buildLandscapeContent(),
            //optimized
            if (!isLandScape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),

            //not optimized
            if (isLandScape)
              _showChart
                  ? Container(
                      //MediaQuery.of(context).size.height -> includes status bar and appbar height
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              //MediaQuery.of(context).padding.top -> refers to status bar height
                              mediaQuery.padding.top) *
                          1,
                      child: Chart(transactionList: _recentTransaction),
                    )
                  : txListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //Checking platform , if Android then show floating button else dont show.
      //uses dart.io package for checking purpose
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showAddNewTransaction(context),
            )
          : Container(),
    );
  }
}
