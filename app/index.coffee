require('lib/setup')

Spine = require('spine')
Task = require('models/task')
Tasks = require('controllers/tasks')

class TaskApp extends Spine.Controller
  events:
    "submit form":   "create"
    "click  .clear": "clear"

  elements:
    ".items":     "items"
    ".countVal":  "count"
    ".clear":     "clear"
    "form input": "input"

  constructor: ->
    super
    Task.bind("create",  @addOne)
    Task.bind("refresh", @addAll)
    Task.bind("refresh change", @renderCount)
    Task.fetch()

  addOne: (task) =>
    view = new Tasks(item: task)
    @items.append(view.render().el)

  addAll: =>
    Task.each(@addOne)

  create: (e) ->
    e.preventDefault()
    Task.create(name: @input.val())
    @input.val("")

  clear: ->
    Task.destroyDone()

  renderCount: =>
    active = Task.active().length
    @count.text(active)

    inactive = Task.done().length
    if inactive
      @clear.show()
    else
      @clear.hide()

module.exports = TaskApp
