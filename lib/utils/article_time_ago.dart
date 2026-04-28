String formatTimeAgo(DateTime dateTime) {
  if (dateTime.millisecondsSinceEpoch == 0) {
    return 'Unknown time';
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  }
  if (difference.inDays < 1) {
    return '${difference.inHours}h ago';
  }
  if (difference.inDays < 7) {
    return '${difference.inDays}d ago';
  }

  final weeks = (difference.inDays / 7).floor();
  return '${weeks}w ago';
}
