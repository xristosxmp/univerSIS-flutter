class GraduationRule {
  final String message;
  final String result;
  final String requiredValue;
  final bool success;

  GraduationRule({
    required this.message,
    required this.result,
    required this.requiredValue,
    required this.success,
  });

  factory GraduationRule.fromJson(final Map<String, dynamic> json) {
    return GraduationRule(
      message: json["validationResult"]?["message"] ?? "",
      result: json["validationResult"]?["data"]?["result"].toString() ?? "",
      requiredValue: json["validationResult"]?["data"]?["value1"] ?? "",
      success: json["validationResult"]?["success"] ?? false
    );
  }
}