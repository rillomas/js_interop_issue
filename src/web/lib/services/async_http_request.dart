part of services;

/// A class to run async http requests
class AsyncHttpRequest<Output> {
  Future<Output> request(String url, Output process(String response), {String method: "GET", sendData , Map<String,String> headers: const{}}) async {
    HttpRequest r;
    try {
      r = await HttpRequest.request(url, method:method, sendData:sendData, requestHeaders:headers);
    } catch (error) {
      throw error.target;
    }
    if (r.readyState == HttpRequest.DONE && r.status == 200) {
      // completed normally
      return process(r.responseText);
    }
    // some kind of error occured
    throw r;
  }
}
