class BlockerModel {
  final String name;
  final int appCount;
  final String schedule;
  bool isSelected;

  BlockerModel({
    required this.name,
    required this.appCount,
    required this.schedule,
    this.isSelected = false,
  });
}
