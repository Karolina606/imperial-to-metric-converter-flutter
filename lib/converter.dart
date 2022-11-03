
import 'dart:ffi';

class Converter{

  static var impToMetric = {
    "inch": 0.0254,
    "foot": 0.3048,
    "yard": 0.9144,
    "pole": 5.0292,
    "chain": 20.1168,
    "furlong": 201.168,
    "mile": 1609.344,
    "league": 4828.032
  };

  static var metrToMetric = {
    "mm": 1000,
    "cm": 100,
    "dm": 10,
    "m": 1,
    "km": 0.001
  };

  static double convertFromImperialToMetric(double number, String imperialUnit, String metricUnit) {
    return (number * impToMetric[imperialUnit]! * metrToMetric[metricUnit]!* 100).round() / 100;
  }

  static double convertFromMetricToImperial(double number, String imperialUnit, String metricUnit){
    return ((number / metrToMetric[metricUnit]!) / impToMetric[imperialUnit]! * 100).round() / 100;
  }

}