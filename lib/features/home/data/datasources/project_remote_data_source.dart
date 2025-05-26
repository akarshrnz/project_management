import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> fetchProjects();
  Future<void> addProject(ProjectModel project);
  Future<void> uploadImage(String projectId, File file);
  Future<void> uploadVideo(String projectId, File file);
  Future<void> deleteImage(String projectId, String imageUrl);
  Future<void> deleteVideo(String projectId, String videoUrl);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProjectRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  @override
  Future<List<ProjectModel>> fetchProjects() async {
    final query = await firestore.collection('projects').get();
    return query.docs
        .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addProject(ProjectModel project) async {
    await firestore.collection('projects').doc(project.id).set(project.toMap());
  }

  @override
  Future<void> uploadImage(String projectId, File file) async {
    final ref = storage.ref('projects/$projectId/images/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await firestore.collection('projects').doc(projectId).update({
      'imageUrls': FieldValue.arrayUnion([url])
    });
  }

  @override
  Future<void> uploadVideo(String projectId, File file) async {
    final ref = storage.ref('projects/$projectId/videos/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await firestore.collection('projects').doc(projectId).update({
      'videoUrls': FieldValue.arrayUnion([url])
    });
  }

  @override
  Future<void> deleteImage(String projectId, String imageUrl) async {
    await firestore.collection('projects').doc(projectId).update({
      'imageUrls': FieldValue.arrayRemove([imageUrl])
    });

    final ref = storage.refFromURL(imageUrl);
    await ref.delete();
  }

  @override
  Future<void> deleteVideo(String projectId, String videoUrl) async {
    await firestore.collection('projects').doc(projectId).update({
      'videoUrls': FieldValue.arrayRemove([videoUrl])
    });

    final ref = storage.refFromURL(videoUrl);
    await ref.delete();
  }
}
