//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require foundation
//= require jquery.doesExist
//= require jquery.sausage
//= require jquery.expanding
//= require jquery.fancy-notifications
//= require jquery.timeago
//= require jquery.stickyPanel

$(document).foundation();

$(document).ready(function() {
  $(".post-request textarea").expandingTextarea();
  $.FancyNotifications();
  $("time.timeago").timeago();


  $(document).on('click', 'article.request', function(event) {
    if( $(event.target).hasClass("request") ) {
      var $this = $(event.target);
    } else if( $(event.target).hasClass("text") || $(event.target).hasClass("ribbon-edge") ) {
      var $this = $(event.target).parent();
    } else if( $(event.target).is("img") ) {
      var $this = $(event.target).parent().parent();
    } else {
      return false;
    }

    if($this.hasClass("expanded")) {
      $this.removeClass("expanded");
      $this.find("#long").hide();
      $this.find("#short").show();
    } else {
      var $expanded = $("article.request.expanded");
      $expanded.removeClass("expanded");
      $expanded.find("#long").hide();
      $expanded.find("#short").show();
    
      $this.addClass("expanded");
      $this.find("#short").hide();
      $this.find("#long").show();
    }
  });


  $('.post-request textarea').bind("focus mousedown", "click", function(event) {
    $('.post-request .options').slideDown();
  });

  $(".post-request form").bind("reset", function() {
    $('.post-request .options').slideUp();
    $('.post-request textarea').expandingTextarea('destroy');

    setTimeout(function() {
      $(".post-request textarea").expandingTextarea();
    }, 1);
  });


  $("section.sidebar").stickyPanel({
    topPadding: 20
  });
});
