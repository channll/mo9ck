import 'package:hive/hive.dart';
import 'package:your_app_name/receipt.dart';

class HiveReceiptRepository {
  final Box<Receipt> _receiptBox;

  HiveReceiptRepository(this._receiptBox);

  Future<void> saveReceipt({required Receipt receipt}) async {
    await _receiptBox.put(receipt.id, receipt);
  }

  Future<List<Receipt>> getReceipts() async {
    try {
      return _receiptBox.values.toList();
    } catch (e) {
      return [];
    }
  }
}
