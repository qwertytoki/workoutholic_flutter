abstract class ListItem {}

// A ListItem that contains data to display a heading.
class SetItem implements ListItem {
  final String setName;
  SetItem(this.setName);
}

// A ListItem that contains data to display a message.
class MenuItem implements ListItem {
  final String menuName;
  MenuItem(this.menuName);
}