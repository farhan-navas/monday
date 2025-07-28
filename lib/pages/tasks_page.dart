// tasks_page.dart
import 'package:flutter/cupertino.dart';
import '../widgets/task_widget.dart';

/// A hardcoded page showing three tasks.
class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('TASK LIST', style: TextStyle(fontSize: 24)),
      ),
      child: SafeArea(
        child: ListView(
          children: const [
            TaskTile(
              title: 'Draft homepage',
              completed: false,
              avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
            ),
            TaskTile(
              title: 'Send design to client',
              completed: false,
              avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
            ),
            TaskTile(
              title: 'Develop new homepage',
              completed: false,
              avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
