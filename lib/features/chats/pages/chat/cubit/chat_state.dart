part of 'chat_cubit.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState.loading() = _Loading;

  const factory ChatState.success(MessagesEntity data) = _Success;

  const factory ChatState.failure(Failure type, String message) = _Failure;

  const factory ChatState.empty() = _Empty;
}
