import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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

  Timer? _debounce;

  int month = DateTime.now().month;
  String monthString = DateFormat("MMMM", "id").format(DateTime.now());
  int year = DateTime.now().year;

  List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  List<int> years =
      List.generate(DateTime.now().year % 100 + 1, (index) => 2000 + index);

  @override
  void initState() {
    super.initState();

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
    _debounce?.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
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
            padding: EdgeInsets.all(Dimens.size20),
            child: BlocBuilder<RoomCubit, RoomState>(
              builder: (context, state) {
                return state.when(
                  loading: () => const Center(child: Loading()),
                  success: (data) {
                    _items.clear();
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
                                        context.goNamed(
                                          Routes.chat.name,
                                          extra: data.roomId,
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
                                  "Participant: ${data.participants?.length ?? 0}",
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
}
