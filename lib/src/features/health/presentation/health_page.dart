import 'package:flutter/cupertino.dart';
import '../../tasks/presentation/task_widget.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('HEALTH BAR', style: TextStyle(fontSize: 24)),
      ),
      child: SafeArea(
        child: ListView(
          children: const [
            TaskTile(
              title: 'WE ARE ON THE HEALTH PAGE',
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
