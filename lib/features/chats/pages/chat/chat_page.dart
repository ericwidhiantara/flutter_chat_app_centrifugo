import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

class ChatPage extends StatefulWidget {
  final RoomDataEntity room;

  const ChatPage({super.key, required this.room});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastPage = 1;

  final List<MessageDataEntity> _messages = [];

  String _roomId = "";
  String _roomName = "";
  bool _isOnline = false;
  bool _isTyping = false;

  String _typingText = "";

  late StreamSubscription<MessageCentrifugeModel> _sub;
  late StreamSubscription<Map<String, dynamic>> _subTyping;
  late StreamSubscription<OnlineUser> _subOnlineUser;

  // final ChatClient conf = ChatClient();
  final TextEditingController _messageController = TextEditingController();

  UserLoginEntity? _user;

  final _formKey = GlobalKey<FormState>();

// Define a variable to keep track of the timer
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    setState(() {
      _roomId = widget.room.roomId!;
      _user = sl<MainBoxMixin>().getData(MainBoxKeys.tokenData);
      _roomName = widget.room.roomType == "personal"
          ? widget.room.participants
                  ?.firstWhere(
                    (element) => element.userId != _user?.userId,
                  )
                  .name ??
              "Unknown"
          : widget.room.name ?? "Unknown";
    });
    checkOnline();
    chatClient.subscribe("room:$_roomId");
    subscribeTyping();
    checkInRoom();

