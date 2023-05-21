import 'package:decimal/decimal.dart';
import 'package:t_helpers/helpers.dart';

/// Evaluates an arithmetic expression and returns the result as a `double`.
///
/// The `expression` parameter is a string that represents the arithmetic
/// expression to evaluate.
///
/// Example:
///
/// ```dart
/// void main() {
///   // Evaluate an arithmetic expression and print the result.
///   final result = evaluateExpression('2 * (3 + 4) / 5');
///   print(result); // Output: 2.80
/// }
/// ```
///
/// Returns the result of the arithmetic expression as a `double`.
double evaluateExpression(String expression) {
  int i = 0;

  if (expression.isEmpty) {
    throw Exception('Invalid expression');
  }

  // A recursive function that parses the expression and
  // returns the result as a Decimal.
  Decimal parseExpression() {
    List<Decimal> values = []; // A stack to store numeric values.
    List<String> operators = []; // A stack to store operators.
    Decimal lastNonOperatorValue = Decimal.one;

    // Iterate through the expression.
    while (i < expression.length) {
      if (expression[i] == ' ') {
        i++; // Ignore spaces.
      } else if (isOperator(expression[i])) {
        // If the current character is an operator.
        if (isNegativeUnaryOperator(expression, i)) {
          // If the current character is a unary operator,
          // parse the number with a negative sign.
          i++;
          int j = i;

          while (j < expression.length &&
              isCharDigitOrDecimalPointOrPercentage(expression[j])) {
            j++;
          }

          var substring = '-${expression.substring(i, j)}';
          var dValue = Decimal.parse(substring.replaceAll('%', ''));

          if (isStringPercentage(expression.substring(i, j)) &&
              (operators.isEmpty ||
                  operators.last == '+' ||
                  operators.last == '-')) {
            // Handle percentage operation for '+' or '-' operators.
            // Handle percentage operation for '+' or '-' operators.
            dValue = lastNonOperatorValue *
                (dValue / Decimal.fromInt(100))
                    .toDecimal(scaleOnInfinitePrecision: 32);
          }

          values.add(dValue); // Add the parsed number to the values stack.
          lastNonOperatorValue = dValue;
          i = j;
        } else {
          // If the current operator has lower or equal precedence than
          // the last operator in the stack, apply the last operator.
          while (operators.isNotEmpty &&
              precedence(expression[i]) <= precedence(operators.last)) {
            applyOperation(operators.removeLast(), values);
          }

          operators
              .add(expression[i]); // Add the current operator to the stack.
          i++;
        }
      } else if (expression[i] == '(') {
        // If the current character is an open parenthesis.
        i++;
        values.add(parseExpression()); // Call parseExpression recursively.
      } else if (expression[i] == ')') {
        // If the current character is a close parenthesis.
        i++;

        // Apply all remaining operators in the stack to the values
        // in the stack.
        while (operators.isNotEmpty) {
          applyOperation(operators.removeLast(), values);
        }

        return values.last; // Return the last value in the stack.
      } else {
        // If the current character is a digit or a decimal point.
        int j = i;

        while (j < expression.length &&
            isCharDigitOrDecimalPointOrPercentage(expression[j])) {
          j++;
        }

        var substring = expression.substring(i, j);
        var dValue = Decimal.parse(substring.replaceAll('%', ''));

        if (isStringPercentage(expression.substring(i, j)) &&
            (operators.isEmpty ||
                operators.last == '+' ||
                operators.last == '-')) {
          // Handle percentage operation for '+' or '-' operators.
          dValue = lastNonOperatorValue *
              (dValue / Decimal.fromInt(100))
                  .toDecimal(scaleOnInfinitePrecision: 32);
        }

        values.add(dValue); // Add the parsed number to the values stack.
        lastNonOperatorValue = dValue;
        i = j;
      }
    }

    // Apply any remaining operators in the stack to the values in the stack.
    while (operators.isNotEmpty) {
      applyOperation(operators.removeLast(), values);
    }

    return values.last; // Return the last value in the stack.
  }

  return parseExpression()
      .toDouble(); // Call parseExpression and convert the result to double.
}

