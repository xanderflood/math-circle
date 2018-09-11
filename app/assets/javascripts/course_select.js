window.courseSelect = window.courseSelect || (function() {
  var _go = function(e) {
    link = $(this);
    urlTemplate = link.data().urlTemplate;
    courseID = $("select#course_id :selected").val();

    if (courseID.length != 0) {
      url = urlTemplate.replace("courseID", courseID);

      //allow the default action to take us there
      link.attr("href", url);
    } else {
      return false
    }
  };

  return {go: _go}
})()

$(function () {
  $("a#course_link").click(window.courseSelect.go)
})
