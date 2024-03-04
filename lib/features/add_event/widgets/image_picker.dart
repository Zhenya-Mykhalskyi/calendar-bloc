import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  final String? currentImagePath;
  final void Function(String? imagePath) onImagePicked;
  const PickImage(
      {super.key, required this.onImagePicked, required this.currentImagePath});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  String? _pickedImagePath;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _pickedImagePath = pickedFile.path;
      widget.onImagePicked(_pickedImagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      margin: const EdgeInsets.only(top: 8, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: _pickedImagePath == null
          ? widget.currentImagePath == null
              ? InkWell(
                  onTap: _getImageFromGallery,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Icon(
                      Icons.add_a_photo,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      size: 60,
                    ),
                  ),
                )
              : InkWell(
                  onTap: _getImageFromGallery,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      _pickedImagePath!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
          : InkWell(
              onTap: _getImageFromGallery,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _pickedImagePath!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
