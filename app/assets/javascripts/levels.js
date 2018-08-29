window.levelsManager = window.levelsManager || (function () {
  //public
  var _newRow = function(e) {
    modelRow = $("table.level-table tr.level-row").first();
    newRow = modelRow.clone(true);
    _resetRow(newRow);

    body = $("table.level-table tbody.level-tbody");
    body.append(newRow);

    if ($("table.level-table tr.level-row").length > 1) {
      _setDeletable(table.find("tr.level-row"), true);
    }
  }

  var _deleteRow = function(e) {
    row = $(this).closest(".level-row");
    table = row.closest("table.level-table");

    if (table.find("tr.level-row").length == 1) {
      return;
    }

    row.remove();
    _resetRowNumbers(table);

    if (table.find("tr.level-row").length == 1) {
      _setDeletable(table.find("tr.level-row"), false);
    }
  }

  var _validateAllRows = function(e) {
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
    //TODO if negative or out of bounds?

    tbody = $(e.target).closest("tbody.level-tbody");
    rows$ = tbody.find("tr");
    origPos = rows$.index(row[0])+1;
    if (origPos < 0) {
      console.log("row not found") //TODO delete?
      return; //TODO invalidate?
    }

    if (newPos == origPos) {
      return;
    }

    //TODO check for newPos NaNs

    row.detach()
    rows$ = tbody.find("tr")
    
    if (newPos <= 1) {
      row.insertBefore(rows$[0]);
    } else {
      row.insertAfter(rows$[newPos-2]);
    }

    _resetRowNumbers(tbody);
  }

  var _prepareJSON = function(e) {
    //TODO: validate all rows, generate JSON,
    //and submit (if valid)
  }

  var _restrictRow = function(e) {
    input = $(this)
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
    row.find("input.active").prop('checked', false);
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
    prepareJSON:     _prepareJSON,
    validateAllRows: _validateAllRows,
    validateRow:     _validateRow,
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

  //keyup hooks
  //TODO: some keyup hooks?

  //submit form
  $("table.level-table input.submit").change(window.levelsManager.prepareJSON);

  //validate
  window.levelsManager.validateAllRows();
});
