import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tddboilerplate/core/core.dart';

class TextF extends StatefulWidget {
  const TextF({
    super.key,
    this.curFocusNode,
    this.nextFocusNode,
    this.hint,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.obscureText,
    this.suffixIcon,
    this.controller,
    this.onTap,
    this.textAlign,
    this.textAlignVertical,
    this.enable,
    this.readOnly = false,
    this.inputFormatter,
    this.minLine,
    this.maxLine,
    this.prefixIcon,
    this.isHintVisible = true,
    this.isSubtitleVisible = false,
    this.prefixText,
    this.hintText,
    this.subtitle,
    this.autofillHints,
    this.semantic,
    this.fontSize,
    this.hintColor,
    this.onFieldSubmitted,
    this.required = true,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final FocusNode? curFocusNode;
  final FocusNode? nextFocusNode;
  final String? hint;
  final Function(String)? validator;
  final Function(String)? onChanged;
  final Function? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obscureText;
  final int? minLine;
  final int? maxLine;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? enable;
  final bool? readOnly;
  final List<TextInputFormatter>? inputFormatter;
  final bool isHintVisible;
  final bool isSubtitleVisible;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? hintText;
  final String? subtitle;
  final Iterable<String>? autofillHints;
  final String? semantic;
  final double? fontSize;
  final Color? hintColor;
  final VoidCallback? onFieldSubmitted;
  final bool? required;
  final TextCapitalization? textCapitalization;

  @override
  _TextFState createState() => _TextFState();
}

class _TextFState extends State<TextF> {
  bool isFocus = false;
  String currentVal = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // margin: EdgeInsets.symmetric(vertical: Dimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.isHintVisible,
            child: Row(
              children: [
                Text(
                  widget.hint ?? "",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: widget.hintColor ??
                            Theme.of(context)
                                .extension<CustomColor>()!
                                .defaultText,
                        fontSize: widget.fontSize ?? Dimens.text14,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                if (widget.required == true)
                  Text(
                    " *",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: widget.fontSize ?? Dimens.text14,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
              ],
            ),
          ),
          Visibility(
            visible: widget.isSubtitleVisible,
            child: Text(
              widget.subtitle ?? "",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: widget.hintColor ??
                        Theme.of(context).extension<CustomColor>()!.defaultText,
                    fontSize: widget.fontSize ?? Dimens.text12,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: Dimens.size10),
            child: Semantics(
              label: widget.semantic,
              child: TextFormField(
                key: widget.key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: widget.autofillHints,
                enabled: widget.enable,
                readOnly: widget.readOnly ?? false,
                obscureText: widget.obscureText ?? false,
                focusNode: widget.curFocusNode,
                keyboardType: widget.keyboardType,
                controller: widget.controller,
                textInputAction: widget.textInputAction,
                textAlign: widget.textAlign ?? TextAlign.start,
                minLines: widget.minLine ?? 1,
                maxLines: widget.maxLine ?? 10,
                inputFormatters: widget.inputFormatter,
                textAlignVertical:
                    widget.textAlignVertical ?? TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyMedium,
                textCapitalization:
                    widget.textCapitalization ?? TextCapitalization.sentences,
                cursorColor: Palette.text,
                decoration: InputDecoration(
                  prefixText: widget.prefixText,
                  alignLabelWithHint: true,
                  isDense: true,
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.space12),
                    child: widget.prefixIcon,
                  ),
                  isCollapsed: true,
                  prefixIconConstraints: BoxConstraints(
                    minHeight: Dimens.space24,
                    maxHeight: Dimens.space24,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Dimens.space12,
                    horizontal: Dimens.space16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(Dimens.space4),
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).extension<CustomColor>()!.subtitle!,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(Dimens.space4),
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).extension<CustomColor>()!.subtitle!,
                    ),
                  ),
                  errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).extension<CustomColor>()!.red,
                      ),
                  focusedErrorBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(Dimens.space4),
                    borderSide: BorderSide(
                      color: Theme.of(context).extension<CustomColor>()!.red!,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(Dimens.space4),
                    borderSide: BorderSide(
                      color: Theme.of(context).extension<CustomColor>()!.red!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(Dimens.space4),
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).extension<CustomColor>()!.primary!,
                    ),
                  ),
                ),
                validator: widget.validator as String? Function(String?)?,
                onChanged: widget.onChanged,
                onTap: widget.onTap as void Function()?,
                onFieldSubmitted: (value) {
                  setState(() {
                    fieldFocusChange(
                      context,
                      widget.curFocusNode ?? FocusNode(),
                      widget.nextFocusNode,
                    );
                  });
                  widget.onFieldSubmitted?.call();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode? nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
