import 'package:flutter/cupertino.dart';
import 'package:monday/src/features/blocker/data/blocker_model.dart';

/// Builds a section with a grey title and list of profile cards.
class BlockerWidget extends StatelessWidget {
  final String title;
  final List<BlockerModel> profiles;
  final bool deleteMode;
  final void Function(BlockerModel) onProfileTap;

  const BlockerWidget({
    super.key,
    required this.title,
    this.profiles = const <BlockerModel>[],
    required this.deleteMode,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.inactiveGray,
            ),
          ),
        ),
        ...profiles.map(
          (p) => _ProfileCard(
            profile: p,
            deleteMode: deleteMode,
            onTap: () => onProfileTap(p),
          ),
        ),
      ],
    );
  }
}

/// The red delete bar at bottom with a single Delete button.
Widget buildDeleteBar(VoidCallback onDelete) {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      color: CupertinoColors.systemRed,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SafeArea(
        top: false,
        child: Center(
          child: CupertinoButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: CupertinoColors.white, fontSize: 18),
            ),
            onPressed: onDelete,
          ),
        ),
      ),
    ),
  );
}

/// A single profile card, with optional checkbox in delete mode.
class _ProfileCard extends StatelessWidget {
  final BlockerModel profile;
  final bool deleteMode;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.profile,
    required this.deleteMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: deleteMode ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (deleteMode)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  profile.isSelected
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.circle,
                  color: profile.isSelected
                      ? CupertinoColors.systemRed
                      : CupertinoColors.inactiveGray,
                  size: 24,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '· ${profile.appCount} apps · ${profile.schedule}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the “Create new recurring blocking” action sheet.
void showAddSheet(BuildContext context) {
  showCupertinoModalPopup(
    context: context,
    builder: (_) => CupertinoPopupSurface(
      child: Container(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  Text(
                    'Create new recurring blocking',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Learn more about blocking types',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.inactiveGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Options
            _SheetOption(
              'Time limit\nex: block after 1 hour of social media per day',
            ),
            _SheetOption(
              'Time of day\nex: block social media apps in the morning',
            ),
            _SheetOption(
              'All day (limited unblocks)\nex: 4 intentional sessions per day',
            ),
            // Cancel
            CupertinoButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SheetOption extends StatelessWidget {
  final String text;
  const _SheetOption(this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // TODO: wire up actions
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: CupertinoColors.separator)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
            const Icon(
              CupertinoIcons.forward,
              size: 20,
              color: CupertinoColors.inactiveGray,
            ),
          ],
        ),
      ),
    );
  }
}
