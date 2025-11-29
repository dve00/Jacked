import 'package:flutter/material.dart';

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
          DraggableHeader(
            body: headerBody,
          ),
          body,
        ],
      ),
    );
  }
}

class DraggableHeader extends StatelessWidget {
  const DraggableHeader({
    super.key,
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: BorderDirectional(bottom: BorderSide())),
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                body,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
