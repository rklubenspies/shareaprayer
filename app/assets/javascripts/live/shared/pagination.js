(function() {
  var page = 1,
      loading = false,
      endOfList = false;

  function nearBottomOfPage() {
    return $(window).scrollTop() > $(document).height() - $(window).height() - 200;
  }

  $(window).scroll(function(){
    if (loading) {
      return;
    }

    if(nearBottomOfPage() && !endOfList) {
      loading=true;
      page++;
      $.ajax({
        url: $(".requests").data("load-more-url") + "?page=" + page,
        type: 'get',
        dataType: 'script',
        success: function(data, status, response) {
          $(window).sausage('draw');
          loading=false;

          if(response.getResponseHeader('X-SAP-End-Of-List') === '1') {
            console.log("end of list!")
            endOfList = true;
            $('.end-of-list').fadeIn();
          }
        }
      });
    }
  });

  $(window).sausage();
}());