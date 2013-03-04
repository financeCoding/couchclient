//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Wed, Feb 27, 2013  09:34:10 AM
// Author: hernichen

part of rikulo_memcached;

/** A Store Operation of binary protocol */
class BinaryStoreOP extends BinaryOP implements StoreOP {
  final Completer _cmpl; //completer to complete the future of this operation
  final int _req_extralen;

  Future<bool> get future
  => _cmpl.future;

  BinaryStoreOP(OPType type, String key, int flags, int exp, List<int> doc,
                [int cas, int msecs = _TIMEOUT])
      : _req_extralen = type == OPType.append || type == OPType.prepend ? 0 : 8,
        _cmpl = new Completer(),
        super(msecs) {
    _cmd = _prepareStoreCommand(type, key, flags, exp, doc, cas);
  }

  //@Override
  int handleData(List<int> line) {
    print("BinaryStoreOpData: $this, $line\n");
    if (_status != 0)
      _cmpl.completeError(OPStatus.valueOf(_status));
    else {
      _cmpl.complete(true);
    }

    return _HANDLE_COMPLETE;
  }


  /** Prepare a store command.
   */

  List<int> _prepareStoreCommand(OPType type, String key, int flags, int exp,
      List<int> doc, int cas, [int vbucketID = 0]) {
    List<int> keybytes = encodeUtf8(key);
    int keylen = keybytes.length;
    int valuelen = doc.length;
    int bodylen = _req_extralen + keylen + valuelen;

    Uint8List cmd = new Uint8List(24 + bodylen);
    //0, 1 byte: Magic byte of request
    cmd[0] = _MAGIC_REQ;
    //1, 1 byte: Opcode
    cmd[1] = type.ordinal;
    //2, 2 bytes: Key length
    Arrays.copy(int16ToBytes(keylen), 0, cmd, 2, 2);
    //4, 2 bytes: extra length
    Arrays.copy(int8ToBytes(_req_extralen), 0, cmd, 4, 1);
    //6, 2 bytes: vBucket id
    if (0 != vbucketID)
      Arrays.copy(int16ToBytes(vbucketID), 0, cmd, 6, 2);
    //8, 4 bytes: total body length
    Arrays.copy(int32ToBytes(bodylen), 0, cmd, 8, 4);
    //12, 4 bytes: Opaque
    //16, 8 bytes: CAS
    if (cas != null && 0 != cas)
      Arrays.copy(int64ToBytes(cas), 0, cmd, 16, 8);
    //24, _req_extralen: extra
    if (flags != null && 0 != flags)
      Arrays.copy(int32ToBytes(flags), 0, cmd, 24, 4);
    if (exp != null && 0 != exp)
      Arrays.copy(int32ToBytes(exp), 0, cmd, 28, 4);
    //24+_req_extralen, keylen: key
    Arrays.copy(keybytes, 0, cmd, 24 + _req_extralen, keylen);
    //24+_req_extralen+keylen, valuelen
    if (valuelen != null && 0 != valuelen)
      Arrays.copy(doc, 0, cmd, 24 + _req_extralen + keylen, valuelen);
    print("_prepareStoreCommand:$cmd\n");
    return cmd;
  }

  String toString()
  => "BinaryStoreOP: $seq";
}

