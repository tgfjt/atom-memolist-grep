{SelectListView} = require 'atom'

module.exports =
class AtomMemolistPanel extends SelectListView
  initialize: (lists) ->
    super
    @settings = atom.config.get('atom-memolist')
    @addClass('overlay from-top')
    @setItems(lists)
    atom.workspaceView.append(this)
    @focusFilterEditor()

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    console.log("#{@settings.memo_dir_path + '/' + item} is found")
    atom.workspaceView.open @settings.memo_dir_path + '/' + item
