import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';
import 'package:your_app_name/receipt_repository.dart';
import 'package:your_app_name/receipt.dart';

// Import the generated mock file.
import 'receipt_repository_test.mocks.dart';

// Use this annotation to generate a mock for the Hive Box.
@GenerateMocks([Box])
void main() {
  late HiveReceiptRepository repository;
  late MockBox<Receipt> mockReceiptBox;

  setUp(() {
    mockReceiptBox = MockBox<Receipt>();
    repository = HiveReceiptRepository(mockReceiptBox);
  });

  group('HiveReceiptRepository', () {
    test('saveReceipt() should call put() on the Hive box', () async {
      final newReceipt = Receipt(
        id: '123',
        storeName: 'Mock Store',
        date: DateTime.now(),
        totalAmount: 15.50,
        items: [
          ReceiptItem(name: 'Mock Item', price: 15.50, quantity: 1),
        ],
      );

      when(mockReceiptBox.put(any, any)).thenAnswer((_) => Future.value());

      await repository.saveReceipt(receipt: newReceipt);

      verify(mockReceiptBox.put('123', newReceipt)).called(1);
    });

    test('getReceipts() should return a list of receipts from the Hive box', () async {
      final receipts = [
        Receipt(id: '1', storeName: 'Store A', date: DateTime.now(), totalAmount: 10.0, items: []),
        Receipt(id: '2', storeName: 'Store B', date: DateTime.now(), totalAmount: 20.0, items: []),
      ];

      when(mockReceiptBox.values).thenReturn(receipts);

      final result = await repository.getReceipts();

      expect(result, equals(receipts));
    });

    test('getReceipts() should return an empty list on a Hive error', () async {
      when(mockReceiptBox.values).thenThrow(Exception('Hive get failed!'));

      final result = await repository.getReceipts();

      expect(result, isEmpty);
    });
  });
}
