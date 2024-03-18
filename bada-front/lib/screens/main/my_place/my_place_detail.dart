import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class PlaceDetail extends StatefulWidget {
  final String placeName;

  const PlaceDetail({super.key, required this.placeName});

  @override
  State<PlaceDetail> createState() => _PlaceDetailState();
}

class _PlaceDetailState extends State<PlaceDetail> {
  Uint8List? _image;
  File? selectedImage;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.placeName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showIconPicker(context);
                  },
                  child: _image != null
                      ? const CircleAvatar(
                          radius: 50,
                        )
                      : const CircleAvatar(
                          radius: 50,
                          child: Text('이미지 들어감'),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5)),
                      ),
                      child: Row(
                        children: [
                          const Text('이름: '),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        Text('주소: '),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: ('주소'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('수정'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('삭제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showIconPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.5,
          child: Column(
            children: [
              const Text('아이콘을 선택해주세요'),
              ElevatedButton(
                onPressed: () {
                  _pickImageFromGallery();
                },
                child: const Icon(Icons.abc),
              ),
            ],
          ),
        );
      },
    );
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedImage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });
  }
}
