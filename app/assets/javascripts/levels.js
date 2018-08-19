
window.levelsManager = window.levelsManager || (func () {
  //public
  var _newRow = function(e) {
    //TODO: duplicate the first row, reset it,
    //and attach it at the end
    //if there was only one before, re-enable
    //its delete button
  }

  var _deleteRow = function(e) {
    //TODO: delete the row - if there's only
    //one left
  }

  var _validateRow = function(e) {
    //TODO: check some validations and then
    //add or remove a market
  }

  var _moveRow = function(e) {
    //TODO: move this row to the specified position
    //and then reset all the numbders
  }

  var _prepareJSON = function(e) {
    //TODO: validate all rows, generate JSON,
    //and submit (if valid)
  }

  var restrictJSON = function(e) {
    //TODO: grey out the min and max grades
    // or un-grey them
  }

  //private
  var _resetRowNumbers = function(table) {
    //TODO: reset all the row numbers to match
    //their positions
  }

  var _resetRow = function(row) {
    //TODO: empty out the inputs and set the
    //order to equal it's current position
  }

  var _setExclamation = function(row, value) {
    //TODO: turn the excalation on/off
  }

  var _setDeletable = function(row, value) {
    //TODO: turn the delete button on/off
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
