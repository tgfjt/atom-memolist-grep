{SelectListView} = require 'atom-space-pen-views'

module.exports =
class AtomMemolistPanel extends SelectListView
  initialize: (lists) ->
    super
    @settings = atom.config.get('atom-memolist')
    @addClass('overlay from-top')
    @setItems(lists)
    atom.workspace.addTopPanel(item: this)
    @focusFilterEditor()

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    console.log("#{@settings.memo_dir_path + '/' + item} is found")
    atom.workspace.open @settings.memo_dir_path + '/' + item
