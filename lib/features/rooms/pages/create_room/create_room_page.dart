import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  /// Controller
  final _conNama = TextEditingController();

  /// Focus Node
  final _fnNama = FocusNode();

  /// Global key
  final _keyForm = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  void resetForm() {
    setState(() {
      _conNama.clear();
    });
    _scrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      appBar: _appBar(context),
      child: BlocListener<CreateRoomCubit, CreateRoomState>(
        listener: (_, state) {
          state.whenOrNull(
            loading: () => context.show(),
            success: (data) {
              context.dismiss();
              data.message.toString().toToastSuccess(context);
              resetForm();

              context.back(true);
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
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _keyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextF(
                    key: const Key("nama"),
                    curFocusNode: _fnNama,
                    textInputAction: TextInputAction.done,
                    controller: _conNama,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    hintText: "Tulis nama room atau obrolan baru disini...",
                    hint: "Nama Room / Obrolan Baru",
                    minLine: 3,
                    validator: (String? value) => value != null
                        ? (value.isEmpty
                            ? Strings.of(context)!.errorEmptyField
                            : null)
                        : null,
                  ),
                  SpacerV(value: Dimens.size30),
                  Button(
                    title: "Kirim",
                    color: Theme.of(context).extension<CustomColor>()?.primary,
                    onPressed: () {
                      if (_keyForm.currentState?.validate() ?? false) {
                        context.read<CreateRoomCubit>().createRoom(
                              PostCreateRoomParams(
                                name: _conNama.text,
                              ),
                            );
                      }
                    },
                  ),
                ],
              ),
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
          "Buat Room Baru",
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
