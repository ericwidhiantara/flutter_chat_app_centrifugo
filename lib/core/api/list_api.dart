class ListAPI {
  ListAPI._();

  /// Auth
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String getUserLogin = "/auth/me";

  /// Room
  static const String rooms = "/rooms";
  static const String addParticipant = "/rooms/addParticipant";
  static const String removeParticipant = "/rooms/removeParticipant";

  /// Message
  static const String messages = "/messages";
  static const String getMessagesByRoomId = "/messages/room";

  /// User
  static const String users = "/users";
}
