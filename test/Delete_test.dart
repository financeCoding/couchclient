//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, Feb 22, 2013  04:33:48 PM
// Author: henrichen

import 'dart:async';
import 'dart:utf';
import 'package:logging/logging.dart';
import 'package:unittest/unittest.dart';
import 'package:rikulo_memcached/memcached.dart';
import 'MemcachedTestUtil.dart' as m;

//delete key3
void testDelete1(MemcachedClient client) {
  expect(client.set('key3', encodeUtf8('va13')), completion(isTrue));
  expect(client.delete('key3'), completion(isTrue));
}

//delete inexist key3; should throw NOT_FOUND
void testDelete2(MemcachedClient client) {
  expect(client.delete('key3'), throwsA(equals(OPStatus.KEY_NOT_FOUND)));
}

void main() {
  setupLogger(level: Level.ALL);
  group('TextDeleteTest:', () {
    MemcachedClient client;
    setUp(() => m.prepareTextClient().then((c) => client = c));
    tearDown(() => client.close());
    test('TestDelete1', () => testDelete1(client));
    test('TestDelete2', () => testDelete2(client));
  });
  group('BinaryDeleteTest:', () {
    MemcachedClient client;
    setUp(() => m.prepareBinaryClient().then((c) => client = c));
    tearDown(() => client.close());
    test('TestDelete1', () => testDelete1(client));
    test('TestDelete2', () => testDelete2(client));
  });
}



