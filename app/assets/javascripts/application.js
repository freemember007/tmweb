// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.blockUI
//= require bootstrap
//= require underscore
//= require ember-0.9.5.min
//= require ember-rest
//= require app/app
//= require pages
//= require sessions
//= require items

$(function(){
  $(".field_with_errors").parent().parent().addClass("error");

  $(".user_profile_avatar").hover(function(){
		$(".user_profile_wrapper").slideDown("slow");
  });

	$("html").click(function(){
		$(".user_profile_wrapper").hide();
	});
	
  $(".month_item .desc .share").click(function(){
    var month_item = $(this).parent().parent();
    var share_url_text = month_item.find(".share_link .share_url");
    
    if(month_item.find(".share_link").is(":visible")){
      month_item.find(".share_link").slideUp("fast");
      return;
    }
    
    month_item.find(".share_link").slideDown("fast", function(){
      share_url_text.val("正在计算分享URL..。");
      var button = month_item.find("button");
      button.attr("disabled", "disabled").addClass("disabled");
      var share_url = month_item.find(".desc .share").attr("share_url");
      var item_id = month_item.find(".desc .share").attr("item_id");
      $.ajax({
        type: "get",
        url: share_url,
        data: "item_id=" + item_id,
        success: function(data){
          share_url_text.val(data.url);
          button.removeAttr("disabled").removeClass("disabled");
        }
      });
    });
  });
  
  $(".month_item").find(".desc .delete").click(function(){
    var month_item = $(this).parent().parent();
    month_item.find(".confirm_delete").slideDown("fast", function(){
      $(this).find(".info").click(function(){
        $(this).parent().slideUp("fast");
      });
    });
    month_item.find(".confirm_delete .error").click(function(){
      $(this).button("loading");
      $(this).parent().find(".info").attr("disabled", "disabled").addClass("disabled");
      var delete_url = month_item.find(".desc .delete").attr("delete_url");
			console.log(delete_url);
      $.ajax({
        type: "get",
        url: delete_url,
        success: function(data){
          if(data.success == "true"){
            month_item.slideUp("slow", function(){
              $(this).remove();
            });
          }
        }
      });
    });
  });

});
