//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Fri, Feb 01, 2013  19:15:02 PM
// Author: hernichen

part of rikulo_memcached;

class SocketAddress {
  String host;
  int port;

  SocketAddress(this.host, this.port);

  String toUri()
  => '$host:$port';

  String toString()
  => toUri();
}

