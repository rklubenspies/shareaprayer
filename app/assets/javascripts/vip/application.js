//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.fancy-notifications

var braintree = Braintree.create($("body").data("client-encryption-key"));
braintree.onSubmitEncryptForm('vip-setup-form');

$(document).foundation();

$(document).ready(function() {
  $.FancyNotifications();

  jQuery.validator.setDefaults({
    onfocusout: function(element, event) {
      this.element(element);
    },
    onkeyup: false,
    submitHandler: function(form) {
      form.submit();
    },
  });

  $('#vip-setup-form').validate({
    rules: {
      'vip[email]': {
        required: true,
        email: true,
      },
      'vip[bio]': "required",
      'vip[phone]': "phoneUS",
    },
  });

  $('#vip-setup-form').submit(function(){
    $('input[type=submit]', this).attr('disabled', 'disabled');
    $('input[type=reset]', this).attr('disabled', 'disabled');
  });
});