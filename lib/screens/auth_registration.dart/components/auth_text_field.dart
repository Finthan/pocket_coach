import 'package:flutter/material.dart';

import '../../../constants.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required TextEditingController loginTextController,
    required bool isFocused,
    required this.onFocusChanged,
    required this.label,
  })  : _loginTextController = loginTextController,
        _isFocused = isFocused;

  final TextEditingController _loginTextController;
  final bool _isFocused;
  final String label;
  final ValueChanged<bool> onFocusChanged;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: double.infinity,
      ),
      decoration: BoxDecoration(
        // color: kWhiteColor,
        border: Border.all(
          color: widget._isFocused ? kPrimaryColor : kTextColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 4,
          right: 4,
          bottom: 6,
          top: 6,
        ),
        child: Center(
          child: TextField(
            controller: widget._loginTextController,
            textAlignVertical: widget._isFocused
                ? TextAlignVertical.center
                : TextAlignVertical.top,
            decoration: InputDecoration(
              labelText: widget._isFocused ? widget.label : null,
              hintText: widget._isFocused ? null : widget.label,
              contentPadding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
              border: InputBorder.none,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: kWhiteColor,
                  width: 1.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: kWhiteColor,
                  width: 1.0,
                ),
              ),
              labelStyle: const TextStyle(
                color: kGray1Color,
                fontSize: 12,
              ),
              hintStyle: TextStyle(
                color: widget._isFocused ? kBlack22Color : kFont1Color,
                fontSize: 12,
              ),
              alignLabelWithHint: false,
            ),
            onChanged: (value) {},
            onTap: () {
              widget.onFocusChanged(true);
              setState(() {});
            },
            onSubmitted: (value) {
              widget.onFocusChanged(false);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
