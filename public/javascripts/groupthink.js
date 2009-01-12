function clone(obj){
  if(obj == null || typeof(obj) != 'object')
    return obj;
  var temp = new obj.constructor(); // changed (twice)
  for(var key in obj)
    temp[key] = clone(obj[key]);
  return temp;
}

$(document).ready(function() {
  $("li.column ul a[@title]").livequery("click", function(e) {
    // if all columns are pinned, open link in new column, otherwise load into first unpinned column
    if ($("ul.cat_container").children("li.column").hasClass("pinned")) {
      e.preventDefault();
      var link = this;
      
      $.get(this.href, function(html) {
        children = $("ul.cat_container > li.column:not(.pinned):first"); // has to be global, FF/JQuery bug?
        
        // find out where we are now so we can store that in new history state
        var currentHistoryState = clone(historyStorage.get(dhtmlHistory.getCurrentLocation()));
        
        if (children.length > 0) {
          //for (var i in currentHistoryState) {
            //if (currentHistoryState[i] == 
          //}
          children.replaceWith(html);
        } else {
          // insert new column after the current column
          $(link).parents("li.column").after(html);
          
          // add to history
          var title = link.title;
          if (currentHistoryState == null) {
            currentHistoryState = {};
          } else {
            var i = "";
            for (i in currentHistoryState) {}
            // we just want to append the last title
            title += "-" + i;
          }
          currentHistoryState[title] = link.href;
          dhtmlHistory.add(title, currentHistoryState);
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
    e.preventDefault();
    $(this).parents("li.column").remove();
  });
  
  $('a[method]').livequery(function() {
    var message = $(this).attr('confirm');
    var method  = $(this).attr('method');
    
    if (!method && !message) {return;}
    
    $(this).click(function(event){
      event.preventDefault();
      if (message && !confirm(message)) {
        return;
      }
      
      var self = $(this);
      
      args = (method == 'post') ? {} : {'_method': method};
      $.post($(this).attr("rel"), args, function(json) {
        self.parents("li:first").remove();
        if ($("div#notice")) {
          $("div#notice").html(json.message);
        } else {
          $("div#content").prepend('<div class="message notice">' + json.message + '</div>');
        }
      }, "json");
    });
  });
  
  $("form.delete-btn").submit(function() {
    return confirm("Are you sure you want to delete this?");
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
  console.info("A history change has occurred: "
        + "newLocation="+newLocation
        + ", historyData="+historyData);

  $("ul.cat_container li.column:gt(0)").remove();
  for (var i in historyData) {
    $.get(historyData[i], function(html) {
      $("li.column:first").after(html);
    });
  }
}

window.onload = function() {
	dhtmlHistory.initialize();
	dhtmlHistory.addListener(historyChange);
};
