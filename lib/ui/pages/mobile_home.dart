import 'package:flutter/material.dart';

import 'map_view.dart';
import 'panel_view.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key, required this.isDialogOpen, required this.onAddEditGeoHashData, required this.height, required this.width});

  final bool isDialogOpen;
  final Function() onAddEditGeoHashData;
  final double height;
  final double width;

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: widget.height * 0.4,
              width: widget.width,
              child: MapView(
                isDialogOpen: widget.isDialogOpen,
              )),
          PanelView(
            onAddEditGeoHashData: widget.onAddEditGeoHashData
          )
        ],
      ),
    );
  }
}
