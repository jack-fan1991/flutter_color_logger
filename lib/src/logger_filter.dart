class Filter {
  List<String> name = [];
  Filter(this.name);
  factory Filter.allPass() => Filter([]);
}

class ShowWhenFilter extends Filter {
  ShowWhenFilter(List<String> name) : super(name);
}

class HideWhenFilter extends Filter {
  HideWhenFilter(List<String> name) : super(name);
}
