import 'package:decimal/decimal.dart';
import 'package:t_helpers/models/models.dart';

// The main function that evaluates an arithmetic expression and
// returns the result as a double.
double evaluateExpression(String expression) {
  int i = 0;

  // A recursive function that parses the expression and
  // returns the result as a Decimal.
  Decimal parseExpression() {
    List<Decimal> values = []; // A stack to store numeric values.
    List<String> operators = []; // A stack to store operators.

    // Iterate through the expression.
    while (i < expression.length) {
      if (expression[i] == ' ') {
        i++; // Ignore spaces.
      } else if (isOperator(expression[i])) {
        // If the current character is an operator.
        if (isUnaryOperator(expression, i)) {
          // If the current character is a unary operator, parse the number with a negative sign.
          i++;
          int j = i;
          while (j < expression.length && isDigit(expression[j])) {
            j++;
          }
          var dValue = Decimal.parse('-${expression.substring(i, j)}');
          values.add(dValue); // Add the parsed number to the values stack.
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
        while (j < expression.length && isDigit(expression[j])) {
          j++;
        }

        var dValue = Decimal.parse(expression.substring(i, j));
        values.add(dValue); // Add the parsed number to the values stack.
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

// This function takes a string `operation` as input and returns a list of two
// lists, where the first list contains the operands and the second list
// contains the operators.
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

// Function to apply an operator to the top two values in the values stack.
void applyOperation(String operator, List<Decimal> values) {
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

  values.add(result); // Add the result back to the values stack.
}

// Function to check if a character is a digit or a decimal point.
bool isDigit(String char) =>
    (char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        char.codeUnitAt(0) <= '9'.codeUnitAt(0)) ||
    char == '.';

// Function to check if a character is an operator
bool isOperator(String s) =>
    s == '+' || s == '-' || s == '*' || s == '/' || s == '×' || s == '÷';

// Function to return the precedence of an operator
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

  return 0;
}

// Check whether a character in an expression is a unary operator.
bool isUnaryOperator(String expression, int index) {
  // If the index is invalid, the character cannot be a unary operator.
  if (index >= expression.length) {
    return false;
  }

  // Extract the character at the given index.
  String operator = expression.substring(index, index + 1);

  // If the character is not a minus sign, it cannot be a unary operator.
  if (operator != '-') {
    return false;
  }

  // If the character is a minus sign, check if it's a unary operator by
  // examining the previous character in the expression.
  if (index == 0) {
    // If the minus sign is the first character in the expression, it is a
    // unary operator.
    return true;
  }

  // Extract the previous character in the expression.
  String prevChar = expression.substring(index - 1, index);

  // Check if the previous character is an operator, left parenthesis, or
  // space. If it is any of these, then the minus sign is a unary operator.
  if (isOperator(prevChar) || prevChar == '(' || prevChar == ' ') {
    return true;
  }

  // If the previous character is not an operator, left parenthesis, or
  // space, the minus sign is not a unary operator.
  return false;
}
