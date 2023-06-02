import 'dart:math';

class CalculationBrain{
  final double height;
  final int weight;
  CalculationBrain(this.height,this.weight);

  double _bmi=0.0;

  String CalculateBMI(){
     _bmi=weight/pow(height/100,2);
     return _bmi.toStringAsFixed(2);
  }

  String UnderMessage(){
    if(_bmi>25){
      return'Do more Exercise and Take care of your diet';
    }
    else if(_bmi>18.5){
      return 'Keep it up!';
    }
    else{
      return 'You should eat more!!';
    }
  }
  }
