$ = require "jquery"
formatStringURL = require "../../utils/FormatStringURL.coffee"

module.exports = ($timeout, $http) ->
  restrict: 'A'
  link: (scope, elm, attrs) ->
    multiple = attrs.multiple == "true" || attrs.ngMultiple == "true";
    minimumInputLength = if (attrs.minimumInputLength? && !isNaN(attrs.minimumInputLength)) then attrs.minimumInputLength else 3
    maximumInputLength = if (attrs.maximumInputLength? && !isNaN(attrs.maximumInputLength)) then attrs.maximumInputLength else null
    maximumSelectionSize = if (attrs.maximumSelectionSize? && !isNaN(attrs.maximumSelectionSize)) then attrs.maximumSelectionSize else null
    quietMillis = if (attrs.quietMillis? && !isNaN(attrs.quietMillis)) then attrs.quietMillis else 500

    items = []
    inputValue = ""
    timeoutPromise = null;
    callback = null;

    $(elm).on('select2-focus', () ->
      $(elm).parent().find('#s2id_' + attrs.id + ' input').on('input', () ->
        inputValue = $(this).val()
        updateData(inputValue) if (inputValue.length >= minimumInputLength && (maximumInputLength == null || inputValue.length < maximumInputLength))
      )
    )

    scope[attrs.name] = {}

    scope[attrs.name].uiSelect2QueryData =
      minimumInputLength: minimumInputLength
      maximumInputLength: maximumInputLength
      maximumSelectionSize: maximumSelectionSize
      allowClear: attrs.allowClear == "true"
      multiple: multiple
      query: (query) ->
        data = {results: []}
        if (inputValue.length > minimumInputLength)
          angular.forEach(items.results, (item, key) ->
            data.results.push(item)
          )
        callback = query.callback
        query.callback(data)
      formatNoMatches: () ->
        attrs.queryNoMatchesMessage || "Δεν βρέθηκαν αποτελέσματα"
      formatInputTooShort: (input, min) ->
        n = min - input.length
        attrs.queryTooShortMessage || "Παρακαλούμε εισάγετε " + n + " περισσότερο" + (if (n > 1) then "υς" else "") + " χαρακτήρ" + (if (n > 1) then "ες" else "α")
      formatInputTooLong: (input, max) ->
        n = input.length - max
        attrs.queryTooLongMessage || "Παρακαλούμε διαγράψτε " + n + " χαρακτήρ" + (if (n > 1) then "ες" else "α")
      formatSelectionTooBig: (limit) ->
        attrs.querySelectionTooBigMessage || "Μπορείτε να επιλέξετε μόνο " + limit + " αντικείμεν" + (if (limit > 1) then "α" else "ο")
      formatLoadMore: (pageNumber) ->
        attrs.queryLoadMoreMessage || "Φόρτωση περισσότερων…"
      formatSearching: () ->
        attrs.querySearchingMessage || "Αναζήτηση…"
      formatInitMessage: () ->
        attrs.queryInitMessage || "Πληκτρολογήστε στο πεδίο για αναζήτηση"
      initSelection: (element, callback) ->

    elm.on("select2-opening", () ->
      $(".select2-drop .select2-results li.select2-no-results").text(scope[attrs.name].uiSelect2QueryData.formatInitMessage())
      items = {results: []}
      callback(items) if (callback)
    )

    elm.on("select2-open", () ->
      $(".select2-drop .select2-results li.select2-no-results").text(scope[attrs.name].uiSelect2QueryData.formatInitMessage())
    )

    updateData = (val) ->
      $timeout.cancel(timeoutPromise);
      $(".select2-drop .select2-results li.select2-no-results").text(scope[attrs.name].uiSelect2QueryData.formatSearching())
      elm.parent().addClass("ng-loading")
      timeoutPromise = $timeout(
        () ->
          getData(val)
      , quietMillis)

    getData = (val) ->
      url = attrs.uiSelect2Query
      ob = {}
      obj = scope.$eval(attrs.queryMapData) if (attrs.queryMapData?)
      obj.value = val

      url = formatStringURL(url, obj)
      dataType = attrs.queryDataType || "json"

      if (dataType == "jsonp")
        if (url.indexOf("?") < 0)
          url += "?callback=JSON_CALLBACK";
        else
          if (url.indexOf("callback=JSON_CALLBACK") < 0)
            url = url.replace(/\?/gi, "?callback=JSON_CALLBACK&")

        $http.jsonp(url).success((response) ->
          onSuccess response
        ).error(() ->
          onError()
        )
#
      else
        $http.get(url).success(onSuccess).error(onError);

      onError = () ->
        elm.parent().removeClass("ng-loading");
        data =
          hasError: true
        callback(data) if (callback)

      onSuccess = (response) ->

        elm.parent().removeClass("ng-loading");
        data = { results: [] }
        loadedItems = response
        arrayPath = attrs.queryResultsArrayPath
        loadedItems = eval("loadedItems." + arrayPath) if (arrayPath? && arrayPath != "")
        if (!loadedItems?)
          items = []
          callback(data) if (callback)
          return


        id = "id"
        text = "text"
        childId = "id"
        childText = "text"
        childrenPath = "children"
        isParentSelectable = false

        childId = id = attrs.queryResultId if (attrs.queryResultId?)
        childText = text = attrs.queryResultText if (attrs.queryResultText?)
        childId = attrs.queryResultChildId if (attrs.queryResultChildId?)
        childText = attrs.queryResultChildText if (attrs.queryResultChildText?)
        childrenPath = attrs.queryResultChildrenPath if (attrs.queryResultChildrenPath?)
        isParentSelectable = attrs.queryResultIsParentSelectable == "true" if (attrs.queryResultIsParentSelectable?)

        angular.forEach(loadedItems, (item, key) ->
          if (item[childrenPath]? && Array.isArray(item[childrenPath]))
            item.children = []
            angular.forEach(item[childrenPath], (childItem, key) ->
              childItem.id = childItem[childId]
              childItem.text = childItem[childText]
              item.children.push(childItem)
              item.id = item[id] if (isParentSelectable)
              item.text = item[text]
            )
          else
            item.id = item[id]
            item.text = item[text]

          data.results.push(item)
        )

        items = data
        callback(data) if (callback)
