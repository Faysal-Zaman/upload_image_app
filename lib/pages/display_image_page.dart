import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DisplayImagePage extends StatefulWidget {
  const DisplayImagePage({super.key});

  @override
  State<DisplayImagePage> createState() => _DisplayImagePageState();
}

class _DisplayImagePageState extends State<DisplayImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasonryGridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }
}