    _sub = chatClient.messages.listen((MessageCentrifugeModel item) {
      log.i("Received message in chat page: $item");
      if (_messages.isNotEmpty) {
        if (item.event == "update_message") {
          setState(() {
            // update message status based on index
            _messages[_messages.indexWhere(
                    (element) => element.messageId == item.data.messageId)] =
                item.data;
          });
        } else {
          setState(() => _messages.insert(0, item.data));
        }
      }
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (_currentPage < _lastPage) {
            _currentPage++;
            await context.read<ChatCubit>().fetchMessages(
                  GetMessagesParams(
                    page: _currentPage,
                    roomId: _roomId,
                  ),
                );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _sub.cancel();
    _subOnlineUser.cancel();
    _subTyping.cancel();
    disposeRoomChat();
    super.dispose();
  }

  Future<void> disposeRoomChat() async {
    await chatClient.dispose();
    await chatTypingClient.dispose();
  }

  Future<void> checkOnline() async {
    log.i("Online user subscription started");

    //check online user from presence data first
    final res = await onlineClient.onlineUserSubscription!.presence();
    log.i("Online user presence: ${res.clients.keys}");

    final isPersonalRoom = widget.room.roomType == "personal";
    final participants = widget.room.participants;

    if (isPersonalRoom && participants != null) {
      final recipient =
          participants.firstWhere((element) => element.userId != _user?.userId);

      // looping to get the ClientInfo inside the response
      res.clients.forEach((key, value) {
        log.i("Hehhe: $key, value: $value");
        if (value.user == recipient.userId) {
          setState(() {
            _isOnline = true;
          });
        }
      });
    }

    _subOnlineUser = onlineClient.onlineUsers.listen((OnlineUser value) {
      final isPersonalRoom = widget.room.roomType == "personal";
      final participants = widget.room.participants;

      if (isPersonalRoom && participants != null) {
        final recipient = participants
            .firstWhere((element) => element.userId != _user?.userId);

        if (value.userId == recipient.userId) {
          setState(() {
            _isOnline = value.isOnline;
          });
        }
      }
      log.i("ini user yang online: $value, isOnline: $_isOnline");
    });
  }

  Future<void> checkInRoom() async {
    log.i("check user in room started");

    //check online user from presence data first
    final res = await chatClient.subscription!.presence();
    log.i("User in room: ${res.clients.keys}");

    final isPersonalRoom = widget.room.roomType == "personal";
    final participants = widget.room.participants;

    if (isPersonalRoom && participants != null) {
      final recipient =
          participants.firstWhere((element) => element.userId != _user?.userId);

      // looping to get the ClientInfo inside the response
      res.clients.forEach((key, value) {
        log.i("Hehhe: $key, value: $value");
        if (value.user == recipient.userId) {
          setState(() {});
        }
      });
    }

    _subOnlineUser = onlineClient.onlineUsers.listen((OnlineUser value) {
      final isPersonalRoom = widget.room.roomType == "personal";
      final participants = widget.room.participants;

      if (isPersonalRoom && participants != null) {
        final recipient = participants
            .firstWhere((element) => element.userId != _user?.userId);

        if (value.userId == recipient.userId) {
          setState(() {
            _isOnline = value.isOnline;
          });
        }
      }
      log.i("ini user yang online: $value, isOnline: $_isOnline");
    });
  }

  Future<void> sendMessage(BuildContext context) async {
    if (_messageController.text.isNotEmpty) {
      sendTypingStatus(false);
      setState(() {
        _isTyping = false;
      });

      await context.read<ChatFormCubit>().sendMessage(
            PostSendMessageParams(
              text: _messageController.text,
              roomId: _roomId,
            ),
          );

      if (_messages.isEmpty && context.mounted) {
        await context.read<ChatCubit>().fetchMessages(
              GetMessagesParams(roomId: _roomId),
            );
      }

      _messageController.clear();
    }
  }

  Future<void> subscribeTyping() async {
    final token = sl<MainBoxMixin>().getData(MainBoxKeys.token) as String;

    final UserLoginEntity user =
        sl<MainBoxMixin>().getData(MainBoxKeys.tokenData) as UserLoginEntity;
    chatTypingClient
      ..init(
        token,
        user.name ?? "",
        user.userId ?? "",
      )
      ..connect(() {
        chatTypingClient.subscribe("room:$_roomId:typing");
        _subTyping =
            chatTypingClient.typingData.listen((Map<String, dynamic> value) {
          if (value["user_id"] != _user?.userId) {
            setState(() {
              _typingText = "${value["name"]} is typing...";
              _isTyping = value["is_typing"] as bool;
            });
            if (value["is_typing"] as bool) {
              Fluttertoast.showToast(msg: "${value["name"]} is typing...");
            }
          }
        });
      });
  }

  // Function to send the typing status
  void sendTypingStatus(bool isTyping) {
    final Map<String, dynamic> data = {
      "user_id": _user?.userId,
      "is_typing": isTyping,
      "name": _user?.name,
    };
    chatTypingClient.typing(data);
  }

// Function to handle user input
  void onUserInput(String value) {
    if (value.isNotEmpty) {
      // Send typing status only if the user was not typing before
      if (!_isTyping) {
        sendTypingStatus(true);
        _isTyping = true;
      }

      // Cancel the previous timer if it's still running
      _typingTimer?.cancel();

      // Start a new timer to send "not typing" status after a timeout
      _typingTimer = Timer(const Duration(milliseconds: 500), () {
        sendTypingStatus(false);
        _isTyping = false;
      });
    } else {
      // Send "not typing" status if the input is empty and the user was typing
      if (_isTyping) {
        sendTypingStatus(false);
        _isTyping = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appBar(context),
      bottomNavigationBar: Form(
        key: _formKey,
        child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.all(Dimens.size16),
          child: TextField(
            controller: _messageController,
            onSubmitted: (_) => sendMessage(context),
            onChanged: (value) {
              onUserInput(value);
            },
            decoration: InputDecoration(
              hintText: 'Type a message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => sendMessage(context),
              ),
            ),
          ),
        ),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            _messages.addAll(data.data ?? []);

            _lastPage = data.pagination?.totalPages ?? 1;
          },
          failure: (type, message) {
            if (type is UnauthorizedFailure) {
              Strings.of(context)!.expiredToken.toToastError(context);

              context.goNamed(Routes.login.name);
            } else {
              message.toToastError(context);
            }
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.size20),
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return state.when(
              loading: () => const Center(child: Loading()),
              success: (data) {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: _currentPage == _lastPage
                      ? _messages.length
                      : _messages.length + 1,
                  reverse: true,
                  itemBuilder: (context, index) {
                    if (index < _messages.length) {
                      final data = _messages[index];
                      return ChatBubble(
                        message: data,
                        isSender: data.senderId == _user?.userId,
                        roomType: widget.room.roomType!,
                        senderName: data.senderId == _user?.userId
                            ? null
                            : data.sender?.name ?? "",
                        time: DateFormat("HH:mm").format(
                          DateTime.fromMillisecondsSinceEpoch(
                            data.createdAt! * 1000,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.all(Dimens.space16),
                      child: const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    );
                  },
                );
              },
              failure: (_, message) => Empty(errorMessage: message),
              empty: () => const SizedBox(),
            );
          },
        ),
      ),
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(Dimens.size50),
      child: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _roomName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            if (_isTyping)
              Text(
                _typingText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: Dimens.text12,
                    ),
              )
            else
              Row(
                children: [
                  if (widget.room.roomType == "personal")
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _isOnline ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (widget.room.roomType == "personal")
                    SpacerH(value: Dimens.space8),
                  Text(
                    widget.room.roomType == "personal"
                        ? _isOnline
                            ? "Online"
                            : "Offline"
                        : "${widget.room.participants!.length} anggota",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: Dimens.text12,
                        ),
                  ),
                ],
              ),
          ],
        ),
        elevation: 0,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final MessageDataEntity message;
  final bool isSender;
  final String? senderName;
  final String time;
  final String roomType;

  const ChatBubble({
    required this.message,
    required this.isSender,
    this.senderName,
    required this.time,
    required this.roomType,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender ? const Color(0xffE7FED8) : Colors.grey[300];
    const textColor = Colors.black;
    final align = isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isSender
        ? const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );

    String messageStatusIcon = "";
    switch (message.messageStatus) {
      case "sent":
        messageStatusIcon = SvgImages.icMessageSent;
      case "delivered":
        messageStatusIcon = SvgImages.icMessageDelivered;
      case "read":
        messageStatusIcon = SvgImages.icMessageRead;
      default:
        messageStatusIcon = SvgImages.icMessageSent;
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (senderName != null && roomType == "group")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                senderName!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: Dimens.text12,
                    ),
              ),
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth * 0.65;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: radius,
                ),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: align,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                        ),
                        child: Text(
                          message.text ?? "",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                      SpacerV(value: Dimens.size10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          Text(
                            time,
                            style: TextStyle(
                              color: textColor.withOpacity(0.6),
                              fontSize: 10,
                            ),
                          ),
                          if (isSender) SpacerH(value: Dimens.size10),
                          if (isSender)
                            SvgPicture.asset(
                              messageStatusIcon,
                              width: 12,
                              height: 12,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
