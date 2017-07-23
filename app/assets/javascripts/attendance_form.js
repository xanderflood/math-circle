$(function() {
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
});
