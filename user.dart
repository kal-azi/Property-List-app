enum UserRole { guest, loggedIn }

class AppUser {
  final String? id;
  final String? email;
  final String? name;
  final UserRole role;

  const AppUser({
    this.id,
    this.email,
    this.name,
    required this.role,
  });

  bool get isGuest => role == UserRole.guest;
  bool get isLoggedIn => role == UserRole.loggedIn;

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}
