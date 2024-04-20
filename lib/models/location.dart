class Locations {
  late Map<int, String> _indexToLocations;
  late Map<String, int> _locationToIndex;

  Locations() {
    _indexToLocations = {};
    _locationToIndex = {};

    final List<String> colAlphas = ["A", "B", "C", "D", "E"];
    final List<String> rowNums = ["1", "2", "3", "4", "5"];

    int index = 0;
    for (String colAlpha in colAlphas) {
      for (String rowNum in rowNums) {
        final location = colAlpha + rowNum;
        _indexToLocations[index] = location;
        _locationToIndex[location] = index;
        index++;
      }
    }
  }

  Map<int, String> get indexToLocations => _indexToLocations;

  Map<String, int> get locationToIndex => _locationToIndex;
}
