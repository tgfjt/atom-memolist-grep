{View, EditorView, $} = require 'atom'
GrepFiles = require './atom-memolist-files'
ShowPanel = require './atom-memolist-panel'
path = require 'path'

module.exports =
class AtomMemolistGrepView extends View
  AtomMemolistGrep: null

  @activate: (state) ->
    @atomMemolistNew = new AtomMemolistGrepView(state.atomMemolistGrep)

  initialize: ->
    atom.workspaceView.command 'atom-memolist-grep:toggle', => @toggle()
    @miniEditor.setPlaceholderText('Enter Keyword to search Memo');
    @on 'core:confirm', => @confirm()
    @on 'core:cancel', => @detach()

  @detaching: false

  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()

  @content: (params)->
    @div class: 'atom-memolist-grep overlay from-top select-list', =>
      @subview 'miniEditor', new EditorView({mini:true})

  confirm: ->
    keyword = @miniEditor.getEditor().getText()

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
    @detaching = true
    @miniEditor.setText ''

    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.workspaceView.focus()

    super

    @detaching = false

  attach: ->
    console.log 'atom-memolist-grep: attach'
    @detaching = true
    @previouslyFocusedElement = $(':focus')
    atom.workspaceView.append(this)
    @miniEditor.focus()
