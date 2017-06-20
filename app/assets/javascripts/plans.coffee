# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#indexページ読み込み時に実行されるjs
$(document).ready -> 
  $('#calendar').fullCalendar()
