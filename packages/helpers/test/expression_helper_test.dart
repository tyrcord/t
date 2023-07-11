import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('EvaluateExpression', () {
    test('addition', () {
      expect(evaluateExpression('3+5'), 8.0);
      expect(evaluateExpression('3.4+5.6'), 9.0);
      expect(evaluateExpression('-8+2'), -6.0);
      expect(evaluateExpression('-8.5+2'), -6.5);
      expect(evaluateExpression('8+0.'), 8);
    });

    test('subtraction', () {
      expect(evaluateExpression('10-3'), 7.0);
      expect(evaluateExpression('10.45-3.76'), 6.69);
      expect(evaluateExpression('-9-9'), -18);
      expect(evaluateExpression('-9-9.5'), -18.5);
    });

    test('multiplication', () {
      expect(evaluateExpression('4*5'), 20.0);
      expect(evaluateExpression('4.56*5.75'), 26.22);
      expect(evaluateExpression('4.56×5.75'), 26.22);
      expect(evaluateExpression('-9*-9'), 81);
    });

    test('division', () {
      expect(evaluateExpression('15/3'), 5.0);
      expect(evaluateExpression('15/3.2'), 4.6875);
      expect(evaluateExpression('15÷3.2'), 4.6875);
      expect(evaluateExpression('-9/-9'), 1);
    });

    test('combined operations', () {
      expect(evaluateExpression('3/5+2'), 2.6);
      expect(evaluateExpression('3*5+2'), 17.0);
      expect(evaluateExpression('3-5+2'), 0);
      expect(evaluateExpression('3+5+2'), 10);
      expect(evaluateExpression('3/5-2'), -1.4);
      expect(evaluateExpression('3*5-2'), 13.0);
      expect(evaluateExpression('3-5-2'), -4);
      expect(evaluateExpression('3+5-2'), 6);
      expect(evaluateExpression('3+5*2'), 13.0);
      expect(evaluateExpression('3-5*2'), -7.0);
      expect(evaluateExpression('3*5*2'), 30.0);
      expect(evaluateExpression('3/5*2'), 1.2);
      expect(evaluateExpression('3+5/2'), 5.5);
      expect(evaluateExpression('3-5/2'), 0.5);
      expect(evaluateExpression('3*5/2'), 7.5);
      expect(evaluateExpression('3/5/2'), 0.3);
      expect(evaluateExpression('10+2*6'), 22.0);
      expect(evaluateExpression('100-3*20'), 40.0);
      expect(evaluateExpression('67-(45/3)*5'), -8.0);
      expect(evaluateExpression('67-(45/3)*5'), -8.0);
      expect(evaluateExpression('(2+3)*(4+6)'), 50.0);
      expect(evaluateExpression('(6+10/2)-3*2'), 5.0);
    });

    test('evaluateExpression should handle percent sign', () {
      expect(evaluateExpression('100 + 10%'), equals(110.00));
      expect(evaluateExpression('100 + 10.5%'), equals(110.50));
      expect(evaluateExpression('10% + 10%'), equals(0.11));
      expect(evaluateExpression('50% + 10'), equals(10.5));

      expect(evaluateExpression('100 - 10%'), equals(90.00));
      expect(evaluateExpression('100 - 10.5%'), equals(89.50));
      expect(evaluateExpression('50% - 10'), equals(-9.5));
      expect(evaluateExpression('10% - 10%'), equals(0.09));

      expect(evaluateExpression('100 - 25% + 50'), equals(125.00));
    });

    test('division by zero', () {
      expect(() => evaluateExpression('15/0'), throwsA(isA<Exception>()));
    });

    test('invalid/non supported operator', () {
      expect(() => evaluateExpression('3+5^2'), throwsA(isA<Exception>()));
      expect(() => evaluateExpression(''), throwsA(isA<Exception>()));
    });
  });

  group('parseSimpleOperation', () {
    test('parses addition operation', () {
      const operation = '1 + 2';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['1', '2'],
            operator: '+',
          )));
    });

    test('parses subtraction operation', () {
      const operation = '3 - 4';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['3', '4'],
            operator: '-',
          )));
    });

    test('parses multiplication * operation', () {
      const operation = '5 * 6';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['5', '6'],
            operator: '*',
          )));
    });

    test('parses multiplication × operation', () {
      const operation = '5 × 6';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['5', '6'],
            operator: '×',
          )));
    });

    test('parses division ÷ operation', () {
      const operation = '7 ÷ 8';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['7', '8'],
            operator: '÷',
          )));
    });

    test('parses division / operation', () {
      const operation = '7 / 8';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['7', '8'],
            operator: '/',
          )));
    });

    test('parses operation with no spaces', () {
      const operation = '9+10';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['9', '10'],
            operator: '+',
          )));
    });

    test('Test with valid expression and result', () {
      expect(
          parseSimpleOperation('5 / 2 = 2.5'),
          const TSimpleOperation(
            operands: ['5', '2'],
            operator: '/',
            result: '2.5',
          ));

      expect(
          parseSimpleOperation('5 + 3 = 8'),
          const TSimpleOperation(
            operands: ['5', '3'],
            operator: '+',
            result: '8',
          ));
    });

    test('Test with valid expression and no result', () {
      expect(
          parseSimpleOperation('4 - 2'),
          const TSimpleOperation(
            operands: ['4', '2'],
            operator: '-',
          ));
    });

    test('parses operation with leading/trailing spaces', () {
      const operation = '   16   /   17  ';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['16', '17'],
            operator: '/',
          )));
    });

    test('Test with invalid input type', () {
      expect(parseSimpleOperation('5'), null);
    });

    test('Test with empty string', () {
      expect(parseSimpleOperation(''), null);
    });

    test('Test with invalid expression', () {
      expect(parseSimpleOperation('3 + * 2'), null);
    });

    test('parses negative number as first operand', () {
      const operation = '-9+6';
      final result = parseSimpleOperation(operation);

      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['-9', '6'],
            operator: '+',
          )));
    });

    test('parses negative number as second operand', () {
      const operation = '-9-6=-15';
      final result = parseSimpleOperation(operation);
      expect(
          result,
          equals(const TSimpleOperation(
            operands: ['-9', '6'],
            operator: '-',
            result: '-15',
          )));
    });
  });

  // Test cases for applyOperation function
  group('applyOperation', () {
    test('Applies addition correctly', () {
      final values = [Decimal.parse('1.23'), Decimal.parse('4.56')];
      applyOperation('+', values);
      expect(values, equals([Decimal.parse('5.79')]));
    });

    test('Applies subtraction correctly', () {
      final values = [Decimal.parse('7.89'), Decimal.parse('4.56')];
      applyOperation('-', values);
      expect(values, equals([Decimal.parse('3.33')]));
    });

    test('Applies multiplication correctly', () {
      final values = [Decimal.parse('1.23'), Decimal.parse('4.56')];
      applyOperation('*', values);
      expect(values, equals([Decimal.parse('5.6088')]));
    });

    test('Applies division correctly', () {
      final values = [Decimal.parse('7.89'), Decimal.parse('2.0')];
      applyOperation('/', values);
      expect(values, equals([Decimal.parse('3.945')]));
    });

    test('Applies multiplication with "×" correctly', () {
      final values = [Decimal.parse('1.23'), Decimal.parse('4.56')];
      applyOperation('×', values);
      expect(values, equals([Decimal.parse('5.6088')]));
    });

    test('Applies division with "÷" correctly', () {
      final values = [Decimal.parse('7.89'), Decimal.parse('2.0')];
      applyOperation('÷', values);
      expect(values, equals([Decimal.parse('3.945')]));
    });

    test('Throws exception for division by zero', () {
      final values = [Decimal.parse('7.89'), Decimal.zero];
      expect(() => applyOperation('/', values), throwsException);
    });

    test('Throws exception for invalid operator', () {
      final values = [Decimal.parse('1.23'), Decimal.parse('4.56')];
      expect(() => applyOperation('%', values), throwsException);
    });
  });

  // Test cases for isOperator function
  group('isOperator', () {
    test('Returns true for arithmetic operators', () {
      expect(isOperator('+'), isTrue);
      expect(isOperator('-'), isTrue);
      expect(isOperator('*'), isTrue);
      expect(isOperator('/'), isTrue);
      expect(isOperator('×'), isTrue);
      expect(isOperator('÷'), isTrue);
    });

    test('Returns false for non-operators', () {
      expect(isOperator(''), isFalse);
      expect(isOperator('abc'), isFalse);
      expect(isOperator('123'), isFalse);
      expect(isOperator('('), isFalse);
      expect(isOperator(')'), isFalse);
    });
  });

  // Test cases for precedence function
  group('precedence', () {
    test('Returns 1 for addition and subtraction', () {
      expect(precedence('+'), equals(1));
      expect(precedence('-'), equals(1));
    });

    test('Returns 2 for multiplication and division', () {
      expect(precedence('*'), equals(2));
      expect(precedence('/'), equals(2));
      expect(precedence('×'), equals(2));
      expect(precedence('÷'), equals(2));
    });

    test('Returns 0 for unknown operators', () {
      expect(precedence('%'), equals(0));
      expect(precedence('^'), equals(0));
      expect(precedence('#'), equals(0));
    });
  });

  // Test cases for isUnaryOperator function
  test('isUnaryOperator', () {
    expect(isNegativeUnaryOperator('2+3', 1), false);
    expect(isNegativeUnaryOperator('-2', 0), true);
    expect(isNegativeUnaryOperator('2--3', 2), true);
    expect(isNegativeUnaryOperator('2*-3', 1), false);
    expect(isNegativeUnaryOperator('2*-3', 1), false);
    expect(isNegativeUnaryOperator('2-(-3)', 1), false);
    expect(isNegativeUnaryOperator('2-(-3)', 3), true);
    expect(isNegativeUnaryOperator('- 2', 0), true);
    expect(isNegativeUnaryOperator('', 0), false);
  });
}
