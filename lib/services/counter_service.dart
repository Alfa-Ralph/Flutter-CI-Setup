/// Counter service for managing counter state
/// This service is designed to be testable
class CounterService {
  int _counter = 0;

  /// Get the current counter value
  int get counter => _counter;

  /// Increment the counter by 1
  void increment() {
    _counter++;
  }

  /// Increment the counter by a specified amount
  void incrementBy(int amount) {
    if (amount < 0) {
      throw ArgumentError('Amount must be non-negative');
    }
    _counter += amount;
  }

  /// Decrement the counter by 1
  void decrement() {
    _counter--;
  }

  /// Reset counter to 0
  void reset() {
    _counter = 0;
  }

  /// Set counter to a specific value
  void setValue(int value) {
    _counter = value;
  }

  /// Check if counter is positive
  bool isPositive() => _counter > 0;

  /// Check if counter is zero
  bool isZero() => _counter == 0;

  /// Get counter as string with custom prefix
  String getCounterDisplay({String prefix = 'Count: '}) {
    return '$prefix$_counter';
  }
}
