import 'package:t_helpers/helpers.dart';
import 'package:tmodel/tmodel.dart';

class TSimpleOperation extends TModel {
  final List<String> operands;
  final String? operator;
  final String? result;

  const TSimpleOperation({
    this.operands = const <String>[],
    this.operator,
    this.result,
  });

  bool get isValid {
    return operands.isNotEmpty &&
        operands.every((operand) => operand.isNotEmpty) &&
        (operator == null || operator!.isNotEmpty);
  }

  bool get hasOperator {
    return operator != null && operator!.isNotEmpty;
  }

  int get length {
    return operands.fold<int>(0, (sum, operand) => sum + operand.length) +
        (operator?.length ?? 0);
  }

  bool get isEmpty {
    return operands.isEmpty && operator == null && result == null;
  }

  String get lastOperand {
    return operands.isNotEmpty ? operands.last : '';
  }

  TSimpleOperation append(String char) {
    final List<String> updatedOperands = List<String>.from(operands);
    final int lastIndex = updatedOperands.length - 1;

    if (lastOperand.isNotEmpty && !hasOperator && isOperator(char)) {
      return copyWith(operator: char);
    }

    if (char == '.') {
      final operand = hasOperator && operands.length == 1 ? '' : lastOperand;

      if (operand.contains('.')) {
        return this;
      } else if (operand.isEmpty) {
        if (operands.length == 2) {
          updatedOperands[lastIndex] = '0.';
        } else {
          updatedOperands.add('0.');
        }
      } else {
        updatedOperands[lastIndex] = '$operand.';
      }

      return copyWith(operands: updatedOperands);
    }

    if (hasOperator && lastIndex == 0) {
      updatedOperands.add(char);
    } else if (lastOperand.isEmpty) {
      if (isOperator(char) && char != '-') {
        return this;
      }

      updatedOperands.add(char);
    } else if (lastOperand.isNotEmpty) {
      updatedOperands[lastIndex] = lastOperand + char;
    }

    return copyWith(operands: updatedOperands);
  }

  TSimpleOperation evaluate() {
    final result = evaluateExpression(toString());

    return TSimpleOperation(
      result: (isDoubleInteger(result) ? result.toInt() : result).toString(),
      operands: operands,
      operator: operator,
    );
  }

  TSimpleOperation clear() {
    return const TSimpleOperation(
      operands: <String>[],
      operator: null,
      result: null,
    );
  }

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
      updatedOperands[lastIndex] =
          lastOperand.substring(0, lastOperand.length - 1);
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

  @override
  TModel clone() {
    return TSimpleOperation(
      operands: List<String>.from(operands),
      operator: operator,
      result: result,
    );
  }

  @override
  TSimpleOperation merge(covariant TSimpleOperation model) {
    return TSimpleOperation(
      operands: model.operands,
      operator: model.operator,
      result: model.result,
    );
  }

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

  @override
  List<Object?> get props => [operands, operator, result];
}
