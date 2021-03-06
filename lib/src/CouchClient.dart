//Copyright (C) 2013 Potix Corporation. All Rights Reserved.
//History: Thu, Mar 21, 2013  02:19:34 PM
// Author: hernichen

part of couchclient;

/**
 * Client to a Couchbase cluster servers.
 *
 *     Future<CouchClient> future = CouchClient.connect(
 *       [Uri.parse("http://localhost:8091/pools")], "default", "");
 *
 *     // Store a value
 *     future
 *      .then((c) => c.set("someKey", someObject))
 *      .then((ok) => print("done"))
 *      .catchError((err) => print("$err");
 *
 *     // Retrieve a value.
 *     future
 *      .then((c) => c.get("someKey"))
 *      .then((myObject) => print("$myObject"))
 *      .catchError((err) => print("$err");
 */
abstract class CouchClient implements MemcachedClient {
  /**
   * Create a DesignDoc and add into Couchbase; asynchronously return true
   * if succeed.
   */
  Future<bool> addDesignDoc(DesignDoc doc);

  /**
   * Delete the named DesignDoc.
   */
  Future<bool> deleteDesignDoc(String docName);

  /**
   * Retrieve the named DesignDoc.
   */
  Future<DesignDoc> getDesignDoc(String docName);

  /**
   * Retrieve the named View in the named DesignDoc.
   */
  Future<View> getView(String docName, String viewName);

  /**
   * Retrieve the named SpatialView in the named DesignDoc.
   */
  Future<SpatialView> getSpatialView(String docName, String viewName);

  /**
   * query data from the couchbase with the spcified View(can be [View] or
   * [SpatialView]) and query condition.
   */
  Future<ViewResponse> query(ViewBase view, Query query);

  /**
   * Observe a document with the specified key and check its persistency and
   * replicas status in the cluster.
   *
   * + [key] - key of the document
   * + [cas] - expected version of the observed document; null to ignore it. If
   *   specified and the document has been updated, ObserverStatus.MODIFIED
   *   would be returned in ObserveResult.status field.
   */
  Future<Map<MemcachedNode, ObserveResult>> observe(String key, [int cas]);

//  /**
//   * Poll and observe a key with the given cas and persist settings.
//   *
//   * Based on the given persistence and replication settings, it observes the
//   * key and raises an exception if a timeout has been reached. This method is
//   * normally used to make sure that a value is stored to the status you want it
//   * in the cluster.
//   *
//   * If persist is null, it will default to PersistTo.ZERO and if replicate is
//   * null, it will default to ReplicateTo.ZERO. This is the default behavior
//   * and is the same as not observing at all.
//   *
//   * + [key] - the key to observe.
//   * + [cas] - the CAS value for the key; default: null.
//   * + [persist] - the persistence settings; default: [PersistTo.ZERO].
//   * + [replicate] - the replication settings; default: [ReplicateTo.ZERO].
//   * + [delete] - if the key is to be deleted; default: false.
//   */
//  Future<bool> observePoll(String key, {int cas,
//    PersistTo persist: PersistTo.ZERO, ReplicateTo replicate: ReplicateTo.ZERO,
//    bool delete: false});

  /**
   * Create a new client connectting to the specified Couchbase bucket per
   * the given initial server list in the cluster; this method returns a
   * [Future] that will complete with either a [CouchClient] once connected or
   * an error if the server-lookup or connection failed.
   *
   * + [baseList] - the Uri list of one or more servers from the cluster
   * + [bucket] - the bucket name in the cluster you want to connect.
   * + [password] - the password of the bucket
   */
  static Future<CouchClient> connect(
      List<Uri> baseList, String bucket, String password) {
    final factory = new CouchbaseConnectionFactory(baseList, bucket, password);
    return new Future.sync(() => CouchClientImpl.connect(factory));
  }
}
