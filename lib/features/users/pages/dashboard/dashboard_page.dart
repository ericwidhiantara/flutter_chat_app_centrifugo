import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/dependencies_injection.dart';
import 'package:tdd_boilerplate/features/users/users.dart';
import 'package:tdd_boilerplate/utils/utils.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _lastPage = 1;
  final List<UserEntity> _users = [];
  final List<UserEntity> _savedUsers = [];

  bool isSaved(UserEntity article) {
    return _savedUsers.contains(article);
  }

  @override
  void initState() {
    super.initState();
    _savedUsers.addAll(UserBoxMixin().getAllData());

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          if (_currentPage < _lastPage) {
            _currentPage++;
            await context
                .read<UsersCubit>()
                .fetchUsers(UsersParams(page: _currentPage));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            context.goNamed(Routes.savedUsers.name);
          },
        ),
      ),
      child: RefreshIndicator(
        color: Theme.of(context).extension<CustomColor>()!.pink,
        backgroundColor: Theme.of(context).extension<CustomColor>()!.background,
        onRefresh: () {
          _currentPage = 1;
          _lastPage = 1;
          _users.clear();

          return context
              .read<UsersCubit>()
              .refreshUsers(UsersParams(page: _currentPage));
        },
        child: BlocBuilder<UsersCubit, UsersState>(
          builder: (_, state) {
            return state.when(
              loading: () => const Center(child: Loading()),
              success: (data) {
                _users.addAll(data.users ?? []);
                _lastPage = data.lastPage ?? 1;

                return BlocProvider(
                  create: (context) => sl<SavedUsersCubit>(),
                  child: BlocConsumer<SavedUsersCubit, SavedUsersState>(
                    listener: (_, state) {
                      state.whenOrNull(
                        loading: () => null,
                        success: (_, message) {
                          context.dismiss();
                          if (message.isNotEmpty) {
                            message.toToastSuccess(context);
                          }
                        },
                        failure: (message) {
                          context.dismiss();
                          if (message.isNotEmpty) {
                            message.toToastError(context);
                          }
                        },
                      );
                    },
                    builder: (ctx, s) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: _currentPage == _lastPage
                            ? _users.length
                            : _users.length + 1,
                        padding: EdgeInsets.symmetric(vertical: Dimens.space16),
                        itemBuilder: (_, index) {
                          return index < _users.length
                              ? Container(
                                  decoration: BoxDecorations(context).card,
                                  margin: EdgeInsets.symmetric(
                                    vertical: Dimens.space12,
                                    horizontal: Dimens.space16,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(Dimens.space8),
                                          bottomLeft:
                                              Radius.circular(Dimens.space8),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: _users[index].avatar ?? "",
                                          width: Dimens.profilePicture,
                                          height: Dimens.profilePicture,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SpacerH(value: Dimens.space16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _users[index].name ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLargeBold,
                                            ),
                                            Text(
                                              _users[index].email ?? "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .extension<
                                                            CustomColor>()!
                                                        .subtitle,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (isSaved(_users[index])) {
                                            _savedUsers.remove(
                                              _users[index],
                                            );

                                            ctx
                                                .read<SavedUsersCubit>()
                                                .deleteArticle(
                                                  _users[index],
                                                );
                                          } else {
                                            _savedUsers.add(_users[index]);
                                            ctx
                                                .read<SavedUsersCubit>()
                                                .saveArticle(_users[index]);
                                          }
                                        },
                                        icon: Icon(
                                          isSaved(_users[index])
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(Dimens.space16),
                                  child: const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                );
                        },
                      );
                    },
                  ),
                );
              },
              failure: (message) => Center(child: Empty(errorMessage: message)),
              empty: () => const Center(child: Empty()),
            );
          },
        ),
      ),
    );
  }
}
