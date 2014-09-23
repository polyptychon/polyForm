formatStringURL = (url, obj) ->
  for name in obj
    regx = new RegExp(":"+name)
    url = url.replace(regx, obj[name])
  return url;

module.exports = (url, mapData, scope) ->
  obj = {};
  if (typeof mapData != "undefined")
    obj = scope.$eval(mapData)

  formatStringURL(url, obj)
