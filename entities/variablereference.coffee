class VariableReference

  constructor: (@name) ->

  toString: ->
    @name

  analyze: (context) ->
    @referent = context.lookupVariable @name
    @type = @referent.type

  optimize: ->
    this

module.exports = VariableReference
