part of 'participant_cubit.dart';

@freezed
class ParticipantState with _$ParticipantState {
  const factory ParticipantState.loading() = _Loading;

  const factory ParticipantState.success(UsersEntity data) = _Success;

  const factory ParticipantState.failure(Failure type, String message) =
      _Failure;

  const factory ParticipantState.empty() = _Empty;
}
