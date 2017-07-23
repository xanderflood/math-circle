$(function() {
  $(".multi-collapse-control").click(function(e) {
    var multiCollapseId = $(e.target).data('multiCollapseId');
    $('.multi-collapse-target[data-multi-collapse-id="' + multiCollapseId + '"]').collapse('toggle');
  });
});
