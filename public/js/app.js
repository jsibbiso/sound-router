$(document).ready(function() {
	$(".grid h4").click(function(e) {
		$(".grid div").slideUp();
		$(this).siblings("div").slideDown();
	});

	$("a.connect").click(function(e) {
		alert("Connecting " + $(this).data("input") + " to " + $(this).data("output"));
	});

	$("a.disconnect").click(function(e) {
		alert("Disconnecting " + $(this).data("input") + " from " + $(this).data("output"));
	});

});