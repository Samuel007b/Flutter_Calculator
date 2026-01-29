import 'package:flutter/material.dart';
import 'package:flutter_calculator/pages/historic_page.dart';
import 'package:flutter_calculator/widgets/button_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_calculator/enums/operation_type.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  late String displayNumber;
  late List<String> historic;

  @override
  void initState() {
    displayNumber="0";
    historic = [];
    super.initState();
  }

  void setOperationType(OperationTypeEnum newType){
    setState(() {
      displayNumber += newType.symbol;
    });
  }

  void clear(){
    setState(() {
      displayNumber = "0";
    });
  }

  void clearHistoric(){
    setState(() {
      clear();
      historic = [];
    });
  }

  void delete(){
    setState(() {
      if (displayNumber.length > 1) {
        displayNumber = displayNumber.substring(0, displayNumber.length - 1);
      } else {
        displayNumber = "0";
      }
    });
  }

  void percentage() {
    setState(() {
      int lastOperatorIndex = displayNumber.lastIndexOf(RegExp(r'[+\-×÷]'));
      String prefix = "";
      String lastNumberStr = "";
      if (lastOperatorIndex == -1) {
        lastNumberStr = displayNumber;
      } else {
        prefix = displayNumber.substring(0, lastOperatorIndex + 1);
        lastNumberStr = displayNumber.substring(lastOperatorIndex + 1);
      }
      if (lastNumberStr.isNotEmpty) {
        double value = double.parse(lastNumberStr.replaceAll(',', '.'));
        double result = value / 100;
        displayNumber = prefix + result.toString().replaceAll('.', ',');
      }
    });
  }

  void appenNumber(String stringNumber){
    setState(() {
      if (displayNumber == "0"){
        displayNumber = stringNumber;
      }
      else{
        displayNumber += stringNumber;
      }
    });
  }

  List<double> parseNumbers(String expression){
    RegExp regExp = RegExp(r'[0-9]+\.?[0-9]*');
    var matches = regExp.allMatches(expression);
    List<double> numbers = [];

    for(var match in matches){
      String numberText = match.group(0)!;
      numbers.add(double.parse(numberText));
    }
    return numbers;
  }

  List<OperationTypeEnum> getOperators(String expression){
    return expression.characters.where((x) => OperationTypeEnum.values.any((op) => op.symbol == x)).map((x)=> OperationTypeEnum.values.firstWhere((op) => op.symbol == x)).toList();
  }

  void resolvePriorityOperation(List<double> numbers, List<OperationTypeEnum> operators){
    int index = 0;
    while(index < operators.length){
      if(operators[index] == OperationTypeEnum.multiplication){
        numbers[index] = numbers[index] * numbers[index+1];
        numbers.removeAt(index+1);
        operators.removeAt(index);
      }
      else if(operators[index] == OperationTypeEnum.division){
        numbers[index] = numbers[index] / numbers[index+1];
        numbers.removeAt(index+1);
        operators.removeAt(index);
      }
      else{
        index++;
      }
    }
  }

  double resolveAdditionAndSubtraction(List<double> numbers, List<OperationTypeEnum> operators){
    int index = 0;
    while(index < operators.length){
      if(operators[index] == OperationTypeEnum.addition){
        numbers[0] = numbers[0] + numbers[index+1];
      }
      else{
        numbers[0] = numbers[0] - numbers[index+1];
      }
      index++;
    }
    return numbers[0];
  }

  void calculate(){
    String expression = displayNumber.replaceAll(",", ".");
    List<double> numbers = parseNumbers(expression);
    List<OperationTypeEnum> operations = getOperators(expression);
    resolvePriorityOperation(numbers, operations);
    final result = resolveAdditionAndSubtraction(numbers, operations);
    setState(() {
      displayNumber = result.toString().replaceAll('.', ',');
      historic.add("$expression = $result");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora", style: GoogleFonts.urbanist(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        shadowColor: Colors.black,
        elevation: 2,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => HistoricPage(historic: historic)));
          }, icon: Icon(Icons.history, color: Colors.black))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.maxFinite,
              color: Colors.black12,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  child: Text(displayNumber, style: GoogleFonts.urbanist(fontSize: 48, fontWeight: FontWeight.bold))
                ),
              ),
            ),
            SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ButtonWidget(text: "CE", color: Colors.yellow, onPressed: (){
                      clearHistoric();
                    }, textColor: Colors.black),
                    ButtonWidget(text: "C", color: Colors.red, onPressed: (){
                      clear();
                    }, textColor: Colors.black),
                    ButtonWidget(text: "\u232B", color: Colors.orange, onPressed: (){
                      delete();
                    }, textColor: Colors.black),
                    ButtonWidget(text: "÷", color: Colors.blue, onPressed: (){
                      setOperationType(OperationTypeEnum.division);
                    }, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: "7", color: Colors.grey[300], onPressed: (){
                      appenNumber("7");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "8", color: Colors.grey[300], onPressed: (){
                      appenNumber("8");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "9", color: Colors.grey[300], onPressed: (){
                      appenNumber("9");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "×", color: Colors.blue, onPressed: (){
                      setOperationType(OperationTypeEnum.multiplication);
                    }, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: "4", color: Colors.grey[300], onPressed: (){
                      appenNumber("4");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "5", color: Colors.grey[300], onPressed: (){
                      appenNumber("5");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "6", color: Colors.grey[300], onPressed: (){
                      appenNumber("6");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "-", color: Colors.blue, onPressed: (){
                      setOperationType(OperationTypeEnum.subtraction);
                    }, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: "1", color: Colors.grey[300], onPressed: (){
                      appenNumber("1");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "2", color: Colors.grey[300], onPressed: (){
                      appenNumber("2");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "3", color: Colors.grey[300], onPressed: (){
                      appenNumber("3");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "+", color: Colors.blue, onPressed: (){
                      setOperationType(OperationTypeEnum.addition);
                    }, textColor: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    ButtonWidget(text: "%", color: Colors.grey[300], onPressed: (){
                      percentage();
                    }, textColor: Colors.black),
                    ButtonWidget(text: "0", color: Colors.grey[300], onPressed: (){
                      appenNumber("0");
                    }, textColor: Colors.black),
                    ButtonWidget(text: ",", color: Colors.grey[300], onPressed: (){
                      appenNumber(",");
                    }, textColor: Colors.black),
                    ButtonWidget(text: "=", color: Colors.green, onPressed: (){
                      calculate();
                    }, textColor: Colors.white),
                  ],
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}