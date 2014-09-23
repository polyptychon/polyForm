formatStringURL = require "./FormatStringURL.coffee"

module.exports = (url, mapData, scope) ->
  obj = {};
  if (typeof mapData != "undefined")
    obj = scope.$eval(mapData)

  formatStringURL(url, obj)
