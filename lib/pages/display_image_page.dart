import 'package:cloud_firestore/cloud_firestore.dart';
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
      appBar: AppBar(
        title: const Text("All Images"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('images').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // snapshot.data!.docs[index]["imageUrl"]
          if (!snapshot.hasData) {
            return const Center(child: Text("No data yet"));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: MasonryGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Image.network(snapshot.data!.docs[index]["imageUrl"]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
