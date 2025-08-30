import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:your_app_name/receipt_item.dart';

part 'receipt.g.dart';

@HiveType(typeId: 0)
class Receipt extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String storeName;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final double totalAmount;

  @HiveField(4)
  final List<ReceiptItem> items;

  Receipt({
    required this.id,
    required this.storeName,
    required this.date,
    required this.totalAmount,
    required this.items,
  });
}
