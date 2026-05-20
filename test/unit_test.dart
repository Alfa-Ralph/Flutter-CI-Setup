import 'package:flutter_ci_setup/services/counter_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterService', () {
    late CounterService counterService;

    setUp(() {
      counterService = CounterService();
    });

    group('Initial State', () {
      test('counter starts at 0', () {
        expect(counterService.counter, equals(0));
      });

      test('isZero returns true on initialization', () {
        expect(counterService.isZero(), true);
      });

      test('isPositive returns false on initialization', () {
        expect(counterService.isPositive(), false);
      });
    });

    group('Increment Operations', () {
      test('increment increments counter by 1', () {
        counterService.increment();
        expect(counterService.counter, equals(1));
      });

      test('increment multiple times', () {
        counterService.increment();
        counterService.increment();
        counterService.increment();
        expect(counterService.counter, equals(3));
      });

      test('incrementBy adds specified amount', () {
        counterService.incrementBy(5);
        expect(counterService.counter, equals(5));
      });

      test('incrementBy with 0 keeps counter same', () {
        counterService.incrementBy(0);
        expect(counterService.counter, equals(0));
      });

      test('incrementBy throws on negative amount', () {
        expect(
          () => counterService.incrementBy(-1),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Decrement Operations', () {
      test('decrement decrements counter by 1', () {
        counterService.setValue(5);
        counterService.decrement();
        expect(counterService.counter, equals(4));
      });

      test('decrement can go negative', () {
        counterService.decrement();
        expect(counterService.counter, equals(-1));
      });
    });

    group('Reset and SetValue', () {
      test('reset sets counter to 0', () {
        counterService.setValue(10);
        counterService.reset();
        expect(counterService.counter, equals(0));
      });

      test('setValue sets counter to specific value', () {
        counterService.setValue(42);
        expect(counterService.counter, equals(42));
      });

      test('setValue can set negative values', () {
        counterService.setValue(-5);
        expect(counterService.counter, equals(-5));
      });
    });

    group('Helper Methods', () {
      test('isPositive returns true when counter > 0', () {
        counterService.setValue(1);
        expect(counterService.isPositive(), true);
      });

      test('isPositive returns false when counter <= 0', () {
        expect(counterService.isPositive(), false);
        counterService.setValue(-1);
        expect(counterService.isPositive(), false);
      });

      test('isZero returns true only when counter is 0', () {
        expect(counterService.isZero(), true);
        counterService.increment();
        expect(counterService.isZero(), false);
      });

      test('getCounterDisplay with default prefix', () {
        counterService.setValue(5);
        expect(counterService.getCounterDisplay(), equals('Count: 5'));
      });

      test('getCounterDisplay with custom prefix', () {
        counterService.setValue(5);
        expect(
          counterService.getCounterDisplay(prefix: 'Value: '),
          equals('Value: 5'),
        );
      });
    });

    group('Edge Cases', () {
      test('multiple operations in sequence', () {
        counterService.increment();
        counterService.incrementBy(3);
        counterService.decrement();
        expect(counterService.counter, equals(3));
      });

      test('reset after operations', () {
        counterService.incrementBy(10);
        expect(counterService.counter, equals(10));
        counterService.reset();
        expect(counterService.counter, equals(0));
      });

      test('setValue overrides previous value', () {
        counterService.increment();
        counterService.setValue(100);
        expect(counterService.counter, equals(100));
      });
    });
  });
}
