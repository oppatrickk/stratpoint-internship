import 'package:firebase_auth/firebase_auth.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';
import 'package:stratpoint_internship/domain/auth/user.dart';

extension FirebaseUserDomainX on User {
  UserID toDomain() {
    return UserID(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
