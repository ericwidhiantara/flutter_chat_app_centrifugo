part of 'chat_form_cubit.dart';

@freezed
class ChatFormState with _$ChatFormState {
  const factory ChatFormState.loading() = _Loading;

  const factory ChatFormState.success(MetaEntity data) = _Success;

  const factory ChatFormState.failure(Failure type, String message) = _Failure;

  const factory ChatFormState.empty() = _Empty;
}
