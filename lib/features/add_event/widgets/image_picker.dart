import 'dart:io';
import 'package:keym_calendar/theme/app_colors.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  final String? currentImagePath;
  final void Function(File? image) onImagePicked;
  const PickImage(
      {super.key, required this.onImagePicked, required this.currentImagePath});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File? _pickedImage;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await path_provider.getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _pickedImage = savedImage;
      });
      widget.onImagePicked(_pickedImage);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.whiteColor,
        ),
      ),
      child: _pickedImage == null
          ? widget.currentImagePath == null
              ? AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    onTap: _getImageFromGallery,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Icon(
                        Icons.add_a_photo,
                        color: AppColors.whiteColor.withOpacity(0.6),
                        size: 60,
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: _getImageFromGallery,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(widget.currentImagePath!),
                      fit: BoxFit.contain,
                    ),
                  ),
                )
          : InkWell(
              onTap: _getImageFromGallery,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  _pickedImage!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
    );
  }
}
