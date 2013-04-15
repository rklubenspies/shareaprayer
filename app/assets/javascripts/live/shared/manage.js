//= require jquery.validate
//= require jquery.validate.additional-methods

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

  $('#church-update-form').validate({
    rules: {
      'church[name]]': "required",
      'church[bio]': "required",
      'church[phone]': "phoneUS",
    },
  });
});