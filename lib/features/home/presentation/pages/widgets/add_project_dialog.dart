import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_management/features/home/domain/entites/project_entity.dart';
import 'package:project_management/features/home/presentation/bloc/home_bloc.dart';
import 'primary_button.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({super.key});

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<File> imageFiles = [];
  final List<File> videoFiles = [];

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFiles.add(File(picked.path)));
    }
  }

  Future<void> _pickVideo() async {
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => videoFiles.add(File(picked.path)));
    }
  }

  Future<List<String>> _uploadFiles(List<File> files, String path) async {
    final urls = <String>[];
    for (final file in files) {
      final ref = FirebaseStorage.instance
          .ref('$path/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final imageUrls = await _uploadFiles(imageFiles, 'projects/$id/images');
      final videoUrls = await _uploadFiles(videoFiles, 'projects/$id/videos');

      final project = ProjectEntity(
        id: id,
        title: titleController.text,
        description: descController.text,
        imageUrls: imageUrls,
        videoUrls: videoUrls,
        latitude: 12.9716,
        longitude: 77.5946,
      );

      if (context.mounted) {
        context.read<HomeBloc>().add(AddProjectEvent(project));
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Project"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo),
                    label: const Text("Add Image"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickVideo,
                    icon: const Icon(Icons.videocam),
                    label: const Text("Add Video"),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (imageFiles.isNotEmpty)
                Text("${imageFiles.length} image(s) selected"),
              if (videoFiles.isNotEmpty)
                Text("${videoFiles.length} video(s) selected"),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancel"),
        ),
        PrimaryButton(
          label: "Create",
          onPressed: _submit,
        ),
      ],
    );
  }
}
