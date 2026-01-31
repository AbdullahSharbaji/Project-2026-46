class RegisterRequest {
  final String fullName;
  final String email;
  final String password;

  RegisterRequest({required this.fullName, required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'FullName': fullName, // C# tarafındaki RegisterDto.FullName ile aynı
    'Email': email,       // C# tarafındaki RegisterDto.Email ile aynı
    'Password': password, // C# tarafındaki RegisterDto.Password ile aynı
  };
}