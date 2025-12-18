import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final dynamic item;
  final void Function() onSave;
  final Color color;
  const NewsCard({super.key, required this.item, required this.onSave, this.color = const Color(0xFFEF4444)});

  String _dateFormat(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 1) {
      return 'Az önce';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} saat önce';
    } else {
      final weekdays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
      final months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
      final weekday = weekdays[dt.weekday - 1];
      final month = months[dt.month - 1];
      return '${dt.day} $month $weekday - ${difference.inDays} gün önce';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF232629),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (item.sourceProfilePictureUrl != null && item.sourceProfilePictureUrl.isNotEmpty)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(item.sourceProfilePictureUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEF4444),
                  ),
                  child: const Icon(
                    Icons.newspaper,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            (item.sourceTitle != null && item.sourceTitle.isNotEmpty
                                ? item.sourceTitle
                                : item.sourceName) ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isLatest == true) ...[
                          const SizedBox(width: 4),
                          const Text(
                            '- Son Dakika',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _dateFormat(item.publishedAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onSave,
                icon: Icon(
                  item.isSaved == true ? Icons.bookmark : Icons.bookmark_border,
                  color: color,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.title ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (item.imageUrl != null && item.imageUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: const Color(0xFF1F2937),
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
