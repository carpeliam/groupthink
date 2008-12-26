//$(document).ready(function() {
  $("li.column ul a").livequery("click", function(e) {
    if ($(this).parents("li.column").children("p").children("a.pin").hasClass("on")) {
      e.preventDefault();
      indicator = '<li class="column"><a href="#" class="pin">pin</a></li>';
      link = this;
      $.get(this.href, function(html) {
        html = '<li class="column">' + html + '</li>';
        $(link).parents("li.column").after(html);
      });
    }
  });
  $("ul.cat_container a.pin").livequery("click", function(e) {
    $(this).toggleClass("on");
    $(this).html($(this).hasClass("on") ? "unpin" : "pin");
  });
//});