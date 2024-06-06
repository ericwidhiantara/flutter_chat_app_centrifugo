import 'dart:async';
import 'dart:convert';

import 'package:centrifuge/centrifuge.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/helper.dart';

class OnlineClient {
  late Client _client;

  StreamSubscription<ConnectedEvent>? _connectedSub;
  StreamSubscription<ConnectingEvent>? _connectingSub;
  StreamSubscription<DisconnectedEvent>? _disconnSub;
  StreamSubscription<ErrorEvent>? _errorSub;

  late StreamSubscription<MessageEvent> _msgSub;

  late Subscription? subscription;
  late Subscription? onlineUserSubscription;

  final StreamController<OnlineUser> _onlineUserController =
      StreamController<OnlineUser>.broadcast();

  Stream<OnlineUser> get onlineUsers => _onlineUserController.stream;

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
      Fluttertoast.showToast(
        msg: "Centrifugo server connected",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
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

  Future<void> checkOnlineUser(String channel) async {
    log.i("Subscribing to online user channel $channel");
    final onlineUserSubscription =
        _client.getSubscription(channel) ?? _client.newSubscription(channel);

    onlineUserSubscription.join.listen(
      (event) {
        log.i("User joined channel $channel: $event");
        _onlineUserController.sink.add(
          OnlineUser(
            userId: event.user,
            isOnline: true,
          ),
        );
        Fluttertoast.showToast(
          msg: "User joined channel: $event",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      },
    );
    onlineUserSubscription.leave.listen(
      (event) {
        log.i("User left channel $channel: $event");
        _onlineUserController.sink.add(
          OnlineUser(
            userId: event.user,
            isOnline: false,
          ),
        );
        Fluttertoast.showToast(
          msg: "User left channel: $event",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      },
    );
    onlineUserSubscription.subscribed.listen(
      (event) {
        log.i("Subscribed to online user channel: $event");
        Fluttertoast.showToast(
          msg: "Subscribed to online user channel: $event",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      },
    );
    onlineUserSubscription.subscribing.listen(
      (event) => log.i("Subscribing to online user channel: $event"),
    );
    onlineUserSubscription.error.listen(
      (event) => log.e("Error in online user channel: $event"),
    );
    onlineUserSubscription.unsubscribed.listen(
      (event) {
        log.i("Unsubscribed from online user channel: $event");
        Fluttertoast.showToast(
          msg: "Unsubscribed from online user channel: $event",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      },
    );
    this.onlineUserSubscription = onlineUserSubscription;
    await onlineUserSubscription.subscribe();
  }

  Future<void> dispose() async {
    debugPrint("disposed");
    await _connectingSub?.cancel();
    await _connectedSub?.cancel();
    await _disconnSub?.cancel();
    await _errorSub?.cancel();
    await _msgSub.cancel();
    await subscription!.unsubscribe();

    await _client.disconnect();
    debugPrint("disposed");
  }

  Future<void> disposeRoomChat() async {
    debugPrint("disposed");
    await _msgSub.cancel();
    await subscription!.unsubscribe();
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

final OnlineClient onlineClient = OnlineClient();
