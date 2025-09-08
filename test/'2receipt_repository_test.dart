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

    // Additional simple fool-proof tests

    test('saveReceipt() throws ArgumentError for null ID', () async {
      final badReceipt = Receipt(
        id: null,
        storeName: 'Store X',
        date: DateTime.now(),
        totalAmount: 9.99,
        items: [],
      );
      expect(() => repository.saveReceipt(receipt: badReceipt), throwsArgumentError);
    });

    test('saveReceipt() throws ArgumentError for empty ID', () async {
      final badReceipt = Receipt(
        id: '',
        storeName: 'Store Y',
        date: DateTime.now(),
        totalAmount: 1.99,
        items: [],
      );
      expect(() => repository.saveReceipt(receipt: badReceipt), throwsArgumentError);
    });

    test('saveReceipt() throws FormatException for invalid/corrupt Receipt', () async {
      final corruptReceipt = Receipt(
        id: 'corrupt',
        storeName: '',
        date: null,
        totalAmount: null,
        items: null,
      );
      expect(() => repository.saveReceipt(receipt: corruptReceipt), throwsFormatException);
    });

    test('saveReceipt() throws HiveError when box is closed', () async {
      final receipt = Receipt(
        id: 'closed',
        storeName: 'Closed Store',
        date: DateTime.now(),
        totalAmount: 5.55,
        items: [],
      );
      when(mockReceiptBox.put(any, any)).thenThrow(HiveError('Box is closed'));
      expect(() => repository.saveReceipt(receipt: receipt), throwsA(isA<HiveError>()));
    });

    test('saveReceipt() throws FileSystemException when disk is full', () async {
      final receipt = Receipt(
        id: 'diskfull',
        storeName: 'Disk Full Store',
        date: DateTime.now(),
        totalAmount: 7.77,
        items: [],
      );
      when(mockReceiptBox.put(any, any)).thenThrow(FileSystemException('No space left on device'));
      expect(() => repository.saveReceipt(receipt: receipt), throwsA(isA<FileSystemException>()));
    });

    test('saveReceipt() throws TypeError for wrong type', () async {
      when(mockReceiptBox.put(any, any)).thenThrow(TypeError());
      expect(() => repository.saveReceipt(receipt: 'not_a_receipt' as dynamic), throwsA(isA<TypeError>()));
    });

    test('getReceipts() returns empty list for corrupt data', () async {
      when(mockReceiptBox.values).thenThrow(FormatException('Corrupt data'));
      final result = await repository.getReceipts();
      expect(result, isEmpty);
    });

    test('getReceipts() returns empty list if any error thrown', () async {
      when(mockReceiptBox.values).thenThrow(Exception('Any error'));
      final result = await repository.getReceipts();
      expect(result, isEmpty);
    });
  });
}
