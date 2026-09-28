import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class TransactionItem {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final IconData icon;
  final TransactionType type;

  const TransactionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.type,
  });
}

class CardInfo {
  final String holderName;
  final String lastDigits;
  final String expiry;

  const CardInfo({
    required this.holderName,
    required this.lastDigits,
    required this.expiry,
  });
}


const String userName = 'budi';
const CardInfo currentCard = CardInfo(
  holderName: 'yanto budi',
  lastDigits: '6767',
  expiry: '12/26',
);

final ValueNotifier<double> balanceNotifier = ValueNotifier<double>(2500000000);

final ValueNotifier<List<TransactionItem>> transactionsNotifier =
    ValueNotifier<List<TransactionItem>>([

]);

void addTransaction(TransactionItem item) {
  transactionsNotifier.value = [item, ...transactionsNotifier.value];
  balanceNotifier.value +=
      item.type == TransactionType.income ? item.amount : -item.amount;
}

String greetingByTime() {
  final h = DateTime.now().hour;
  if (h < 11) return 'Selamat pagi,';
  if (h < 15) return 'Selamat siang,';
  if (h < 18) return 'Selamat sore,';
  return 'Selamat malam,';
}

String formatRupiah(double value) {
  final s = value.round().toString();
  final withDots = s.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.',
  );
  return 'Rp $withDots';
}