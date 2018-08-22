
window.levelsManager = window.levelsManager || (func () {
  //public
  var _newRow = function(e) {
    modelRow = $("table.level-table tr.level-row").first();
    newRow = modelRow.clone(true);
    _resetRow(newRow);

    body = $("table.level-table tbody.levels-tbody");
    body.append(newRow)

    if $("table.level-table tr.level-row").length > 1 {
      _setDeletable(table.find("tr.level-row"), true)
    }
  }

  var _deleteRow = function(e) {
    row = $(this);
    table = row.closest("table.level-table")

    if table.find("tr.level-row").length == 1 {
      return
    }

    row.remove();
    _resetRowNumbers(table);

    if table.find("tr.level-row").length == 1 {
      _setDeletable(table.find("tr.level-row"), false)
    }
  }

  var _validateRow = function(e) {
    names = {}
    invalid = false

    $("tr.level-row input.name").each(function(i, input) {
      name = $(input).value()
      if names[name] {
        invalid = true
        return false
      }
      names[name] = true
    });

    row = $(this).closest(".level-row")
    if invalid {
      _setExclamation(row, true)
      return
    }

    minGrade = row.find(".min-grade")
    maxGrade = row.find(".max-grade")
    if maxGrade < minGrade {
      _setExclamation(row, true)
      return
    }

    _setExclamation(row, false)
  }

  var _moveRow = function(e) {
    //TODO: move this row to the specified position
    //and then reset all the numbders
  }

  var _prepareJSON = function(e) {
    //TODO: validate all rows, generate JSON,
    //and submit (if valid)
  }

  var restrictRow = function(e) {
    //TODO: grey out the min and max grades
    // or un-grey them
  }

  //private
  var _resetRowNumbers = function(table) {
    table.find("tr.level-row input.position").each(function(i, input) {
      $(input).find(":nth-child("+(i+1)+")").prop('selected', true);
    });
  }

  var _resetRow = function(row) {
    row.find("input.name").value("")
    row.find("input.min-grade :nth-child(1)").prop('selected', true);
    row.find("input.max-grade :nth-child(1)").prop('selected', true);
    row.find("input.restricted").prop('checked', false);
    row.find("input.active").prop('checked', false);
    row.find("input.id").value("")
  }

  var _setExclamation = function(row, value) {
    if value {
      row.addClass("field_with_errors")
    } else {
      row.removeClass("field_with_errors")
  }

  var _setDeletable = function(row, value) {
    if value {
      row.find("input.delete").prop('disabled', false);
    } else {
      row.find("input.delete").prop('disabled', true);
    }
  }

  return {
    newRow:      _newRow,
    deleteRow:   _deleteRow,
    prepareJSON: _prepareJSON,
    validateRow: _validateRow,
    restrictRow: _restrictRow,
    moveRow:     _moveRow
  }
})()

$(function() {
  //row management
  $("tr.level-row input.position").change(window.levelsManager.moveRow)
  $("tr.level-row input.delete").click(window.levelsManager.deleteRow)
  $("form.level-form input.create").click(window.levelsManager.newRow)

  //restricted overrides min/max grades
  $("tr.level-row input.restricted").change(window.levelsManager.restrictRow)

  //validations
  $("tr.level-row input.position").change(window.levelsManager.validateRow)
  $("tr.level-row input.name").change(window.levelsManager.validateRow)
  $("tr.level-row input.min-grade").change(window.levelsManager.validateRow)
  $("tr.level-row input.max-grade").change(window.levelsManager.validateRow)

  //submit form
  $("form.level-form input.submit").change(window.levelsManager.prepareJSON)
});
