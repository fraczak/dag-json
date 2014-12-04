
toAJson = ($,obj) ->
    aJson = {}
    aJson[$+alias] = {}
    aJson

fromAJson = ($,aJson) ->
    alias = aJson[$+alias]
    obj = {}


module.exports = {toAJson, fromAJson}
