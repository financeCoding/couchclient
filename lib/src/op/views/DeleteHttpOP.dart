//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 07, 2013  02:43:41 PM
// Author: hernichen

part of rikulo_memcached;

abstract class DeleteHttpOP extends HttpOP {
  Future<String> handleCommand(HttpClient hc, Uri baseUri, Uri cmd,
        String user, String pass, [String value]) {
    Completer<String> cmpl = new Completer();
    Future<HttpResult> rf = HttpUtil.uriDelete(hc, baseUri, cmd, user, pass);
    //20130308, henrichen: Tricky! In "DELETE", Dart tends to complain
    //"AsyncError: 'HttpParserException: Connection closed while receiving data'"
    //Don't know the reason. We work around this by check status code!
//    return rf.then((r) {
//      hc.close();
//      return decodeUtf8(r.contents);
//    });
    rf.then((r) {
      hc.close();
      String path = cmd.path;
      int j = path.lastIndexOf('/');
      String docName = path.substring(j+1);
      if (r.status == 200) {
        cmpl.complete('{"ok":true,"id":"_design/$docName"}');
      } else {
        cmpl.complete('{"ok":false,"id":"_design/$docName"}');
      }
    });
    return cmpl.future;
  }
}

