class FollowSourceDto {
  final String sourceId;
  final bool isFollowed;

  const FollowSourceDto({
    required this.sourceId,
    required this.isFollowed,
  });

  Map<String, dynamic> toJson() => {
        'sourceId': sourceId,
        'isFollowed': isFollowed,
      };
}
