import 'package:flutter/material.dart';

class CustomAppBar {
  const CustomAppBar();

  PreferredSize call() => PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(elevation: 0),
      );
}
