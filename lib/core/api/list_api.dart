class ListAPI {
  ListAPI._();

  static const String register = "/account/register";
  static const String login = "/account/login";

  static const String users = "/users";
  static const String userById = "/users/:user_id";

  static const String createRoom = "/rooms/create";
  static const String rooms = "/rooms";
  static const String roomById = "/rooms/:room_id";

  static const String sendMessage = "/messages/rooms";
  static const String messageById = "/messages/:message_id";
  static const String messagesByUser = "/messages";
  static const String messagesByRoom = "/messages/rooms";
}
