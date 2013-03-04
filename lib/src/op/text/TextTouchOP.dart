part of rikulo_memcached;

/** a Touch Operation */
class TextTouchOP extends TextOP implements TouchOP {
  final Completer _cmpl; //completer to complete the future of this operation

  Future<bool> get future
  => _cmpl.future;

  TextTouchOP(String key, int exp, [int msecs = _TIMEOUT])
      : _cmpl = new Completer(),
        super(msecs) {
    _cmd = _prepareTouchCommand(key, exp);
  }

  //@Override
  int handleTextCommand(String line) {
    print("TouchOpCommand: $this, [${line}]\n");
    OPStatus status = TextOPStatus.valueOfError(line);
    if (status != null)
      _cmpl.completeError(status);
    else {
      OPStatus status = TextOPStatus.valueOf(line);
      if (status == null)
        _cmpl.complete(true);
      else
        _cmpl.completeError(status);
    }
    return _HANDLE_COMPLETE;
  }

  //@Override
  int handleData(List<int> data) {
    throw "should never call here!";
  }

  /** Prepare a touch command.
   */
  List<int> _prepareTouchCommand(String key, int exp) {
    List<int> cmd = new List();

    cmd..addAll(encodeUtf8(OPType.touch.name))
       ..add(_SPACE)
       ..addAll(encodeUtf8(key))
       ..add(_SPACE)
       ..addAll(encodeUtf8('$exp'))
       ..addAll(_CRLF);

    print("_prepareTouchCommand:[${decodeUtf8(cmd)}]\n");
    return cmd;
  }

  String toString()
  => "TouchOP: $seq";
}
