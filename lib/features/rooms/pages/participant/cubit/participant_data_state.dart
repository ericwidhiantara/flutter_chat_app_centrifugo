part of 'participant_data_cubit.dart';

@freezed
class ParticipantDataState with _$ParticipantDataState {
  const factory ParticipantDataState.init() = _Init;

  const factory ParticipantDataState.addParticipant() = _AddParticipant;
}
