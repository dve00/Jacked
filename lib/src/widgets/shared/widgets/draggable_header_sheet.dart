import 'package:flutter/material.dart';

class DraggableHeaderSheet extends StatefulWidget {
  final double sheetMinSnap;
  final double sheetMaxSnap;
  final DraggableScrollableController controller;
  final Widget headerBody;
  final Widget body;

  const DraggableHeaderSheet({
    super.key,
    required this.sheetMinSnap,
    required this.sheetMaxSnap,
    required this.controller,
    required this.headerBody,
    required this.body,
  });

  @override
  State<StatefulWidget> createState() => DraggableHeaderSheetState();
}

class DraggableHeaderSheetState extends State<DraggableHeaderSheet> {
  double _minChildSize = 0;

  Future<void> closeSheet() async {
    setState(() {
      _minChildSize = 0;
    });
    // allow the widget to rebuild before animating to 0
    await Future.delayed(const Duration(milliseconds: 5));
    widget.controller.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _minChildSize = widget.sheetMinSnap;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.animateTo(
        widget.sheetMaxSnap,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: DraggableScrollableSheet(
        controller: widget.controller,
        initialChildSize: _minChildSize,
        minChildSize: _minChildSize,
        maxChildSize: widget.sheetMaxSnap,
        snapAnimationDuration: const Duration(milliseconds: 200),
        snap: true,
        builder: (context, scrollController) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                // 28 is the default Material 3 radius for bottom sheets
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                child: Column(
                  children: [
                    DraggableHeader(
                      body: widget.headerBody,
                    ),
                    widget.body,
                  ],
                ),
              ),
            ),
          );
        },
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
