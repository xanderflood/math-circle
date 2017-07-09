window.preference_blocks = []

window.preference_blocks.updatePreferenceForm = function(e) {
  selectedId = parseInt($('.ballot-course-selector').val());

  $('.preferences-detach').replaceWith(window.preference_blocks[selectedId])
};

$(function() {
  selectedId = parseInt($('.ballot-course-selector').val());

  $('.preferences-detach').each(function (i) {
    preference_block = $(this);
    courseId = preference_block.data("courseId");
    window.preference_blocks[courseId] = preference_block;


    if (courseId != $('.ballot-course-selector').val())
      preference_block.detach();
  });

  $('.ballot-course-selector').change(window.preference_blocks.updatePreferenceForm);
});
