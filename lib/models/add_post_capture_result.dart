enum AddPostMediaType {
  photo,
  video,
}

class AddPostCaptureResult {
  final String path;
  final AddPostMediaType type;
  final bool fromGallery;

  AddPostCaptureResult({
    required this.path,
    required this.type,
    required this.fromGallery,
  });

  bool get isPhoto {
    return type == AddPostMediaType.photo;
  }

  bool get isVideo {
    return type == AddPostMediaType.video;
  }
}