import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('EvaluateExpression', () {
    test('addition', () {
      expect(evaluateExpression('3+5'), 8.0);
      expect(evaluateExpression('3.4+5.6'), 9.0);
    });

    test('subtraction', () {
      expect(evaluateExpression('10-3'), 7.0);
      expect(evaluateExpression('10.45-3.76'), 6.69);
    });

    test('multiplication', () {
      expect(evaluateExpression('4*5'), 20.0);
      expect(evaluateExpression('4.56*5.75'), 26.22);
    });

    test('division', () {
      expect(evaluateExpression('15/3'), 5.0);
      expect(evaluateExpression('15/3.2'), 4.6875);
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

    test('division by zero', () {
      expect(() => evaluateExpression('15/0'), throwsA(isA<Exception>()));
    });

    test('invalid/non supported operator', () {
      expect(() => evaluateExpression('3+5^2'), throwsA(isA<Exception>()));
    });
  });

  // Test cases for isDigit function
  test('isDigit', () {
    expect(isDigit('0'), true);
    expect(isDigit('9'), true);
    expect(isDigit('.'), true);
    expect(isDigit('a'), false);
    expect(isDigit('+'), false);
  });

  // Test cases for precedence function
  test('precedence', () {
    expect(precedence('+'), 1);
    expect(precedence('-'), 1);
    expect(precedence('*'), 2);
    expect(precedence('/'), 2);
  });

  // Test cases for isOperator function
  test('isOperator', () {
    expect(isOperator('+'), true);
    expect(isOperator('-'), true);
    expect(isOperator('*'), true);
    expect(isOperator('/'), true);
    expect(isOperator('0'), false);
    expect(isOperator('9'), false);
    expect(isOperator('a'), false);
  });

  // Test cases for applyOperation function
  test('applyOperation', () {
    List<Decimal> values = [Decimal.fromInt(4), Decimal.fromInt(2)];
    applyOperation('+', values);
    expect(values.last, Decimal.fromInt(6));

    values = [Decimal.fromInt(4), Decimal.fromInt(2)];
    applyOperation('-', values);
    expect(values.last, Decimal.fromInt(2));

    values = [Decimal.fromInt(4), Decimal.fromInt(2)];
    applyOperation('*', values);
    expect(values.last, Decimal.fromInt(8));

    values = [Decimal.fromInt(4), Decimal.fromInt(2)];
    applyOperation('/', values);
    expect(values.last, Decimal.parse('2.0'));
  });
}
