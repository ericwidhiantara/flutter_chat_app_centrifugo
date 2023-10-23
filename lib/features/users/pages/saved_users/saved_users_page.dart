import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

class SavedUsersPage extends StatefulWidget {
  const SavedUsersPage({super.key});

  @override
  State<SavedUsersPage> createState() => _SavedUsersPageState();
}

class _SavedUsersPageState extends State<SavedUsersPage> {
  final ScrollController _scrollController = ScrollController();
  final List<UserEntity> _users = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      appBar: _appBar(),
      child: RefreshIndicator(
        color: Theme.of(context).extension<CustomColor>()!.pink,
        backgroundColor: Theme.of(context).extension<CustomColor>()!.background,
        onRefresh: () {
          _users.clear();

          return context.read<SavedUsersCubit>().refreshUsers();
        },
        child: BlocBuilder<SavedUsersCubit, SavedUsersState>(
          builder: (_, state) {
            return state.when(
              loading: () => const Center(child: Loading()),
              success: (data, message) {
                _users.clear();
                if (data != null) {
                  _users.addAll(data);
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: _users.length,
                  padding: EdgeInsets.symmetric(vertical: Dimens.space16),
                  itemBuilder: (_, index) {
                    return index < _users.length
                        ? BlocConsumer<SavedUsersCubit, SavedUsersState>(
                            listener: (_, state) {
                              state.whenOrNull(
                                loading: () => null,
                                success: (data, message) {
                                  context.dismiss();
                                  if (message != "") {
                                    message.toToastSuccess(context);
                                  }
                                },
                                failure: (message) {
                                  context.dismiss();
                                  message.toToastError(context);
                                },
                              );
                            },
                            builder: (context, state) {
                              return Container(
                                decoration: BoxDecorations(context).card,
                                margin: EdgeInsets.symmetric(
                                  vertical: Dimens.space12,
                                  horizontal: Dimens.space16,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(Dimens.space8),
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
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            _users[index].email ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .extension<CustomColor>()!
                                                      .subtitle,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      key: Key("deleteButton_$index"),
                                      onPressed: () {
                                        context
                                            .read<SavedUsersCubit>()
                                            .deleteUser(_users[index]);
                                        _users.removeAt(index);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
              failure: (message) => Center(child: Empty(errorMessage: message)),
              empty: () => const Center(child: Empty()),
            );
          },
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocConsumer<SavedUsersCubit, SavedUsersState>(
        listener: (_, state) {
          state.whenOrNull(
            loading: () => null,
            success: (data, message) {
              context.dismiss();
              if (message != "") {
                message.toToastSuccess(context);
              }
            },
            failure: (message) {
              context.dismiss();
              message.toToastError(context);
            },
          );
        },
        builder: (context, state) {
          return AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: [
              IconButton(
                key: const Key("refreshButton"),
                onPressed: () {
                  _users.clear();
                  context.read<SavedUsersCubit>().refreshUsers();
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                key: const Key("clearButton"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(
                        Strings.of(context)!.delete,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      content: Text(
                        Strings.of(context)!.deleteDesc,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => context.pop(),
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
                          key: const Key("yesClearButton"),
                          onPressed: () {
                            context.pop();
                            _users.clear();

                            context.read<SavedUsersCubit>().clearUser();
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
                icon: const Icon(Icons.clear),
              ),
            ],
          );
        },
      ),
    );
  }
}
