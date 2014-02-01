/*
* Sliding Function
* Right Sidebar
* Author: LSL
*/
$(document).ready(function()
{
  $('#menu-right-btn').click(function() {
    if($(this).css("margin-right") == "350px")
    {
        $('#menu-right-container').animate({"margin-right": '-=350'});
        $('#menu-right-btn').animate({"margin-right": '-=350'});
    }
    else
    {
        $('#menu-right-container').animate({"margin-right": '+=350'});
        $('#menu-right-btn').animate({"margin-right": '+=350'});
    }


  });
 });
