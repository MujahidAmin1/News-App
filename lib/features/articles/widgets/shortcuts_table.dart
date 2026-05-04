import 'package:flutter/material.dart';

class ShortcutsTable extends StatelessWidget {
  const ShortcutsTable({super.key});

  static const _rows = [
    ('Ctrl+1', 'Go to Feeds'),
    ('Ctrl+F / Ctrl+2', 'Go to Search'),
    ('Ctrl+3', 'Go to Saved'),
    ('Ctrl+R', 'Refresh news feed'),
    ('Ctrl+B', 'Bookmark current article'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2535),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF253041)),
                ),
                child: Text(
                  row.$1,
                  style: const TextStyle(
                    color: Color(0xFFFF6170),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                row.$2,
                style: const TextStyle(
                  color: Color(0xFFCDD4DF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
