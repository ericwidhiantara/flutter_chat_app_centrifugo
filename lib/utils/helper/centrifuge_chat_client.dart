import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
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

  late StreamController<MessageDataEntity> _chatMsgController;

  Stream<MessageDataEntity> get messages => _chatMsgController.stream;

  void init(String token, String chatUserName, String chatUserId) {
    const url = String.fromEnvironment("WEBSOCKET_URL");
    log.i("token $token");
    log.i("url $url");

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

      onConnect();
    });
    _connectingSub = _client.connecting.listen((event) {
      log.i("Connecting to server");
    });
    _disconnSub = _client.disconnected.listen((event) {
      log.w("Disconnected from server");
      log.w(event);
      log.w(event.reason);
    });
    _errorSub = _client.error.listen((event) {
      log.e(event.error);
    });
    await _client.connect();
  }

  Future<void> subscribe(String channel) async {
    log.i("Subscribing to channel $channel");
    _chatMsgController = StreamController<MessageDataEntity>.broadcast();

    final subscription =
        _client.getSubscription(channel) ?? _client.newSubscription(channel);
    subscription.publication
        .map<String>((e) => utf8.decode(e.data))
        .listen((data) {
      log.i("Received msg in subs: $data");
      final Map<String, dynamic> d = json.decode(data) as Map<String, dynamic>;
      log.i("Parsed JSON data: $d");

      final Map<String, dynamic> jsonData = d["data"] as Map<String, dynamic>;

      final MessageDataResponse res = MessageDataResponse.fromJson(jsonData);

      final MessageDataEntity message = res.toEntity();
      log.i("Message: ${message.text}");
      log.i("Sender: ${message.sender?.name}");
      log.i("SenderId: ${message.senderId}");
      log.i("CreatedAt: ${message.createdAt}");
      log.i("RoomId: ${message.roomId}");
      log.i("MessageId: ${message.messageId}");

      if (!_chatMsgController.isClosed) {
        _chatMsgController.sink.add(
          message,
        );
      } else {
        log.e("_chatMsgController is closed");
      }
    });
    subscription.join.listen(
      (event) {
        log.i("Client joined channel: $event");
      },
    );
    subscription.leave.listen(
      (event) {
        log.i("Client left channel: $event");
      },
    );
    subscription.subscribed.listen(
      (event) {
        log.i("Subscribed: $event");
      },
    );
    subscription.subscribing.listen(
      (event) => log.i("Subscribing: $event"),
    );
    subscription.error.listen(
      (event) => log.e("Error: $event"),
    );
    subscription.unsubscribed.listen(
      (event) {
        log.i("Unsubscribed: $event");
      },
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
    await subscription!.unsubscribe();

    await _client.disconnect();

    debugPrint("disposed");
  }
}

final ChatClient chatClient = ChatClient();
