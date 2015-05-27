{View, TextEditorView, $} = require 'atom-space-pen-views'
GrepFiles = require './atom-memolist-execgrep'
ShowPanel = require './atom-memolist-panel'
path = require 'path'

module.exports =
class AtomMemolistGrepView extends View
  AtomMemolistGrep: null

  @activate: (state) ->
    @atomMemolistNew = new AtomMemolistGrepView(state.atomMemolistGrep)

  initialize: ->
    atom.commands.add "atom-workspace",
      'atom-memolist-grep:toggle', => @toggle()
    atom.commands.add(this[0], 'core:confirm', () => this.confirm())
    atom.commands.add(this[0], 'core:cancel', () => this.detach())

  @cancelling: false

  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()

  @content: (params)->
    @div class: 'atom-memolist-grep overlay from-top select-list', =>
      @subview 'miniEditor', new TextEditorView({
        mini: true
        placeholderText: 'Enter Keyword to search Memo'
      })

  confirm: ->
    keyword = @miniEditor.getText()

    memodir = atom.config.get('atom-memolist.memo_dir_path')

    callbacks = (data, obj) ->
      try
        list = data.split('\n').filter(Boolean)
        panel = new ShowPanel(list.map (file) ->
          path.basename file)
        obj.detach()
      catch error
        console.log error

    GrepFiles callbacks, keyword, memodir, this

    @detach()

  detach: ->
    return unless @hasParent()

    console.log 'atom-memolist-grep: detach'
    @cancelling = true
    @miniEditor.setText ''

    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()

    super

    @cancelling = false

  attach: ->
    console.log 'atom-memolist-grep: attach'
    @cancelling = true
    @previouslyFocusedElement = $(':focus')
    atom.workspace.addTopPanel(item: this)
    @miniEditor.focus()
