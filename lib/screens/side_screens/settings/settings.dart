import 'package:flutter/material.dart';

import 'components/body.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
    required this.onGlobalVariableChanged,
  });

  final VoidCallback onGlobalVariableChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        onGlobalVariableChanged: () {},
      ),
    );
  }
}