/// Parses a simple mathematical operation expression and returns a
/// `TSimpleOperation` object that represents the operation.
///
/// The `expression` parameter is a string that represents the mathematical
/// operation in the format of "operand operator operand = result", where
/// `operand` is a number (positive or negative), `operator` is a mathematical
/// operator (`+`, `-`, `*`, `/`, `×`, or `÷`), and `result` is an optional
/// number that represents the result of the operation.
///
/// This function only supports simple operations with two operands and one
/// operator. If the input `expression` is not in the expected format, or if
/// the operands or operator are not valid, the function returns `null`.
///
/// Returns a `TSimpleOperation` object that represents the operation.
TSimpleOperation? parseSimpleOperation(String expression) {
  // Define a regular expression called `pattern` that matches the format of
  // "operand operator operand = result".
  final pattern = RegExp(
      r'^\s*(-?\d+(?:\.\d+)?)\s*([+\-*/×÷])\s*(-?\d+(?:\.\d+)?)(?:\s*=\s*(-?\d+(?:\.\d+)?))?\s*$');

  // Use the `firstMatch` method of the `RegExp` class to extract the operands,
  // operator, and result from the `expression` string.
  final match = pattern.firstMatch(expression);

  if (match == null) {
    // Return null if the expression doesn't match the expected format.
    return null;
  }

  // Extract the operands, operator, and result from the `Match` object.
  final operand1 = match.group(1);
  final operator = match.group(2);
  final operand2 = match.group(3);
  final result = match.group(4);

  if (operand1 == null || operator == null || operand2 == null) {
    // Return null if any of the operands or operator is null.
    return null;
  }

  return TSimpleOperation(
    operands: [operand1, operand2],
    operator: operator,
    result: result,
  );
}

/// Applies the given [operator] to the top two values in the [values] stack.
///
/// This function removes the two topmost values from the [values] list using
/// the [removeLast] method. It then performs the arithmetic operation based on
/// the input [operator] using a [switch] statement.
/// If the operator is '+' or '-', the function performs addition or
/// subtraction using the [Decimal] class. If the operator is '*' or '×',
/// the function performs multiplication using the [Decimal] class.
/// If the operator is '/' or '÷', the function performs division using
/// the [Decimal] class and rounds the result to 32 decimal places.
/// If the second value is zero, the function throws an exception.
/// Finally, the function adds the result of the operation back to the [values]
/// list using the [add] method.
void applyOperation(String operator, List<Decimal> values) {
  // Remove the top two values from the values stack.
  Decimal b = values.removeLast();
  Decimal a = values.removeLast();
  Decimal result;

  // Perform the operation based on the operator.
  switch (operator) {
    case '+':
      result = a + b;
      break;
    case '-':
      result = a - b;
      break;
    case '*':
    case '×':
      result = a * b;
      break;
    case '/':
    case '÷':
      if (b == Decimal.zero) throw Exception('Division by zero');
      result = (a / b).toDecimal(scaleOnInfinitePrecision: 32);
      break;
    default:
      throw Exception('Invalid operator: $operator');
  }

  // Add the result back to the values stack.
  values.add(result);
}

/// Returns `true` if [s] represents an arithmetic operator, `false` otherwise.
///
/// This function checks the input string against a set of predefined
/// arithmetic operators. If the input string matches any of the operators,
/// the function returns `true`. Otherwise, it returns `false`.
bool isOperator(String s) {
  return s == '+' || s == '-' || s == '*' || s == '/' || s == '×' || s == '÷';
}

/// Returns an integer representing the precedence level of
/// the given [operator].
///
/// This function returns 1 for addition and subtraction operators ('+' and '-')
/// and 2 for multiplication and division operators ('*', '/', '×', and '÷').
/// For any other operator, the function returns 0.
int precedence(String operator) {
  switch (operator) {
    case '+':
    case '-':
      return 1;
    case '*':
    case '/':
    case '×':
    case '÷':
      return 2;
  }

  // If the operator is anything else, return 0.
  return 0;
}

// Check whether a character in an expression is a negative unary operator.
bool isNegativeUnaryOperator(String expression, int index) {
  // If the index is invalid, the character cannot be a negative unary operator.
  if (index >= expression.length) {
    return false;
  }

  // Extract the character at the given index.
  String operator = expression.substring(index, index + 1);

  // If the character is not a minus sign,
  // it cannot be a negative unary operator.
  if (operator != '-') {
    return false;
  }

  // If the character is a minus sign, check if it's a negative unary operator
  // by examining the previous character in the expression.
  if (index == 0) {
    // If the minus sign is the first character in the expression, it is a
    // unary operator.
    return true;
  }

  // Extract the previous character in the expression.
  String prevChar = expression.substring(index - 1, index);

  // Check if the previous character is an operator, left parenthesis.
  // If it is any of these, then the minus sign is a unary operator.
  if (isOperator(prevChar) || prevChar == '(') {
    return true;
  }

  // If the previous character is not an operator, left parenthesis, or
  // space, the minus sign is not a unary operator.
  return false;
}

// Check whether a character in an expression is a digit, decimal point,
// or percentage sign.
bool isCharDigitOrDecimalPointOrPercentage(String s) {
  return isCharDigitOrDecimalPoint(s) || s == '%';
}
