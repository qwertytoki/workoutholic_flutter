class WorkType {
  const WorkType(this._value);
  final String _value;
  String get value => _value;

  static const String LIFT_VALUE = 'LIFT';
  static const String KEEP_VALUE = 'KEEP';

  static const WorkType LIFT = WorkType(LIFT_VALUE);
  static const WorkType KEEP = WorkType(KEEP_VALUE);

  static List<WorkType> values() {
    return [WorkType.LIFT, WorkType.KEEP];
  }

  static WorkType of(String category) {
    switch (category) {
      case LIFT_VALUE:
        return WorkType.LIFT;
      case KEEP_VALUE:
        return WorkType.KEEP;
    }
    return WorkType.LIFT;
  }
}
