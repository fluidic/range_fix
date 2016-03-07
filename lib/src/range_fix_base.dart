// Copyright (c) 2015, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library range_fix.base;

import 'dart:html';

/// Checks if there is a bug in the native implementation of
/// `Range.getClientRects`.
bool isGetClientRectsBroken() {
  final t1 = new Text('aa');
  final p1 = new ParagraphElement()..append(t1);
  final t2 = new Text('aa');
  final p2 = new ParagraphElement()..append(t2);
  document.body..append(p1)..append(p2);

  final range = new Range()
    ..setStart(t1, 1)
    ..setEnd(t2, 1);
  final broken = range.getClientRects().length > 2;

  p1.remove();
  p2.remove();
  return broken;
}

bool _isBroken = isGetClientRectsBroken();

class RangeFix {
  static List<Rectangle> getClientRects(Range range) {
    if (!_isBroken) {
      return range.getClientRects();
    }

    // https://code.google.com/p/chromium/issues/detail?id=324437
    final rects = [];
    var partialRange = new Range();
    var endContainer = range.endContainer;
    var endOffset = range.endOffset;
    while (endContainer != range.commonAncestorContainer) {
      partialRange
        ..setStart(endContainer, 0)
        ..setEnd(endContainer, endOffset);
      rects.addAll(partialRange.getClientRects());
      endOffset = endContainer.parentNode.childNodes.indexOf(endContainer);
      endContainer = endContainer.parentNode;
    }
    partialRange = range.cloneRange();
    partialRange.setEnd(endContainer, endOffset);
    rects.addAll(partialRange.getClientRects());
    rects.sort((a, b) => a.top.compareTo(b.top));
    return rects;
  }
}
