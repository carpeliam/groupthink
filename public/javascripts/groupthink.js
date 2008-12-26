$(document).ready(function() {
  $("ul.cat_container ul.categories a").click(function(e) {
    if ($(this).parents("li.column").children("p").children("a.pin").hasClass("on")) {
      e.preventDefault();
      indicator = '<li class="column"><a href="#" class="pin">pin</a></li>';
      link = this;
      $.get(this.href, function(html) {
        $(link).parents("ul.cat_container").after(html);
      });
    }
  });
  $("ul.cat_container a.pin").click(function(e) {
    $(this).toggleClass("on");
    $(this).html($(this).hasClass("on") ? "unpin" : "pin");
  });
});