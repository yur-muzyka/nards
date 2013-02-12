$(document).ready(function () {
	Load();
    $("#chat_text").focus();
    setInterval("Load();", 10000);
});  

var last_message_id = 0;
var load_in_process = false;

function Load() {
    if(!load_in_process)
    {
	    load_in_process = true; 

    	$.post("ajax/load", 
    	{
      	    last: last_message_id,
    	},
   	    function (result) {
			eval(result);
			$(".chat").scrollTop($(".chat").get(0).scrollHeight);
		    load_in_process = false;
    	});
    }
}