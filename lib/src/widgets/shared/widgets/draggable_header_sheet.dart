import 'package:flutter/material.dart';
import 'package:jacked/src/widgets/active_workout/active_workout.dart';

class DraggableHeaderSheet extends StatelessWidget {
  const DraggableHeaderSheet({
    super.key,
    required this.scrollController,
    required this.headerBody,
    required this.body,
  });

  final ScrollController scrollController;
  final Widget headerBody;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      child: Column(
        children: [
          const DraggableHeader(),
          body,
        ],
      ),
    );
  }
}
