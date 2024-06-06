import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

class ParticipantPage extends StatefulWidget {
  final RoomDataEntity room;

  const ParticipantPage({super.key, required this.room});

  @override
  State<ParticipantPage> createState() => _ParticipantPageState();
}

class _ParticipantPageState extends State<ParticipantPage>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastPage = 1;

  final List<UserLoginEntity> _items = [];

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
            await context.read<ParticipantCubit>().fetchParticipantList(
                  GetUsersParams(
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
      bottomNavigation: _bottomNavigation(context),
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).extension<CustomColor>()!.background,
        onRefresh: () {
          _currentPage = 1;
          _lastPage = 1;
          _items.clear();

          return context.read<ParticipantCubit>().refreshParticipant(
                GetUsersParams(
                  page: _currentPage,
                ),
              );
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<ParticipantCubit, ParticipantState>(
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
            BlocListener<AddParticipantCubit, AddParticipantState>(
              listener: (context, state) {
                state.whenOrNull(
                  loading: () => context.show(),
                  success: (data) {
                    context.dismiss();
                    context.read<ParticipantDataCubit>().selectedItems.clear();
                    data.message?.toToastSuccess(context);
                    final token =
                        sl<MainBoxMixin>().getData(MainBoxKeys.token) as String;

                    final UserLoginEntity user = sl<MainBoxMixin>()
                        .getData(MainBoxKeys.tokenData) as UserLoginEntity;

                    chatClient
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
                            extra: widget.room,
                          );
                        }
                      });
                  },
                  failure: (type, message) {
                    if (type is UnauthorizedFailure) {
                      Strings.of(context)!.expiredToken.toToastError(context);

                      context.goNamed(Routes.login.name);
                    } else {
                      context.dismiss();
                      message.toToastError(context);
                    }
                  },
                );
              },
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.size20),
            child: BlocBuilder<ParticipantCubit, ParticipantState>(
              builder: (context, state) {
                return state.when(
                  loading: () => const Center(child: Loading()),
                  success: (data) {
                    _items.addAll(data.data ?? []);
                    _lastPage = data.pagination?.totalPages ?? 1;

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
                              child: BlocBuilder<ParticipantDataCubit,
                                  ParticipantDataState>(
                                builder: (context, state) {
                                  return ListTile(
                                    onTap: () {
                                      context
                                          .read<ParticipantDataCubit>()
                                          .selectParticipant(context, data);
                                    },
                                    tileColor: context
                                            .read<ParticipantDataCubit>()
                                            .selectedItems
                                            .contains(data)
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).cardColor,
                                    trailing: context
                                            .read<ParticipantDataCubit>()
                                            .selectedItems
                                            .contains(data)
                                        ? const Icon(Icons.check)
                                        : null,
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
                                      "${data.email ?? ""} - ${data.phone ?? ""}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
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
                                  );
                                },
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
      preferredSize: Size.fromHeight(Dimens.size40),
      child: AppBar(
        title: Text(
          "Tambah Anggota Ke Room",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }

  Widget _bottomNavigation(BuildContext context) {
    return BlocBuilder<ParticipantDataCubit, ParticipantDataState>(
      builder: (context, state) {
        if (context.read<ParticipantDataCubit>().selectedItems.isEmpty) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: Dimens.size50,
            child: TextButton(
              onPressed: () async {
                context.read<AddParticipantCubit>().addParticipant(
                      PostAddParticipantParams(
                        roomId: widget.room.roomId!,
                        userId: context
                            .read<ParticipantDataCubit>()
                            .selectedItems
                            .first
                            .userId!,
                      ),
                    );
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor:
                    Theme.of(context).extension<CustomColor>()!.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.size10),
                ),
              ),
              child: Text(
                "Tambahkan",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: Dimens.text14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .extension<CustomColor>()!
                          .background,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
