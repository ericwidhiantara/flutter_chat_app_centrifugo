import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/centrifuge_client.dart' as conf;
import 'package:tddboilerplate/utils/utils.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastPage = 1;

  final List<RoomDataEntity> _items = [];

  UserLoginEntity? userLogin;

  @override
  void initState() {
    super.initState();
    userLogin = sl<MainBoxMixin>().getData(MainBoxKeys.tokenData);

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (_currentPage < _lastPage) {
            _currentPage++;
            await context.read<RoomCubit>().fetchRoomList(
                  GetRoomsParams(
                    page: _currentPage,
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      appBar: _appBar(context),
      backgroundColor: Theme.of(context).extension<CustomColor>()!.card,
      floatingButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          final res = await context.pushNamed(Routes.newRoom.name);

          if (res != null && res == true) {
            _currentPage = 1;
            _lastPage = 1;
            _items.clear();

            if (!context.mounted) return;
            await context.read<RoomCubit>().fetchRoomList(
                  GetRoomsParams(
                    page: _currentPage,
                  ),
                );
          }
        },
        child: const Icon(Icons.add),
      ),
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).extension<CustomColor>()!.background,
        onRefresh: () {
          _currentPage = 1;
          _lastPage = 1;
          _items.clear();

          return context.read<RoomCubit>().refreshRoom(
                GetRoomsParams(
                  page: _currentPage,
                ),
              );
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<RoomCubit, RoomState>(
              listener: (context, state) {
                state.whenOrNull(
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
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.size20),
            child: BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                return state.when(
                  loading: () => const Center(child: Loading()),
                  success: (data) {
                    _items.addAll(data.data ?? []);
                    _lastPage = data.pagination?.totalPage ?? 1;

                    return ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: _currentPage == _lastPage
                          ? _items.length
                          : _items.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _items.length) {
                          final data = _items[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: Dimens.size10,
                            ),
                            child: Card(
                              color: Theme.of(context).cardColor,
                              child: ListTile(
                                onTap: () {
                                  final token = sl<MainBoxMixin>()
                                      .getData(MainBoxKeys.token) as String;

                                  final UserLoginEntity user =
                                      sl<MainBoxMixin>()
                                              .getData(MainBoxKeys.tokenData)
                                          as UserLoginEntity;

                                  conf.cli
                                    ..init(
                                      token,
                                      user.name ?? "",
                                      user.userId ?? "",
                                    )
                                    ..connect(() async {
                                      await Future<void>.delayed(
                                        const Duration(milliseconds: 10),
                                      );
                                      if (context.mounted) {
                                        context.pushNamed(
                                          Routes.chat.name,
                                          extra: data,
                                        );
                                      }
                                    });
                                },
                                tileColor: Theme.of(context).cardColor,
                                contentPadding: const EdgeInsets.all(8),
                                title: Text(
                                  data.name ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: Dimens.text16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                subtitle: Text(
                                  "Anggota: ${data.participants?.length ?? 0} orang",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                                leading: SizedBox(
                                  width: Dimens.size66,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.size10,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://via.placeholder.com/65x65',
                                    ),
                                  ),
                                ),
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
                  empty: () => const Empty(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(Dimens.size100 + Dimens.size50),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: Dimens.size20,
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage: const CachedNetworkImageProvider(
                      'https://via.placeholder.com/65x65',
                    ),
                  ),
                  SpacerH(
                    value: Dimens.size20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userLogin?.name ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .titleLargeBold
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        userLogin?.email ?? "",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .extension<CustomColor>()!
                                  .shadow,
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            Strings.of(context)!.logout,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          content: Text(
                            Strings.of(context)!.logoutDesc,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => context.back(),
                              child: Text(
                                Strings.of(context)!.cancel,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .extension<CustomColor>()!
                                          .subtitle,
                                    ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthCubit>().logout();
                              },
                              child: Text(
                                Strings.of(context)!.yes,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .extension<CustomColor>()!
                                          .red,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
              SpacerV(
                value: Dimens.size20,
              ),
              Text(
                "Chattooo",
                style: Theme.of(context).textTheme.titleLargeBold?.copyWith(
                      color: Theme.of(context)
                          .extension<CustomColor>()!
                          .defaultText,
                      fontSize: Dimens.text36,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
