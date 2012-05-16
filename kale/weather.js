var query = escape('select item from weather.forecast where location="GMXX0035" and u="c"');
var url = "http://query.yahooapis.com/v1/public/yql?format=json&q=" + query;
var temp = "N/A";
