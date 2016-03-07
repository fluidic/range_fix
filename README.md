# range_fix

A workaround for the [Range.getClientRects bug][bug] in Chrome. A dart port of [rangefix][rangefix].

[rangefix]: https://github.com/edg2s/rangefix
[bug]: https://code.google.com/p/chromium/issues/detail?id=324437

## Usage

A simple usage example:

```dart
final range = window.getSelection().getRangeAt(0);

final rects = RangeFix.getClientRects(range);
for (final rect in rects) {
  // Do whatever you want.
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/fluidic/range_fix/issues
