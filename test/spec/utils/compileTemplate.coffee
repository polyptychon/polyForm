module.exports = (options, template, scope, $compile) ->
  element = $("<div></div>").html(template({ options: options }))
  $compile(element)(scope)
  scope.$digest()
  return element
