double percentDiff(double a, double b) {
  return (a - b) / b;
}

double median(List a) {
  var middle = a.length ~/ 2;
  if (a.length % 2 == 1) {
    return a[middle].toDouble();
  } else {
    return (a[middle - 1] + a[middle]) / 2.0;
  }
}
