var goog = {};
goog.appengine = {};
goog.appengine.Channel = function (token) {
  console.log("got token"+token);
};
goog.appengine.Socket = function () {
};
goog.appengine.Channel.prototype.open = function () {
  return new goog.appengine.Socket();
};
