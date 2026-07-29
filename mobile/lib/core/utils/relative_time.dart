/// ─────────────────────────────────────────────────────────────────────────────
/// RELATIVE TIME — compact "time ago" formatting for feeds & comments.
/// ─────────────────────────────────────────────────────────────────────────────

abstract class RelativeTime {
  static String format(DateTime? date, {DateTime? now}) {
    if (date == null) return '';
    final reference = now ?? DateTime.now();
    final diff = reference.difference(date);

    if (diff.isNegative) return 'just now';
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }
}
