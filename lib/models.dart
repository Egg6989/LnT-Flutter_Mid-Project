class StepEntry {
  DateTime date;
  int numSteps;

  StepEntry(
    {required this.date, required this.numSteps}
  );

  String get label {
    if (numSteps < 4000) return 'Bad';
    if (numSteps <= 8000) return 'Average';
    return 'Good';
  }
}

class WaterEntry {
  DateTime date;
  double liters;

  WaterEntry(
    {required this.date, required this.liters}
  );

  String get label {
    if (liters < 1.5) return 'Bad';
    if (liters <= 2.0) return 'Average';
    return 'Good';
  }
}