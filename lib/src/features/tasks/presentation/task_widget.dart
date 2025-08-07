import 'package:flutter/cupertino.dart';

/// A single task card styled with Cupertino components.
class TaskTile extends StatelessWidget {
  final String title;
  final bool completed;
  final String avatarUrl;

  const TaskTile({
    super.key,
    required this.title,
    this.completed = false,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.separator
                  .resolveFrom(context)
                  .withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: Icon(
                completed
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.circle,
                color: completed
                    ? CupertinoColors.activeGreen
                    : CupertinoColors.inactiveGray,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ClipOval(
              child: Image.network(
                avatarUrl,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
