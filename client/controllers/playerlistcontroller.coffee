class PlayerListController
  constructor: (@app) ->
    @controllerName = 'playerList'    
    @listElmnt = $('div#players')
    
  update: (args) ->
    @listElmnt.html ''
    @listElmnt.append "<div class='nick'>" + nick + "</div>" for nick in args.list
