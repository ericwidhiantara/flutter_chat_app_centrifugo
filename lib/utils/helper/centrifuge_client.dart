import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/helper.dart';

class ChatClient {
  late Client _client;

  StreamSubscription<ConnectedEvent>? _connectedSub;
  StreamSubscription<ConnectingEvent>? _connectingSub;
  StreamSubscription<DisconnectedEvent>? _disconnSub;
  StreamSubscription<ErrorEvent>? _errorSub;

  late StreamSubscription<MessageEvent> _msgSub;

  late Subscription? subscription;
  final _chatMsgController = StreamController<MessageDataEntity>();

  Stream<MessageDataEntity> get messages => _chatMsgController.stream;

  void init(String token, String chatUserName, String chatUserId) {
    const url = String.fromEnvironment("WEBSOCKET_URL");
    _client = createClient(
      url,
      ClientConfig(
        token: token,
        headers: <String, dynamic>{
          'user-id': chatUserId,
          'user-name': chatUserName,
        },
      ),
    );
    _msgSub = _client.message.listen((event) {
      log.i("Msg: $event");
    });
  }

  Future<void> connect(VoidCallback onConnect) async {
    log.i(
      "Connecting to Centrifugo server at ${const String.fromEnvironment("WEBSOCKET_URL")}",
    );
    _connectedSub = _client.connected.listen((event) {
      log.i("Connected to server");
      Fluttertoast.showToast(
        msg: "Centrifugo server connected",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      onConnect();
    });
    _connectingSub = _client.connecting.listen((event) {
      log.i("Connecting to server");
      Fluttertoast.showToast(
        msg: "Connecting to Centrifugo server",
        backgroundColor: Colors.green[900],
        textColor: Colors.white,
      );
    });
    _disconnSub = _client.disconnected.listen((event) {
      log.w("Disconnected from server");
      log.w(event);
      log.w(event.reason);

      Fluttertoast.showToast(
        msg: "Centrifugo server disconnected",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    });
    _errorSub = _client.error.listen((event) {
      log.e(event.error);
    });
    await _client.connect();
  }

  Future<void> subscribe(String channel) async {
    log.i("Subscribing to channel $channel");
    final subscription =
        _client.getSubscription(channel) ?? _client.newSubscription(channel);
    subscription.publication
        .map<String>((e) => utf8.decode(e.data))
        .listen((data) {
      log.i("Received msg di subs: $data");
      final Map<String, dynamic> d = json.decode(data) as Map<String, dynamic>;
      log.i("Parsed JSON data: $d");

      // Explicitly cast d["data"] to Map<String, dynamic>
      final Map<String, dynamic> jsonData = d["data"] as Map<String, dynamic>;

      final MessageDataResponse res = MessageDataResponse.fromJson(jsonData);

      final MessageDataEntity message = res.toEntity();
      log.i("Ini message: ${message.text}");
      log.i("Ini message: ${message.sender?.name}");
      log.i("Ini message: ${message.senderId}");
      log.i("Ini message: ${message.createdAt}");
      log.i("Ini message: ${message.roomId}");
      log.i("Ini message: ${message.id}");
      log.i("Ini message: ${message.messageId}");

      _chatMsgController.sink.add(
        message,
      );
    });
    subscription.join.listen(
      (event) => log.i("Join: $event"),
    );
    subscription.leave.listen(
      (event) => log.i("Leave: $event"),
    );
    subscription.subscribed.listen(
      (event) => log.i("Subscribed: $event"),
    );
    subscription.subscribing.listen(
      (event) => log.i("Subscribing: $event"),
    );
    subscription.error.listen(
      (event) => log.e("Error: $event"),
    );
    subscription.unsubscribed.listen(
      (event) => log.i("Unsubscribed: $event"),
    );
    this.subscription = subscription;
    await subscription.subscribe();
  }

  Future<void> dispose() async {
    debugPrint("disposed");
    await _connectingSub?.cancel();
    await _connectedSub?.cancel();
    await _disconnSub?.cancel();
    await _errorSub?.cancel();
    await _msgSub.cancel();
    await _chatMsgController.close();
    debugPrint("disposed");
  }

  Future<void> sendMsg(MessageDataEntity msg) async {
    final output = jsonEncode(
      {'message': msg.text, 'name': msg.sender?.name, 'user_id': msg.senderId},
    );
    log.i("Sending msg : $output");
    final data = utf8.encode(output);
    try {
      await subscription?.publish(data);
    } on Exception {
      rethrow;
    }
  }
}

final ChatClient cli = ChatClient();
