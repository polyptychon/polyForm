// Generated by CoffeeScript 1.7.1
(function() {
  module.exports = function(url, obj) {
    var name, regx, value;
    for (name in obj) {
      value = obj[name];
      regx = new RegExp(":" + name);
      url = url.replace(regx, obj[name]);
    }
    return url;
  };

}).call(this);

//# sourceMappingURL=FormatStringURL.map
