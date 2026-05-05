import 'dart:math' as math;

enum Gender { male, female }

class CalorieResult {
  const CalorieResult({
    required this.bmr,
    required this.tdee,
    required this.lossTarget,
    required this.gainTarget,
  });

  final double bmr;
  final double tdee;
  final double lossTarget;
  final double gainTarget;
}

class BmiResult {
  const BmiResult({
    required this.value,
    required this.category,
    required this.description,
    required this.needlePercent,
    required this.idealMin,
    required this.idealMax,
    required this.genderTarget,
  });

  final double value;
  final String category;
  final String description;
  final double needlePercent;
  final double idealMin;
  final double idealMax;
  final double genderTarget;
}

double rawEquivalent({
  required double rawWeight,
  required double cookedWeight,
  required double servedWeight,
}) {
  if (rawWeight <= 0 || cookedWeight <= 0 || servedWeight <= 0) return 0;
  return rawWeight / cookedWeight * servedWeight;
}

CalorieResult calculateCalories({
  required int age,
  required double weightKg,
  required double heightCm,
  required Gender gender,
  required double activityMultiplier,
}) {
  final bmr = gender == Gender.male
      ? 10 * weightKg + 6.25 * heightCm - 5 * age + 5
      : 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
  final tdee = bmr * activityMultiplier;
  return CalorieResult(
    bmr: bmr,
    tdee: tdee,
    lossTarget: tdee - 500,
    gainTarget: tdee + 250,
  );
}

BmiResult calculateBmi({
  required double weightKg,
  required double heightCm,
  required Gender gender,
}) {
  final heightM = heightCm / 100;
  final heightInches = heightCm / 2.54;
  final inchesOverFiveFeet = math.max(0, heightInches - 60);
  final bmi = weightKg / (heightM * heightM);
  late String category;
  late String description;
  late double needle;

  if (bmi < 18.5) {
    category = 'Sovány';
    description = 'A BMI 18.5 alatt sovány tartomány.';
    needle = math.max(2, bmi / 18.5 * 25);
  } else if (bmi < 25) {
    category = 'Normál súly';
    description =
        'A normál BMI tartomány 18.5-24.9. Egészséges testsúlyon vagy.';
    needle = 25 + (bmi - 18.5) / 6.5 * 33;
  } else if (bmi < 30) {
    category = 'Túlsúlyos';
    description = 'A BMI 25-29.9 között túlsúly.';
    needle = 58 + (bmi - 25) / 5 * 20;
  } else {
    category = 'Obezitás';
    description = 'A BMI 30 felett obezitás tartomány.';
    needle = math.min(97, 78 + (bmi - 30) / 10 * 19);
  }

  return BmiResult(
    value: bmi,
    category: category,
    description: description,
    needlePercent: needle,
    idealMin: 18.5 * heightM * heightM,
    idealMax: 24.9 * heightM * heightM,
    genderTarget:
        (gender == Gender.male ? 50 : 45.5) + 2.3 * inchesOverFiveFeet,
  );
}

String grams(double value) => '${value.toStringAsFixed(1)} g';

String whole(num value) => value.round().toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (_) => ' ',
);
