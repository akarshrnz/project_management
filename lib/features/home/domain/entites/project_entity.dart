class ProjectEntity {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final List<String> videoUrls;
  final double latitude;
  final double longitude;

  ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.videoUrls,
    required this.latitude,
    required this.longitude,
  });
}
