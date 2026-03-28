
class RegistrationTeacherItem {
  final String name;

  RegistrationTeacherItem({
    required this.name
  });

  factory RegistrationTeacherItem.fromJson(final Map<String, dynamic> json) {
    final instructor = json['instructor'];
    final String firstName = instructor?['givenName'] ?? '';
    final String lastName = instructor?['familyName'] ?? '';
    return RegistrationTeacherItem(
      name: '$firstName $lastName',
    );
  }
}