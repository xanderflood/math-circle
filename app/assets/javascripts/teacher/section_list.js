$(function() {
  $(".section-list-collapse-control").click(function(e) {
    var sectionId = $(e.target).data('sectionId');
    $('.section-collapse-row-' + sectionId).collapse('toggle');
  });
});
