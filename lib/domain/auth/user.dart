import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stratpoint_internship/domain/core/value_objects.dart';

part 'user.freezed.dart';

@freezed
class UserID with _$UserID {
  const factory UserID({
    required UniqueId id,
  }) = _UserID;
}
