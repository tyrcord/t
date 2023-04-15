import 'package:t_helpers/helpers.dart';
import 'package:tmodel/tmodel.dart';

/// A class representing a simple arithmetic operation with two operands
/// and one operator.
class TSimpleOperation extends TModel {
  final List<String> operands;
  final String? operator;
  final String? result;

  /// Constructs a new `TSimpleOperation` instance with the given operands,
  /// operator, and result.
  const TSimpleOperation({
    this.operands = const <String>[],
    this.operator,
    this.result,
  });

  /// Checks if the current operation is valid.
  bool get isValid {
    return operands.isNotEmpty &&
        operands.length == 2 &&
        operands.every((operand) => isStringNumber(operand)) &&
        (operator == null || operator!.isNotEmpty);
  }

  /// Checks if the current operation has an operator.
  bool get hasOperator {
    return operator != null && operator!.isNotEmpty;
  }

  /// Returns the total length of the current operation.
  int get length {
    return operands.fold<int>(0, (sum, operand) => sum + operand.length) +
        (operator?.length ?? 0);
  }

  /// Checks if the current operation is empty.
  bool get isEmpty {
    return operands.isEmpty && operator == null && result == null;
  }

  /// Returns the last operand of the current operation.
  String get lastOperand {
    if (operands.isNotEmpty) {
      if (operands.length == 1 && hasOperator) {
        return '';
      }

      return operands.last;
    }

    return '';
  }

  /// Replaces the last operand of the current operation with the given operand.
  TSimpleOperation replaceLastOperand(String operand) {
    final updatedOperands = List<String>.from(operands);
    updatedOperands.removeLast();
    updatedOperands.add(operand);

    return TSimpleOperation(
      operands: updatedOperands,
      operator: operator,
      result: result,
    );
  }

  /// Appends a given character to the current operation.
  TSimpleOperation append(String char) {
    // Create a copy of the current operands list
    final List<String> updatedOperands = List<String>.from(operands);

    // Get the index of the last element in the updated operands list
    final int lastIndex = updatedOperands.length - 1;

    // Prevent adding a new operator or operand if the current operand
    // has no digit
    if (lastOperand == '-' && isOperator(char)) {
      return this;
    }

    // If the last operand is not empty and the new character is an operator
    if (isOperator(char) && operands.length < 2) {
      if (lastOperand.isNotEmpty || hasOperator) {
        return _updateOperator(char);
      }
    } else if (isOperator(char) && operands.length == 2) {
      return this;
    }

    // If the new character is a '.', handle it
    if (char == '.') {
      return _updateDecimal(updatedOperands);
    }

    // Prevent multiple negative signs in an operand
    if (char == '-' && lastOperand.startsWith('-')) {
      return this;
    }

    // If the current operation has an operator and only one operand,
    // add the new character to the operands list
    if (hasOperator && lastIndex == 0) {
      updatedOperands.add(char);
    } else if (lastOperand.isEmpty) {
      // If the new character is an operator that is not '-',
      // return the current object
      if (isOperator(char) && char != '-') {
        return this;
      }

      // Otherwise, add the new character to the operands list
      updatedOperands.add(char);
    } else if (lastOperand.isNotEmpty) {
      // If the last operand is not empty, append the new character
      updatedOperands[lastIndex] = lastOperand + char;
    }

    // Return a copy of the current object with the updated operands
    return copyWith(operands: updatedOperands);
  }

  /// Evaluates the current operation and returns the result.
  TSimpleOperation evaluate() {
    final result = evaluateExpression(toString());

    return TSimpleOperation(
      result: (isDoubleInteger(result) ? result.toInt() : result).toString(),
      operands: operands,
      operator: operator,
    );
  }

  /// Clears the current operation.
  TSimpleOperation clear() {
    return const TSimpleOperation(
      operands: <String>[],
      operator: null,
      result: null,
    );
  }

  /// Deletes the last character of the current operation.
  TSimpleOperation deleteLastCharacter() {
    final List<String> updatedOperands = List<String>.from(operands);
    final int lastIndex = updatedOperands.length - 1;
    String? operator = this.operator;

    if (lastIndex < 0) {
      return clear();
    }

    if (updatedOperands.length == 1 && operator != null) {
      operator = null;
    } else if (lastOperand.isNotEmpty) {
      updatedOperands[lastIndex] = lastOperand.substring(
        0,
        lastOperand.length - 1,
      );
    }

    if (updatedOperands.isNotEmpty && updatedOperands.last.isEmpty) {
      updatedOperands.removeLast();
    }

    return TSimpleOperation(
      operands: updatedOperands,
      operator: operator,
      result: result,
    );
  }

  /// Creates a copy of the current operation with the specified operands,
  /// operator, and result.
  @override
  TSimpleOperation copyWith({
    List<String>? operands,
    String? operator,
    String? result,
  }) {
    return TSimpleOperation(
      operands: operands ?? this.operands,
      operator: operator ?? this.operator,
      result: result ?? this.result,
    );
  }

  /// Creates a clone of the current operation.
  @override
  TModel clone() {
    return TSimpleOperation(
      operands: List<String>.from(operands),
      operator: operator,
      result: result,
    );
  }

  /// Merges the current operation with another operation.
  @override
  TSimpleOperation merge(covariant TSimpleOperation model) {
    return TSimpleOperation(
      operands: model.operands,
      operator: model.operator,
      result: model.result,
    );
  }

  /// Returns a string representation of the current operation.
  @override
  String toString() {
    late final String operandsString;

    if (operands.length > 1) {
      operandsString = operands.join(operator ?? '');
    } else {
      operandsString = operands[0] + (operator ?? '');
    }

    return result != null ? '$operandsString=$result' : operandsString;
  }

  /// Returns a formatted string representation of the current operation.
  String format() {
    late final String operandsString;

    if (operands.length > 1) {
      operandsString = operands.map(_formatOperand).join(operator ?? '');
    } else {
      operandsString = _formatOperand(operands[0]) + (operator ?? '');
    }

    return result != null ? '$operandsString=$result' : operandsString;
  }

  /// Helper method to format an operand.
  String _formatOperand(String operand) {
    final value = double.tryParse(operand);

    if (value != null) {
      final formattedOperand = formatDecimal(value);

      if (operand.endsWith('.')) {
        return '$formattedOperand.';
      }

      return formattedOperand;
    }

    return operand;
  }

  /// Helper method to update the operator.
  TSimpleOperation _updateOperator(String char) {
    return copyWith(operator: char);
  }

  /// Helper method to update the decimal point in the current operation.
  TSimpleOperation _updateDecimal(List<String> operands) {
    // Get the index of the last element in the updated operands list
    final int lastIndex = operands.length - 1;

    // If the last operand already contains a '.', return the current object
    if (lastOperand.contains('.')) {
      return this;
    }

    // If the last operand is empty
    else if (lastOperand.isEmpty) {
      // If the operation has only two operands, add '0.' to
      // the updated operands list
      if (operands.length == 2) {
        operands[lastIndex] = '0.';
      }

      // Otherwise, add '0.' to the end of the current last operand
      else {
        operands.add('0.');
      }
    }

    // If the last operand is not empty, replace the last operand with
    // the last operand + '.'
    else {
      operands[lastIndex] = '$lastOperand.';
    }

    // Return a copy of the current object with the updated operands
    return copyWith(operands: operands);
  }

  @override
  List<Object?> get props => [operands, operator, result];
}
