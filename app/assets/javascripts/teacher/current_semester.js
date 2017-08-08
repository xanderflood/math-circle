$(function() {
  $(".semester-form").submit(function() {
    orig = ($(".original-current-value").val() == "true");
    now  = $(".new-current-value").prop("checked");
    if (orig == false && now == true) {
      return confirm("Changing the current semester will reset the chosen Math-Circle level for all students. Are you sure you want to continue?");
    }

    // otherwise, the user settings will not be reset, and no prompt is needed
    return true;
  });
});
