//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.timeago

$(document).foundation();

$(document).ready(function() {
  $("time.timeago").timeago();

  $("article.request").click(function(event) {
    var $this = $(this);

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
});
