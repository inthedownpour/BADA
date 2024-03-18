import 'dart:io';

import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChildeSetting extends StatefulWidget {
  final String name;

  const ChildeSetting({super.key, required this.name});

  @override
  State<ChildeSetting> createState() => _ChildeSettingState();
}

class _ChildeSettingState extends State<ChildeSetting> {
  late TextEditingController _controller;
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('이름 수정'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const SizedBox(height: 100),
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.grey.withOpacity(0.1),
              child: GestureDetector(
                onTap: _pickImage,
                child: (_image != null)
                    ? Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.add,
                        size: 100,
                        color: Colors.black54,
                      ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 170,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button300_115(label: Text('완료')),
                SizedBox(
                  width: 20,
                ),
                Button300_115(label: Text('삭제')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
