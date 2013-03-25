// evilwebdesign.bplaced.net
// 2012
// @see http://stackoverflow.com/a/12840450/483418

$.fn.doesExist = function(){
    return jQuery(this).length > 0;
};

$.fn.doesNotExist = function(){
    return jQuery(this).length = 0;
};