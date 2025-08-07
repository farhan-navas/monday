import 'package:flutter/cupertino.dart';
import 'package:monday/src/features/blocker/data/blocker_model.dart';
import 'blocker_widget.dart';

class BlockerPage extends StatefulWidget {
  const BlockerPage({super.key});

  @override
  State<BlockerPage> createState() => _BlockerPageState();
}

class _BlockerPageState extends State<BlockerPage> {
  final List<BlockerModel> _profiles = [
    BlockerModel(name: 'Social Media', appCount: 5, schedule: '10:00pm–7:00am'),
    BlockerModel(
      name: 'Evening wind down',
      appCount: 3,
      schedule: '12:00am–1:00am',
    ),
    BlockerModel(name: 'Work Apps', appCount: 2, schedule: '9:00am–5:00pm'),
    BlockerModel(name: 'Gaming', appCount: 4, schedule: '8:00pm–10:00pm'),
  ];

  bool _deleteMode = false;

  List<BlockerModel> get _currentlyBlocking =>
      _profiles.take(2).toList(); // replace with real logic
  List<BlockerModel> get _upcoming =>
      _profiles.skip(2).toList(); // replace with real logic

  void _toggleDeleteMode() {
    setState(() {
      _deleteMode = !_deleteMode;
      if (!_deleteMode) _profiles.forEach((p) => p.isSelected = false);
    });
  }

  void _deleteSelected() {
    setState(() {
      _profiles.removeWhere((p) => p.isSelected);
      _deleteMode = false;
    });
  }

  void _showAddSheet() => showAddSheet(context);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('APP BLOCKER'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.add),
              onPressed: _showAddSheet,
            ),
            const SizedBox(width: 12),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.trash),
              onPressed: _toggleDeleteMode,
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlockerWidget(
                    title: 'Currently blocking',
                    profiles: _currentlyBlocking,
                    deleteMode: _deleteMode,
                    onProfileTap: (p) {
                      setState(() => p.isSelected = !p.isSelected);
                    },
                  ),
                  BlockerWidget(
                    title: 'Upcoming',
                    profiles: _upcoming,
                    deleteMode: _deleteMode,
                    onProfileTap: (p) {
                      setState(() => p.isSelected = !p.isSelected);
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (_deleteMode) buildDeleteBar(_deleteSelected),
        ],
      ),
    );
  }
}
