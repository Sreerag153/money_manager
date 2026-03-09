import 'package:flutter/material.dart';
import 'package:money_manager_app/widget/floating_action_button.dart';
import 'package:money_manager_app/widget/summery_card.dart';
import 'package:provider/provider.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';
import 'package:money_manager_app/widget/colors.dart';
import 'package:money_manager_app/widget/drawer.dart';
import 'package:money_manager_app/widget/wallet_card.dart';
import 'package:money_manager_app/pages/add_expense.dart';
import 'package:money_manager_app/pages/add_income.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Monthly';
  final List<String> dropDownList = ['Monthly', 'Yearly', 'Weekly', 'Daily'];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

    final filtered = provider.filterTransactions(
      selectedDate: selectedDate,
      filterType: dropdownValue,
    );

    double inc = 0, exp = 0, accInc = 0, accExp = 0, cashInc = 0, cashExp = 0;

    for (var tx in filtered) {
      if (tx.type == 'income') {
        inc += tx.amount;
        tx.account == 'Account'
            ? accInc += tx.amount
            : cashInc += tx.amount;
      } else {
        exp += tx.amount;
        tx.account == 'Account'
            ? accExp += tx.amount
            : cashExp += tx.amount;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Money Manager',
          style: TextStyle(color: AppColors.moneyManagerTitle),
        ),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: ExpandableFab(
        onSelect: (type) {
          if (type == "expense") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddExpensePage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddIncomePage(),
              ),
            );
          }
        },
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SummaryCard(
                  dropdownValue: dropdownValue,
                  dropDownList: dropDownList,
                  selectedDate: selectedDate,
                  income: inc,
                  expense: exp,
                  onDateTap: pickDate,
                  onDropdownChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                WalletCard(
                  title: 'Bank Account',
                  icon: Icons.account_balance,
                  balance: accInc - accExp,
                  income: accInc,
                  expense: accExp,
                ),
                const SizedBox(height: 16),
                WalletCard(
                  title: 'Cash',
                  icon: Icons.wallet,
                  balance: cashInc - cashExp,
                  income: cashInc,
                  expense: cashExp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}