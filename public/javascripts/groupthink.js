$(document).ready(function() {
  $("li.column ul a[@title]").livequery("click", function(e) {
    if ($("ul.cat_container").children("li.column").hasClass("pinned")) {
      e.preventDefault();
      var link = this;
      $.get(this.href, function(html) {
        children = $("ul.cat_container > li.column:not(.pinned):first"); // has to be global, FF/JQuery bug?
        if (children.length > 0) {
          children.replaceWith(html);
        } else {
          $(link).parents("li.column").after(html);
          dhtmlHistory.add(link.title, {0: link.href});
        }
      });
    }
  });
  $("ul.cat_container a.pin").livequery("click", function(e) {
    e.preventDefault();
    var column = $(this).parents("li.column");
    column.toggleClass("pinned");
    $(this).html(column.hasClass("pinned") ? "unpin" : "pin");
  });
  $("ul.cat_container a.close").livequery("click", function(e) {
    $(this).parents("li.column").remove();
  });
});

window.dhtmlHistory.create({
  toJSON: function(o) {
    return $.toJSON(o);
  }
  , fromJSON: function(s) {
    return $.evalJSON(s);
  }
});

var historyChange = function(newLocation, historyData) {
  if (newLocation == "") {
    $("ul.cat_container li.column:gt(0)").remove();
  } else {
    $.get(historyData[0], function(html) {
      $("li.column:last").after(html);
      //alert(html);
    });
  }
//	alert("A history change has occurred: "
//        + "newLocation="+newLocation
//        + ", historyData="+historyData, 
//        true);
}

window.onload = function() {
	dhtmlHistory.initialize();
	dhtmlHistory.addListener(historyChange);
};
