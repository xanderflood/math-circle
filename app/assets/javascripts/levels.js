window.levelsManager = window.levelsManager || (function () {
  //public
  var _newRow = function(e) {
    modelRow = $("tr.level-row").first();
    newRow = modelRow.clone(true);
    _resetRow(newRow);


    body = $("table.level-table tbody.level-tbody");
    body.append(newRow);

    if ($("table.level-table tr.level-row").length > 1) {
      _setDeletable($("table.level-table tr.level-row"), true);
    }

    _resetRowNumbers($("tbody.level-tbody"));
    _validateAllRows();
    _restrictAllRows();
  }

  var _deleteRow = function(e) {
    row = $(this).closest(".level-row");
    table = row.closest("table.level-table");

    if (table.find("tr.level-row").length == 1) {
      return;
    }

    row.remove();

    if (table.find("tr.level-row").length == 1) {
      _setDeletable(table.find("tr.level-row"), false);
    }

    _resetRowNumbers(table);
    _validateAllRows();
    _restrictAllRows();
  }

  var _validateAllRows = function() {
    $("tr.level-row").each(function(i, input) {
       _validateRowFromElement($(input));
    })
  }

  var _validateRow = function (e) {
    _validateRowFromElement($(this).closest(".level-row"));
  }

  var _validateRowFromElement = function(row) {
    invalid = false;

    nameField = row.find("input.name");
    thisName = nameField.val();
    if ($.trim(thisName) == "") {
      _setExclamation(row, true);
      return;
    }

    $("tr.level-row input.name").each(function(i, input) {
      name = $(input).val();
      if (name == thisName && input != nameField[0]) {
        invalid = true;
        return false;
      }
    });

    if (invalid) {
      _setExclamation(row, true);
      return;
    }

    restricted = row.find(".restricted").is(":checked");
    if (!restricted) {
      minGrade = parseInt(row.find("select.min-grade").val());
      maxGrade = parseInt(row.find("select.max-grade").val());
      if (minGrade > maxGrade) {
        _setExclamation(row, true);
        return;
      }
    }

    _setExclamation(row, false);
  }

  var _moveRow = function(e) {
    row = $(e.target).closest("tr.level-row");
    newPos = parseInt(row.find(".position").val());
    if (isNaN(newPos) || (typeof(newPos) == "undefined") || (newPos < 1)) { newPos = 1; }

    tbody = $(e.target).closest("tbody.level-tbody");
    rows$ = tbody.find("tr");

    if (tbody.find("tr.level-row:nth-child(" + newPos + ")")[0] == row[0]) {
      _resetRowNumbers(tbody);
      return;
    }

    row.detach()
    rows$ = tbody.find("tr")

    if (newPos <= 1) {
      row.insertBefore(rows$[0]);
    } else {
      anchor = rows$[newPos-2];
      if (typeof(anchor) == 'undefined') {
        row.insertAfter(rows$.last());
      } else {
        row.insertAfter(anchor);
      }
    }

    _resetRowNumbers(tbody);
  }

  var _submitJSON = function(e) {
    //disable the button
    $(this).find("input.select").prop("disabled", false);

    //build the object
    result = {};
    $("tr.level-row").each(function(i, row) {
      obj = {};

      obj["position"]   = parseInt($(row).find("input.position").val());
      obj["name"]       = $(row).find("input.name").val();
      obj["min_grade"]  = parseInt($(row).find("select.min-grade :selected").val());
      obj["max_grade"]  = parseInt($(row).find("select.max-grade :selected").val());
      obj["restricted"] = $(row).find("input.restricted").is(":checked");
      obj["active"]     = $(row).find("input.active").is(":checked");
      obj["id"]         = parseInt($(row).find("input.id").val());

      result[i] = obj;
    });

    //validate the result
    //TODO: validate the result
    //      (this is probably better than
    //      validating the rows themselves)
    //TODO: validation messages?

    if (invalid) {
      e.preventDefault();
      $(this).find("input.select").prop("disabled", false);
    }

    //set the value
    $(this).find("input#level-data").val(JSON.stringify(result));
  }

  var _restrictAllRows = function() {
    $("tr.level-row input.restricted").each(function(i, input) {
      _restrictRowFromElement($(input))
    })
  }

  var _restrictRow = function(e) {
    _restrictRowFromElement($(this));
  }

  var _restrictRowFromElement = function(input) {
    restricted = input.is(":checked")
    row = input.closest("tr.level-row")

    if (restricted) {
      row.find(".min-grade").prop("disabled", true)
      row.find(".max-grade").prop("disabled", true)
    } else {
      row.find(".min-grade").prop("disabled", false)
      row.find(".max-grade").prop("disabled", false)
    }
  }

  //private
  var _resetRowNumbers = function(tbody) {
    tbody.find("tr.level-row").each(function(i, row) {
      $(row).find("input.position").val(i+1);
    });
  }

  var _resetRow = function(row) {
    row.find("input.name").val("");
    row.find("select.min-grade :nth-child(1)").prop('selected', true);
    row.find("select.max-grade :nth-child(1)").prop('selected', true);
    row.find("input.restricted").prop('checked', false);
    row.find("input.active").prop('checked', true);
    row.find("input.id").val("");
  }

  var _setExclamation = function(row, value) {
    if (value) {
      row.addClass("row_with_errors");
    } else {
      row.removeClass("row_with_errors");
    }
  }

  var _setDeletable = function(row, value) {
    if (value) {
      row.find("input.delete").prop('disabled', false);
    } else {
      row.find("input.delete").prop('disabled', true);
    }
  }

  return {
    newRow:          _newRow,
    deleteRow:       _deleteRow,
    submitJSON:      _submitJSON,
    validateAllRows: _validateAllRows,
    validateRow:     _validateRow,
    restrictAllRows: _restrictAllRows,
    restrictRow:     _restrictRow,
    moveRow:         _moveRow
  }
})()

$(function() {
  //row order
  $("tr.level-row input.position").change(window.levelsManager.moveRow);
  $("tr.level-row input.position").keyup(window.levelsManager.validateAllRows);

  //row create/delete
  $("tr.level-row input.delete").click(window.levelsManager.deleteRow);
  $("table.level-table input.create").click(window.levelsManager.newRow);

  //restricted overrides min/max grades
  $("tr.level-row input.restricted").change(window.levelsManager.restrictRow);

  //validations
  $("tr.level-row input.name").change(window.levelsManager.validateAllRows);
  $("tr.level-row input.name").keyup(window.levelsManager.validateAllRows);
  $("tr.level-row select.min-grade").change(window.levelsManager.validateRow);
  $("tr.level-row select.max-grade").change(window.levelsManager.validateRow);
  $("tr.level-row input.validate").change(window.levelsManager.validateRow);
  $("tr.level-row input.restricted").change(window.levelsManager.validateRow);

  //submit form
  $("table.level-table form#level-form").submit(window.levelsManager.submitJSON);

  //validate
  window.levelsManager.validateAllRows();
  window.levelsManager.restrictAllRows();
});
