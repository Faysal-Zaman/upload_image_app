import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  ImagePage({super.key});

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

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download Link: " + urlDownload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () {
                  uploadFile();
                  const snackBar = SnackBar(
                    content: Text('Uploaded Successfully...'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    pickedFile = null;
                  });
                },
                icon: const Icon(Icons.upload),
                label: const Text("Upload Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
