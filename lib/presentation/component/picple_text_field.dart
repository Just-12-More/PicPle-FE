import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:picple/presentation/theme/picple_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextStyle hintStyle;
  final bool enabled;
  final EdgeInsetsGeometry contentPadding;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color textColor;
  final double borderRadius;
  final double borderWidth;
  final String? suffixIconAsset;
  final VoidCallback? onSuffixIconPressed;

  const AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.hintStyle,
    this.enabled = true,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderColor = PicpleColors.gray2,
    this.focusedBorderColor = PicpleColors.gray5,
    this.enabledBorderColor = PicpleColors.gray2,
    this.textColor = PicpleColors.gray5,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.suffixIconAsset,
    this.onSuffixIconPressed,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});  // Rebuild to update the suffix icon
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          borderSide: BorderSide(
            color: widget.focusedBorderColor,
            width: widget.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius)),
          borderSide: BorderSide(
            color: widget.enabledBorderColor,
            width: widget.borderWidth,
          ),
        ),
        suffixIcon: (_controller.text.isNotEmpty && widget.suffixIconAsset != null)
            ? IconButton(
          onPressed: widget.onSuffixIconPressed,
          icon: SvgPicture.asset(
            widget.suffixIconAsset!,
            width: 20,
            height: 20,
          ),
        )
            : null,
      ),
      style: TextStyle(color: widget.textColor),
    );
  }
}