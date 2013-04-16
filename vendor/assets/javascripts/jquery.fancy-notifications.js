// =======================================================================
// Fancy jQuery Notifications
//
// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
//
//
// Requires: jquery
//
// Author: Michael Luckeneder (https://github.com/mluckeneder)
//
//
// =======================================================================

(function( $ ){
  var $closeTimeout;

  var setupNotificationBehavior = function(){
  	$(".flash").click(function(){
  		$.FancyNotifications.close();
  		$(this).slideUp('slow');
  	});

  	$('.flash').slideDown('slow');
  	$closeTimeout = setTimeout("$('.flash').slideUp('slow',function(){ $(this).remove();});","10000");
  };

  
  $.FancyNotifications = function() {
  	setupNotificationBehavior();
  };

  $.FancyNotifications.error = function(message){
  	$.FancyNotifications.close();
  	this.showMessage("error", message);
  };

  $.FancyNotifications.alert = function(message){
  	$.FancyNotifications.close();
  	this.showMessage("alert", message);
  };

  $.FancyNotifications.notice = function(message){
  	$.FancyNotifications.close();
  	this.showMessage("notice", message);
  };

  $.FancyNotifications.showMessage = function(type,message){
    var $div = $("<div></div>");
  	$div.attr("class","flash "+type);
  	$div.hide();
  	$div.html(message);

  	$('body').prepend($div);

  	setupNotificationBehavior();
  };
  
  $.FancyNotifications.close = function(){
  	clearTimeout($closeTimeout);
  	$('.flash').slideUp('slow',function(){ $(this).remove();});
  };
})( jQuery );