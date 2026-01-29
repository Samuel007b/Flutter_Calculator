enum OperationTypeEnum {
  addition(symbol: "+"),
  subtraction(symbol: "-"),
  multiplication(symbol: "×"),
  division(symbol: "÷");
  final String symbol;
  const OperationTypeEnum({required this.symbol});
}
