import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/centrifuge_client.dart' as conf;
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

  late StreamSubscription<MessageDataEntity> _sub;

  // final ChatClient conf = ChatClient();
  final TextEditingController _messageController = TextEditingController();

  UserLoginEntity? _user;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _roomId = widget.room.roomId!;
      _user = sl<MainBoxMixin>().getData(MainBoxKeys.tokenData);
    });

    conf.cli.subscribe("room:$_roomId");
    _sub = conf.cli.messages.listen((MessageDataEntity msg) {
      log.i("Received message: $msg");
      // _messages.add(msg);

      setState(() => _messages.insert(0, msg));
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
    conf.cli.dispose();
    super.dispose();
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
            decoration: InputDecoration(
              hintText: 'Type a message',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  if (_messageController.text.isNotEmpty) {
                    await context.read<ChatFormCubit>().sendMessage(
                          PostSendMessageParams(
                            text: _messageController.text,
                            roomId: _roomId,
                          ),
                        );
                    _scrollController.animateTo(
                      0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                    // _messages.add(
                    //   MessageDataEntity(
                    //     text: _messageController.text,
                    //     senderId: _user?.userId,
                    //     createdAt: DateTime.now().millisecondsSinceEpoch,
                    //   ),
                    // );
                    _messageController.clear();
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: body(context),
    );
  }

  RefreshIndicator body(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).extension<CustomColor>()!.background,
      onRefresh: () {
        _currentPage = 1;
        _lastPage = 1;
        _messages.clear();

        return context.read<ChatCubit>().refreshChat(
              GetMessagesParams(
                page: _currentPage,
                roomId: _roomId,
              ),
            );
      },
      child: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              _messages.addAll(data.data ?? []);
              _lastPage = data.pagination?.totalPage ?? 1;
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
                          message: data.text ?? "",
                          isSender: data.senderId == _user?.userId,
                          senderName: data.senderId == _user?.userId
                              ? null
                              : data.sender?.name ?? "",
                          time: DateFormat("hh:mm").format(
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
      ),
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(Dimens.size50),
      child: AppBar(
        title: Text(
          widget.room.name ?? "-",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final String? senderName;
  final String time;

  const ChatBubble({
    required this.message,
    required this.isSender,
    this.senderName,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSender ? Colors.blue : Colors.grey[300];
    final textColor = isSender ? Colors.white : Colors.black;
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

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (senderName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                senderName!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
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
                          message,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      const SizedBox(height: 5),
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
