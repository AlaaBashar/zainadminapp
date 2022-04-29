import 'package:flutter/material.dart';

import '../widget/reusable_cached_network_image.dart';


class FullImagePage extends StatefulWidget {
  final String imageUrl ;
   FullImagePage({Key? key ,required this.imageUrl}) : super(key: key);

  @override
  _FullImagePageState createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReusableCachedNetworkImage(
        imageUrl: widget.imageUrl,
      ),
    );
  }
}
