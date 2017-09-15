// Set up a storage place for row models
window.attendanceForm = window.attendanceForm || {}

$(function() {
  // // // First, set up  all the JQuery callbacks // // //
  // Process data from attendance form and submit it
  $(".attendance-form .actions input").click(function(e) {
    var table = $(e.target);

    // build the data to be submitted
    var attendance = {};
    $(".attendance-row").each(function(i, row) {
      var student_id = $(row).find(".student-id").val();
      var status_val = $(row).find(".status-select").val();
      attendance[student_id] = status_val;
    });

    // disable the fake form fields
    table.find(".no-submit").prop("disabled", true);

    // put it in the hidden field (.attendance-input)
    $(".attendance-form .attendance-input")
      .val(JSON.stringify(attendance));

    return true;
  });

  // Add unregistered row
  $("table.rollcall-table tbody.controls button.new-unregistered").click(function(e) {
    $("table.rollcall-table tbody.extras").append(
      window.attendanceForm.unregisteredModel.clone(true));
  });

  // Add unexpected row
  $("table.rollcall-table tbody.controls button.new-unexpected").click(function(e) {
    $("table.rollcall-table tbody.extras").append(
      window.attendanceForm.unexpectedModel.clone(true));
  });

  // Delete row
  $("table.rollcall-table tbody.extras a.delete-row").click(function(e) {
    $(this).closest("tr.attendance-row").remove();
  });

  // // // THEN, copy the models, this way they have the necessary events // // //
  modelGroup = $("table.rollcall-table tbody.extras.models");
  window.attendanceForm.unexpectedModel   = modelGroup.find(".unexpected-row");
  window.attendanceForm.unregisteredModel = modelGroup.find(".unregistered-row");

  window.attendanceForm.unexpectedModel.detach();
  window.attendanceForm.unregisteredModel.detach();
  modelGroup.remove();
});
