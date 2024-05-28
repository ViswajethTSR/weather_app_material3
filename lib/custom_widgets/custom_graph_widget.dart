import 'package:flutter/material.dart';

class CustomGraphWidget extends StatelessWidget {
  Widget child;
  EdgeInsetsGeometry padding;
  CustomGraphWidget({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.padding,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      width: 350,
      child: this.child,
    );
  }
}
