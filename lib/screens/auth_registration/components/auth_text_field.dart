import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    Key? key,
    required TextEditingController loginTextController,
    required bool isFocused,
    required this.onFocusChanged,
    required this.label,
  })  : _loginTextController = loginTextController,
        _isFocused = isFocused,
        super(key: key);

  final TextEditingController _loginTextController;
  final bool _isFocused;
  final String label;
  final ValueChanged<bool> onFocusChanged;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop').then((_) {
      widget.onFocusChanged(false);
      setState(() {});
    });
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message == AppLifecycleState.resumed.toString()) {
        widget.onFocusChanged(false);
        setState(() {});
      }

      // Добавьте эту строку для явного указания, что метод не возвращает значения.
      return Future.value(null);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChannels.lifecycle.setMessageHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              border: border,
              focusedBorder: border,
              enabledBorder: border,
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
