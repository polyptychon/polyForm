module.exports = (url, obj) ->
  for name in obj
    regx = new RegExp(":"+name)
    url = url.replace(regx, obj[name])
  return url;