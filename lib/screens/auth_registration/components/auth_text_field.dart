import 'package:flutter/material.dart';

import '../../../constants.dart';

class AuthTextField extends StatefulWidget {
  AuthTextField({
    super.key,
    required TextEditingController loginTextController,
    required bool isFocused,
    required this.onFocusChanged,
    required this.label,
  })  : _loginTextController = loginTextController,
        _isFocused = isFocused;

  final TextEditingController _loginTextController;
  bool _isFocused;
  final String label;
  final ValueChanged<bool> onFocusChanged;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.label} ${widget._isFocused}");
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: kWhiteColor,
        width: 1.0,
      ),
    );
    return Container(
      height: 60,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: double.infinity,
      ),
      decoration: BoxDecoration(
        color: kWhiteColor,
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
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
          child: TextField(
            controller: widget._loginTextController,
            textAlignVertical: widget._isFocused
                ? TextAlignVertical.center
                : TextAlignVertical.top,
            decoration: InputDecoration(
              labelText: widget.label,
              contentPadding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
              border: border,
              focusedBorder: border,
              enabledBorder: border,
              labelStyle: TextStyle(
                color: widget._isFocused ? kBlack22Color : kFont1Color,
                fontSize: 12,
              ),
              alignLabelWithHint: false,
            ),
            obscureText: widget.label == 'Введите пароль' ? true : false,
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
