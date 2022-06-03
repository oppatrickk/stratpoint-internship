import 'package:firebase_auth/firebase_auth.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';
import 'package:stratpoint_internship/domain/auth/user.dart';

extension FirebaseUserDomainX on FirebaseUser {
  // TODO: Migrate to latest Firebase
  User toDomain() {
    return User(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
