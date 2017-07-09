$(function() {
  $(".multi-collapse-control").click(function(e) {
    var multiCollapseId = $(e.target).data('multiCollapseId');
    debugger;
    $('.multi-collapse-target[data-multi-collapse-id="' + multiCollapseId + '"]').collapse('toggle');
  });
});
