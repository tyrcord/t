import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  group('TSimpleOperation', () {
    test('should format operands without operator and result', () {
      const operation = TSimpleOperation(
        operands: ['2'],
        operator: '',
      );
      expect(operation.toString(), equals('2'));
    });

    test('should format on operand and operator without result', () {
      const operation = TSimpleOperation(
        operands: ['2'],
        operator: '+',
      );
      expect(operation.toString(), equals('2+'));
    });

    test('should format operands and operator without result', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      expect(operation.toString(), equals('2+3'));
    });

    test('should format operands and operator with integer result', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '-',
        result: '-1',
      );
      expect(operation.toString(), equals('2-3=-1'));
    });

    test('should format operands and operator with double result', () {
      const operation = TSimpleOperation(
        operands: ['2.5', '3.3'],
        operator: '*',
        result: '8.25',
      );
      expect(operation.toString(), equals('2.5*3.3=8.25'));
    });

    test('should format operands and operator with zero result', () {
      const operation = TSimpleOperation(
        operands: ['0', '5'],
        operator: '/',
        result: '0',
      );
      expect(operation.toString(), equals('0/5=0'));
    });

    group('isValid', () {
      test('should be valid if operands and operator are not empty', () {
        const operation = TSimpleOperation(
          operands: ['2', '3'],
          operator: '+',
        );
        expect(operation.isValid, isTrue);
      });

      test('should not be valid if operands are empty', () {
        const operation = TSimpleOperation(
          operands: [],
          operator: '+',
        );
        expect(operation.isValid, isFalse);
      });

      test('should not be valid if there is only one operands', () {
        const operation = TSimpleOperation(
          operands: ['-8'],
          operator: '+',
        );
        expect(operation.isValid, isFalse);
      });

      test('should not be valid if an operand is empty', () {
        const operation = TSimpleOperation(
          operands: ['2', ''],
          operator: '+',
        );
        expect(operation.isValid, isFalse);
      });

      test('should not be valid if operator is empty', () {
        const operation = TSimpleOperation(
          operands: ['2', '3'],
          operator: '',
        );
        expect(operation.isValid, isFalse);
      });

      test('should not be valid if an operand is not valid', () {
        TSimpleOperation operation = const TSimpleOperation(
          operands: ['2', '-'],
          operator: '+',
        );
        expect(operation.isValid, isFalse);

        operation = const TSimpleOperation(
          operands: ['2', '0.'],
          operator: '+',
        );

        expect(operation.isValid, isTrue);
      });
    });

    test('deleteLastCharacter() removes last character of last operand', () {
      const TSimpleOperation operation = TSimpleOperation(
        operands: ['12', '34'],
        operator: '+',
      );

      final TSimpleOperation updatedOperation = operation.deleteLastCharacter();

      expect(updatedOperation.operands, equals(['12', '3']));
      expect(updatedOperation.operator, equals('+'));
    });

    test(
        '''deleteLastCharacter() removes the operator'''
        '''if there is only one operand''', () {
      const TSimpleOperation operation = TSimpleOperation(
        operands: ['123'],
        operator: '*',
      );

      final TSimpleOperation updatedOperation = operation.deleteLastCharacter();

      expect(updatedOperation.operands, equals(['123']));
      expect(updatedOperation.operator, equals(null));
    });

    test(
        '''deleteLastCharacter() returns empty operation '''
        '''if there are no operands left''', () {
      const TSimpleOperation operation = TSimpleOperation(
        operands: ['1', '2'],
        operator: '*',
      );

      TSimpleOperation updatedOperation = operation.deleteLastCharacter();

      expect(updatedOperation.operands, equals(['1']));
      expect(updatedOperation.operator, equals('*'));

      updatedOperation = updatedOperation.deleteLastCharacter();

      expect(updatedOperation.operands, equals(['1']));
      expect(updatedOperation.operator, equals(null));

      updatedOperation = updatedOperation.deleteLastCharacter();

      expect(updatedOperation.operands, equals([]));
      expect(updatedOperation.operator, equals(null));

      updatedOperation = updatedOperation.deleteLastCharacter();

      expect(updatedOperation.operands, equals([]));
      expect(updatedOperation.operator, equals(null));
    });

    group('length', () {
      test('returns the correct length for an operation with one operand', () {
        const op = TSimpleOperation(operands: ['123']);
        expect(op.length, 3);
      });

      test(
          'returns the correct length for an operation with multiple operands and an operator',
          () {
        const op =
            TSimpleOperation(operands: ['123', '45', '678'], operator: '+');
        expect(op.length, 9);
      });

      test(
          'returns the correct length for an operation with no operands and a null operator',
          () {
        const op = TSimpleOperation(operands: [], operator: null);
        expect(op.length, 0);
      });

      test(
          'returns the correct length for an operation with no operands and a non-null operator',
          () {
        const op = TSimpleOperation(operands: [], operator: '+');
        expect(op.length, 1);
      });

      test(
          'returns the correct length for an operation with empty operands and a non-null operator',
          () {
        const op = TSimpleOperation(operands: ['', ''], operator: '-');
        expect(op.length, 1);
      });

      test(
          'returns the correct length for an operation with a null operator and non-null operands',
          () {
        const op = TSimpleOperation(operands: ['123', '456'], operator: null);
        expect(op.length, 6);
      });
    });

    group('isEmpty', () {
      test('returns true for a new TSimpleOperation object', () {
        const op = TSimpleOperation();
        expect(op.isEmpty, isTrue);
      });

      test('returns false for an operation with operands', () {
        const op = TSimpleOperation(operands: ['123']);
        expect(op.isEmpty, isFalse);
      });

      test('returns false for an operation with an operator', () {
        const op = TSimpleOperation(operator: '+');
        expect(op.isEmpty, isFalse);
      });

      test('returns false for an operation with a result', () {
        const op = TSimpleOperation(result: '123');
        expect(op.isEmpty, isFalse);
      });

      test('returns false for an operation with operands and an operator', () {
        const op = TSimpleOperation(operands: ['123'], operator: '+');
        expect(op.isEmpty, isFalse);
      });

      test('returns false for an operation with operands and a result', () {
        const op = TSimpleOperation(operands: ['123'], result: '456');
        expect(op.isEmpty, isFalse);
      });

      test('returns false for an operation with an operator and a result', () {
        const op = TSimpleOperation(operator: '+', result: '123');
        expect(op.isEmpty, isFalse);
      });

      test(
          'returns false for an operation with operands, an operator, and a result',
          () {
        const op =
            TSimpleOperation(operands: ['123'], operator: '+', result: '456');
        expect(op.isEmpty, isFalse);
      });
    });

    group('append', () {
      test('should add a number to the operands list', () {
        const operation = TSimpleOperation();
        final updatedOperation = operation.append('2');

        expect(updatedOperation.operands, ['2']);
      });

      test('should add a negative number to the operands list', () {
        const operation = TSimpleOperation();
        TSimpleOperation updatedOperation = operation.append('-');

        expect(updatedOperation.operands, ['-']);

        updatedOperation = updatedOperation.append('1');
        expect(updatedOperation.operands, ['-1']);
      });

      test('should add a number to the second operand', () {
        const operation = TSimpleOperation(operands: ['1'], operator: '+');
        final updatedOperation = operation.append('2');

        expect(updatedOperation.operands, ['1', '2']);
        expect(updatedOperation.operator, '+');
      });

      test('should add a decimal point to the last operand', () {
        const operation = TSimpleOperation(
          operands: ['1', '23'],
          operator: '+',
        );

        final updatedOperation = operation.append('.');

        expect(updatedOperation.operands, ['1', '23.']);
        expect(updatedOperation.operator, '+');
      });

      test('should not add a decimal point if last operand already has one',
          () {
        const operation = TSimpleOperation(
          operands: ['1', '23.'],
          operator: '+',
        );

        final updatedOperation = operation.append('.');

        expect(updatedOperation.operands, ['1', '23.']);
        expect(updatedOperation.operator, '+');
      });

      test('should add a zero with a decimal point if last operand is empty',
          () {
        const operation = TSimpleOperation(operands: ['1', ''], operator: '+');
        final updatedOperation = operation.append('.');

        expect(updatedOperation.operands, ['1', '0.']);
        expect(updatedOperation.operator, '+');
      });

      test('should add a zero with a decimal point if last operand is null',
          () {
        const operation = TSimpleOperation(operands: ['1'], operator: '+');
        final updatedOperation = operation.append('.');

        expect(updatedOperation.operands, ['1', '0.']);
        expect(updatedOperation.operator, '+');
      });

      test(' prevents multiple negative signs', () {
        const operation = TSimpleOperation();

        // Test appending a single negative sign
        var updatedOperation = operation.append('-');
        expect(updatedOperation.operands, ['-']);

        // Test appending multiple negative signs
        updatedOperation = updatedOperation.append('-');
        expect(updatedOperation.operands, ['-']);

        // Test appending negative sign after an operator
        updatedOperation = updatedOperation.append('+');
        updatedOperation = updatedOperation.append('-');
        expect(updatedOperation.operands, ['-']);
        expect(updatedOperation.operator, null);

        // Test appending multiple negative signs after an operator
        updatedOperation = updatedOperation.append('2');
        updatedOperation = updatedOperation.append('+');
        updatedOperation = updatedOperation.append('-');
        updatedOperation = updatedOperation.append('-');
        expect(updatedOperation.operands, ['-2']);
        expect(updatedOperation.operator, '-');

        // Test appending a digit after a negative sign
        updatedOperation = updatedOperation.append('-');
        updatedOperation = updatedOperation.append('5');
        expect(updatedOperation.operands, ['-2', '5']);
        expect(updatedOperation.operator, '-');

        // Test appending a negative sign after a digit
        updatedOperation = updatedOperation.append('-');
        expect(updatedOperation.operands, ['-2', '5']);
        expect(updatedOperation.operator, '-');
      });
    });

    test('should update the operator', () {
      const operation = TSimpleOperation(operands: ['1'], operator: '+');
      final updatedOperation = operation.append('*');

      expect(updatedOperation.operands, ['1']);
      expect(updatedOperation.operator, '*');
    });
  });
}
