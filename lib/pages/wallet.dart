import 'package:flutter/material.dart';
import 'package:money_manager_app/helper/wallet_components.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_app/provider/transaction_provider.dart';
import 'package:money_manager_app/provider/wallet_provider.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final walletProvider = context.watch<WalletProvider>();

    final allTx = txProvider.transactions..sort((a, b) => b.date.compareTo(a.date));
    final filteredTx = walletProvider.applyFilters(allTx);
    final grouped = walletProvider.groupByDate(filteredTx);
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        elevation: 0,
        title: const Text("Wallet", style: TextStyle(color: Color(0xff00FF62), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          BalanceCard(
            total: walletProvider.getTotalBalance(allTx),
            cash: walletProvider.getCashBalance(allTx),
            bank: walletProvider.getBankBalance(allTx),
          ),
          _buildFilterBar(context, walletProvider),
          Expanded(
            child: filteredTx.isEmpty
                ? const Center(child: Text("No transactions found", style: TextStyle(color: Colors.white70)))
                : ListView.builder(
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final dateKey = dates[index];
                      final items = grouped[dateKey]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              DateFormat('dd MMM yyyy').format(DateTime.parse(dateKey)),
                              style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...items.map((tx) => TransactionItem(tx: tx)),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context, WalletProvider walletProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          DropdownButton<String>(
            value: walletProvider.filterType,
            dropdownColor: const Color(0xff1E293B),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'all', child: Text("All")),
              DropdownMenuItem(value: 'income', child: Text("Income")),
              DropdownMenuItem(value: 'expense', child: Text("Expense")),
            ],
            onChanged: (v) => walletProvider.setFilterType(v!),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context, 
                firstDate: DateTime(2020), 
                lastDate: DateTime.now()
              );
              walletProvider.setRange(picked);
            },
          ),
        ],
      ),
    );
  }
}