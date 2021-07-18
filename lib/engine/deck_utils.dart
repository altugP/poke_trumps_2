import 'dart:math';

/// Takes a list of objects and returns
/// same list but shuffled.
///
/// Shuffles inplace of copy of items.
List shuffle(List list) {
  var items = _copyList(list);
  var random = Random();

  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

/// Helper method to copy a given list.
List _copyList(List list) {
  var copy = [];
  for (var i = 0; i < list.length; i++) {
    copy.add(list[i]);
  }
  return copy;
}
