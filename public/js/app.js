$(document).ready(function() {
	$(".index h4").click(function(e) {
		$(".grid div").slideUp();
		var target_parent_id = '#' + $(this).parent().attr('id').split('_')[0] + '_grid';
		$(target_parent_id).children("div").slideDown();
	});

	$("a.connect").click(function(e) {
		alert("Connecting " + $(this).data("input") + " to " + $(this).data("output"));
	});

	$("a.disconnect").click(function(e) {
		alert("Disconnecting " + $(this).data("input") + " from " + $(this).data("output"));
	});

});