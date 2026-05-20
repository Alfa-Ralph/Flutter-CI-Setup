class CounterService {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
  }

  void incrementBy(int amount) {
    if (amount < 0) {
      throw ArgumentError('Amount must be non-negative');
    }
    _counter += amount;
  }

  void decrement() {
    _counter--;
  }

  void reset() {
    _counter = 0;
  }

  void setValue(int value) {
    _counter = value;
  }

  bool isPositive() => _counter > 0;

  bool isZero() => _counter == 0;

  String getCounterDisplay({String prefix = 'Count: '}) {
    return '$prefix$_counter';
  }
}
