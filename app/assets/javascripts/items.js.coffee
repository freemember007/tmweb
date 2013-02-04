# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$(".month_item").hover(
		->
			$(this).find(".desc .share, .desc .delete").fadeIn()
		,
		->
			$(this).find(".desc .share, .desc .delete").fadeOut() if $(this).find(".share_link").is(":hidden")
	)
