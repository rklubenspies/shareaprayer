//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.fancy-notifications

$(document).foundation();

$(document).ready(function() {
  $.FancyNotifications();

  // Credit: http://www.paulund.co.uk/smooth-scroll-to-internal-links-with-jquery
  $('a[href^="#"]').bind('click.smoothscroll',function (e) {
    e.preventDefault();
    var target = this.hash;
      $target = $(target);
    $('html, body').stop().animate({
      'scrollTop': $target.offset().top
    }, 500, 'swing', function () {
      window.location.hash = target;
    });
  });
});