import 'package:equatable/equatable.dart';

enum UserRole { guest, customer, admin }

enum VerificationStatus { unverified, pending, verified }

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.verificationStatus,
    this.phoneNumber,
  });

  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final String? phoneNumber;

  bool get isVerified => verificationStatus == VerificationStatus.verified;

  UserProfile copyWith({
    String? email,
    String? displayName,
    UserRole? role,
    VerificationStatus? verificationStatus,
    String? phoneNumber,
  }) {
    return UserProfile(
      id: id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [id, email, displayName, role, verificationStatus, phoneNumber];
}
