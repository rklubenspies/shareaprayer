//= require jquery
//= require jquery_ujs
//= require foundation
//= require jquery.validate
//= require jquery.validate.additional-methods

$(document).foundation();

$(document).ready(function() {
  jQuery.validator.setDefaults({
    onfocusout: function(element, event) {
      this.element(element);
    },
    onkeyup: false,
    submitHandler: function(form) {
      form.submit();
    },
  });

  $('#sign-up-form').validate({
    rules: {
      'user[email]': {
        required: true,
        email: true,
      },
      'user[password]': "required",
      'user[password_confirmation]': {
        equalTo: "#user_password"
      },
      'user[first_name]': "required",
      'user[last_name]': "required",
    },
  });

  $('#password-reset-form').validate({
    rules: {
      'user[email]': {
        required: true,
        email: true,
      },
    },
  });
});