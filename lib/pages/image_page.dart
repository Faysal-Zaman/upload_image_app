import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:upload_image_app/pages/display_image_page.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future uploadFile() async {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      print("Download Link: " + urlDownload);

      const snackBar = SnackBar(
        content: Text('Uploaded Successfully...'),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        pickedFile = null;
      });

      await FirebaseFirestore.instance
          .collection("images")
          .add({"imageUrl": urlDownload.toString()})
          .then((value) => print("added Successfully"))
          .onError((error, stackTrace) => print("Error"));
    }

    return Scaffold(
      appBar: AppBar(
        leading: FittedBox(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text('Logout'),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Upload Image",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 30),
              pickedFile == null
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://www.shareicon.net/data/128x128/2016/07/26/802001_man_512x512.png"),
                        ),
                      ),
                      margin: const EdgeInsets.all(5),
                    )
                  : Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(pickedFile!.path!)),
                        ),
                      ),
                      margin: const EdgeInsets.all(5),
                    ),
              TextButton.icon(
                onPressed: selectFile,
                icon: const Icon(Icons.upload),
                label: const Text("Get Image"),
              ),
              TextButton.icon(
                onPressed: () async {
                  uploadFile();
                },
                icon: const Icon(Icons.upload),
                label: const Text("Upload Image"),
              ),
              const SizedBox(height: 40),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const DisplayImagePage();
                    },
                  ));
                },
                icon: const Icon(Icons.route),
                label: const Text("View Images"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
