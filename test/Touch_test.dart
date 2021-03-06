//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, Feb 22, 2013  04:06:21 PM
// Author: henrichen

import 'dart:async';
import 'dart:utf';
import 'package:unittest/unittest.dart';
import 'package:memcached_client/memcached_client.dart';
import 'package:couchclient/couchclient.dart';
import 'CouchbaseTestUtil.dart' as cc;

void testTouch(CouchClient client) {
  expect(client.set('key100', encodeUtf8('val100')), completion(isTrue));
  Future f1 = client.get('key100')
    .then((val) {
      expect(val.data, equals(encodeUtf8('val100')));
      return client.touch('key100', 1); //expire in 1 seconds
    }).then((b) {
      expect(b, isTrue);
      return new Future.delayed(new Duration(seconds:2));
    }).then((_) {
      return client.get('key100');
    });

  expect(f1, throwsA(equals(OPStatus.KEY_NOT_FOUND)));
}

void main() {
  setupLogger();
  group('BinaryTouchTest:', () {
    CouchClient client;
    setUp(() => cc.prepareCouchClient().then((c) => client = c));
    tearDown(() => client.close());
    test('TestTouch', () => testTouch(client));
  });
}
