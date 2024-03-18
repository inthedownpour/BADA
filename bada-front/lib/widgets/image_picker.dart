import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class OpenGallery extends StatelessWidget {
  const OpenGallery({super.key});

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(returnImage.path).readAsBytesSync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
