// ignore_for_file: lines_longer_than_80_chars

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
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
  });

  group('hasOperator', () {
    test('returns true when operator is present', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      expect(operation.hasOperator, isTrue);
    });

    test('returns false when operator is null', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: null,
      );
      expect(operation.hasOperator, isFalse);
    });

    test('returns false when operator is an empty string', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '',
      );
      expect(operation.hasOperator, isFalse);
    });
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

  group('deleteLastCharacter', () {
    test('removes last character of last operand', () {
      const TSimpleOperation operation = TSimpleOperation(
        operands: ['12', '34'],
        operator: '+',
      );

      final TSimpleOperation updatedOperation = operation.deleteLastCharacter();

      expect(updatedOperation.operands, equals(['12', '3']));
      expect(updatedOperation.operator, equals('+'));
    });

    test('removes the operator if there is only one operand', () {
      const TSimpleOperation operation = TSimpleOperation(
        operands: ['123'],
        operator: '*',
      );

      final TSimpleOperation updatedOperation = operation.deleteLastCharacter();

      expect(updatedOperation.operands, equals(['123']));
      expect(updatedOperation.operator, equals(null));
    });

    test('returns empty operation if there are no operands left', () {
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

  group('lastOperand', () {
    test('returns the last operand', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      expect(operation.lastOperand, equals('3'));
    });

    test('returns an empty string when there are no operands', () {
      const operation = TSimpleOperation(
        operands: [],
        operator: '+',
      );
      expect(operation.lastOperand, equals(''));
    });

    test('returns an empty string when the last operand is empty', () {
      const operation = TSimpleOperation(
        operands: ['2'],
        operator: '+',
      );
      expect(operation.lastOperand, equals(''));
    });

    test('returns the only operand when the operation has only one operand',
        () {
      const operation = TSimpleOperation(
        operands: ['2'],
        operator: null,
      );
      expect(operation.lastOperand, equals('2'));
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

    test('should not add a decimal point if last operand already has one', () {
      const operation = TSimpleOperation(
        operands: ['1', '23.'],
        operator: '+',
      );

      final updatedOperation = operation.append('.');

      expect(updatedOperation.operands, ['1', '23.']);
      expect(updatedOperation.operator, '+');
    });

    test('should add a zero with a decimal point if last operand is empty', () {
      const operation = TSimpleOperation(operands: ['1', ''], operator: '+');
      final updatedOperation = operation.append('.');

      expect(updatedOperation.operands, ['1', '0.']);
      expect(updatedOperation.operator, '+');
    });

    test('should add a zero with a decimal point if last operand is null', () {
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

    test('should update the operator', () {
      const operation = TSimpleOperation(operands: ['1'], operator: '+');
      final updatedOperation = operation.append('*');

      expect(updatedOperation.operands, ['1']);
      expect(updatedOperation.operator, '*');
    });
  });

  group('evaluate', () {
    test('evaluates a simple addition operation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      final result = operation.evaluate();
      expect(result.operands, equals(['2', '3']));
      expect(result.operator, equals('+'));
      expect(result.result, equals('5'));
    });

    test('evaluates a simple subtraction operation', () {
      const operation = TSimpleOperation(
        operands: ['3', '2'],
        operator: '-',
      );
      final result = operation.evaluate();
      expect(result.operands, equals(['3', '2']));
      expect(result.operator, equals('-'));
      expect(result.result, equals('1'));
    });

    test('evaluates a simple multiplication operation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '×',
      );
      final result = operation.evaluate();
      expect(result.operands, equals(['2', '3']));
      expect(result.operator, equals('×'));
      expect(result.result, equals('6'));
    });

    test('evaluates a simple division operation', () {
      const operation = TSimpleOperation(
        operands: ['6', '3'],
        operator: '÷',
      );
      final result = operation.evaluate();
      expect(result.operands, equals(['6', '3']));
      expect(result.operator, equals('÷'));
      expect(result.result, equals('2'));
    });

    test(' don\'t evaluate the operation when not valid', () {
      const operation = TSimpleOperation(
        operands: ['2', ''],
        operator: '+',
      );

      final result = operation.evaluate();
      expect(result.operands, equals(['2', '']));
      expect(result.operator, equals('+'));
      expect(result.result, equals(null));
    });

    test('throws an error if the result is not a number', () {
      const operation = TSimpleOperation(
        operands: ['2', '0'],
        operator: '÷',
      );
      expect(() => operation.evaluate(), throwsA(isA<Exception>()));
    });

    test(
        'should handle last operand as percentage if isLastOperandPercent is true',
        () {
      const operation = TSimpleOperation(
        isLastOperandPercent: true,
        operands: ['50', '75'],
        operator: '+',
      );

      final result = operation.evaluate();
      expect(result.result, equals('87.5'));
    });
  });

  group('clear', () {
    test('clears the current operation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final result = operation.clear();
      expect(result.operands, equals([]));
      expect(result.operator, equals(null));
      expect(result.result, equals(null));
    });

    test('returns a new instance of TSimpleOperation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final result = operation.clear();
      expect(result, isNot(same(operation)));
      expect(result, equals(const TSimpleOperation()));
    });
  });

  group('replaceLastOperand', () {
    test('replaceLastOperand when operands is empty', () {
      const operation = TSimpleOperation(
        operands: [],
        result: null,
      );

      final updatedOperation = operation.replaceLastOperand('5');

      expect(updatedOperation.operands, equals(['5']));
      expect(updatedOperation.result, equals(null));
    });

    test('replaces the last operand in a valid operation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      final result = operation.replaceLastOperand('5');
      expect(result.operands, equals(['2', '5']));
      expect(result.operator, equals('+'));
    });

    test('returns a new instance of TSimpleOperation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      final result = operation.replaceLastOperand('5');
      expect(result.operands, equals(['2', '5']));
      expect(result, isNot(same(operation)));
    });

    test(
        'returns the same instance of TSimpleOperation if the operation is invalid',
        () {
      const operation = TSimpleOperation(
        operands: ['2', ''],
        operator: '+',
      );
      final result = operation.replaceLastOperand('5');
      expect(result.operands, equals(['2', '5']));
      expect(result, isNot(same(operation)));
    });
  });

  group('deleteLastCharacter', () {
    test('deletes the last character in the current operand', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      final result = operation.deleteLastCharacter();
      expect(
          result.operands,
          equals([
            '2',
          ]));
      expect(result.operator, equals('+'));
    });

    test('deletes the last operand if it is empty', () {
      const operation = TSimpleOperation(
        operands: ['2', ''],
        operator: '+',
      );
      final result = operation.deleteLastCharacter();
      expect(result.operands, equals(['2']));
      expect(result.operator, equals('+'));
    });

    test(
        'deletes the operator if the last operand is empty and there is only one operand',
        () {
      const operation = TSimpleOperation(
        operands: ['2'],
        operator: '+',
      );
      final result = operation.deleteLastCharacter();
      expect(result.operands, equals(['2']));
      expect(result.operator, equals(null));
    });

    test('returns a new instance of TSimpleOperation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      final result = operation.deleteLastCharacter();
      expect(result, isNot(same(operation)));
    });
  });

  group('format', () {
    test('formats a simple addition operation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      final result = operation.format();
      expect(result, equals('2+3'));
    });

    test('formats a simple subtraction operation', () {
      const operation = TSimpleOperation(
        operands: ['4', '2'],
        operator: '-',
      );
      final result = operation.format();
      expect(result, equals('4-2'));
    });

    test('formats a simple multiplication operation', () {
      const operation = TSimpleOperation(
        operands: ['4', '2'],
        operator: '×',
      );
      final result = operation.format();
      expect(result, equals('4×2'));
    });

    test('formats a simple division operation', () {
      const operation = TSimpleOperation(
        operands: ['4', '2'],
        operator: '÷',
      );
      final result = operation.format();
      expect(result, equals('4÷2'));
    });

    test('formats an operation with decimal operands', () {
      const operation = TSimpleOperation(
        operands: ['2.5', '3'],
        operator: '+',
      );
      final result = operation.format();
      expect(result, equals('2.5+3'));
    });

    test('formats an operation with a negative operand', () {
      const operation = TSimpleOperation(
        operands: ['-2', '3'],
        operator: '+',
      );
      final result = operation.format();
      expect(result, equals('-2+3'));
    });

    test('formats an operation with a negative result', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '-',
        result: '-1',
      );
      final result = operation.format();
      expect(result, equals('2-3=-1'));
    });

    test('formats an operation with a positive result', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final result = operation.format();
      expect(result, equals('2+3=5'));
    });

    test('formats an empty operation', () {
      const operation = TSimpleOperation(
        operands: [],
        operator: null,
        result: null,
      );
      final result = operation.format();
      expect(result, equals(''));
    });

    test(
        'should handle last operand as percentage if isLastOperandPercent is true',
        () {
      const operation = TSimpleOperation(
        isLastOperandPercent: true,
        operands: ['50', '75'],
        operator: '+',
        result: '87.5',
      );

      final formatted = operation.format();
      expect(formatted, '50+75%=87.5');
    });
  });

  group('toString', () {
    test('returns a string representation of a simple addition operation', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
      );
      final result = operation.toString();
      expect(result, equals('2+3'));
    });

    test('returns a string representation of a simple subtraction operation',
        () {
      const operation = TSimpleOperation(
        operands: ['4', '2'],
        operator: '-',
      );
      final result = operation.toString();
      expect(result, equals('4-2'));
    });

    test('returns a string representation of a simple multiplication operation',
        () {
      const operation = TSimpleOperation(
        operands: ['4', '2'],
        operator: '×',
      );
      final result = operation.toString();
      expect(result, equals('4×2'));
    });

    test('returns a string representation of a simple division operation', () {
      const operation = TSimpleOperation(
        operands: ['4', '2'],
        operator: '÷',
      );
      final result = operation.toString();
      expect(result, equals('4÷2'));
    });

    test(
        'returns a string representation of an operation with decimal operands',
        () {
      const operation = TSimpleOperation(
        operands: ['2.5', '3'],
        operator: '+',
      );
      final result = operation.toString();
      expect(result, equals('2.5+3'));
    });

    test(
        'returns a string representation of an operation with a negative operand',
        () {
      const operation = TSimpleOperation(
        operands: ['-2', '3'],
        operator: '+',
      );
      final result = operation.toString();
      expect(result, equals('-2+3'));
    });

    test(
        'returns a string representation of an operation with a negative result',
        () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '-',
        result: '-1',
      );
      final result = operation.toString();
      expect(result, equals('2-3=-1'));
    });

    test(
        'returns a string representation of an operation with a positive result',
        () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final result = operation.toString();
      expect(result, equals('2+3=5'));
    });

    test('returns an empty string for an empty operation', () {
      const operation = TSimpleOperation(
        operands: [],
        operator: null,
        result: null,
      );
      final result = operation.toString();
      expect(result, equals(''));
    });

    test(
        'should handle last operand as percentage if isLastOperandPercent is true',
        () {
      const operation = TSimpleOperation(
        isLastOperandPercent: true,
        operands: ['50', '75'],
        operator: '+',
        result: '87.5',
      );

      final formatted = operation.toString();
      expect(formatted, '50+75%=87.5');
    });
  });

  group('copyWith', () {
    test('returns a new object with the same operands, operator, and result',
        () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final newOperation = operation.copyWith();
      expect(newOperation, equals(operation));
    });

    test('returns a new object with the given operands', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final newOperands = ['4', '5'];
      final newOperation = operation.copyWith(operands: newOperands);
      expect(newOperation.operands, equals(newOperands));
      expect(newOperation.operator, equals(operation.operator));
      expect(newOperation.result, equals(operation.result));
    });

    test('returns a new object with the given operator', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      const newOperator = '-';
      final newOperation = operation.copyWith(operator: newOperator);
      expect(newOperation.operands, equals(operation.operands));
      expect(newOperation.operator, equals(newOperator));
      expect(newOperation.result, equals(operation.result));
    });

    test('returns a new object with the given result', () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      const newResult = '6';
      final newOperation = operation.copyWith(result: newResult);
      expect(newOperation.operands, equals(operation.operands));
      expect(newOperation.operator, equals(operation.operator));
      expect(newOperation.result, equals(newResult));
    });
  });

  group('merge', () {
    test('merges the operands, operator, and result of two operations', () {
      const operation1 = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      const operation2 = TSimpleOperation(
        operands: ['4', '5'],
        operator: '-',
        result: '9',
      );
      final mergedOperation = operation1.merge(operation2);
      expect(mergedOperation.operands, equals(['4', '5']));
      expect(mergedOperation.operator, equals('-'));
      expect(mergedOperation.result, equals('9'));
    });

    test('returns a new object with the merged properties', () {
      const operation1 = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      const operation2 = TSimpleOperation(
        operands: ['4', '5'],
        operator: '-',
        result: '9',
      );
      final mergedOperation = operation1.merge(operation2);
      expect(mergedOperation, isNot(same(operation1)));
      expect(mergedOperation, isNot(same(operation2)));
    });
  });

  group('clone', () {
    test('creates a new object with the same operands, operator, and result',
        () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final clonedOperation = operation.clone();
      expect(clonedOperation.operands, equals(operation.operands));
      expect(clonedOperation.operator, equals(operation.operator));
      expect(clonedOperation.result, equals(operation.result));
    });

    test('creates a new object that is not the same object as the original',
        () {
      const operation = TSimpleOperation(
        operands: ['2', '3'],
        operator: '+',
        result: '5',
      );
      final clonedOperation = operation.clone();
      expect(clonedOperation, isNot(same(operation)));
    });
  });
}
