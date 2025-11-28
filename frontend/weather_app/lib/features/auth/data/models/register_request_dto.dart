/// Register request DTO
class RegisterRequestDto {
  final String name;
  final String email;
  final String password;

  const RegisterRequestDto({
    required this.name,
    required this.email,
    required this.password,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
