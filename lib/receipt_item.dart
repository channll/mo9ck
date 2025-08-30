import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'receipt_item.g.dart';

@HiveType(typeId: 1)
class ReceiptItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double price;

  @HiveField(2)
  final int quantity;

  ReceiptItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}
