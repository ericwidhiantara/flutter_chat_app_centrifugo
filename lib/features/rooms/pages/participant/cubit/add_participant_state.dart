part of 'add_participant_cubit.dart';

@freezed
class AddParticipantState with _$AddParticipantState {
  const factory AddParticipantState.loading() = _Loading;

  const factory AddParticipantState.success(MetaEntity data) = _Success;

  const factory AddParticipantState.failure(Failure type, String message) =
      _Failure;

  const factory AddParticipantState.empty() = _Empty;
}
