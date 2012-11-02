function change_color(color,sum) {
  var rgb, red, green, blue, new_color;
  
  color = color.substring(1);
  rgb = parseInt(color,16);
  
  red = (rgb >> 16) & 0xFF;
  green = (rgb >> 8) & 0xFF;
  blue = rgb & 0xFF;      
  
  red += sum;
  green += sum;
  blue += sum;
  
  red = red < 0 ? red + 256 : red % 256;
  green = green < 0 ? green + 256 : green % 256;
  blue = blue < 0 ? blue + 256 : blue % 256;
  
  red = red.toString(16).length < 2 ? '0' + red.toString(16) : red.toString(16);
  green = green.toString(16).length < 2 ? '0' + green.toString(16) : green.toString(16);
  blue = blue.toString(16).length < 2 ? '0' + blue.toString(16) : blue.toString(16);
  
  new_color = '#' + red + '' + green + '' + blue;
  return new_color;
}

function selectable_territories(territories,context,callback) {
  $('path').off("mouseenter mouseleave click", "**");
  $('path').unbind();
  for(i in territories) {
    t = territories[i];
    $('path#' + t).hover(function(o) {
      var color = $(this).attr('fill');
      $(this).attr('fill',change_color(color,20));
    }, function(o) {
      var color = $(this).attr('fill');
      $(this).attr('fill',change_color(color,-20));
    });
    
    $('path#' + t).on('click',function(o) {
      callback.call(context,$(this).attr('id'));
    });
  }
}
