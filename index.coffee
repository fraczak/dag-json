ld = require "lodash"

reMap = (map) -> ($) -> (x) ->
    if (ld.isString x) and (0 is x.indexOf $)
        return map[x]
    x

toAJson = (root, $="$") ->
    dict = {}
    _getOrAdd = (o) ->
        if (ld.isArray o)
            oValue = (_getOrAdd e for e in o)
            oLabel = "#{$}[#{oValue.join ','}]"
        else if (ld.isPlainObject o)
            oValue = {}
            aux = []
            for l,e of o
                oValue[l] = _getOrAdd e
                aux.push "#{l}:#{oValue[l]}"
            oLabel = "#{$}{#{aux.join ','}}"
        else
            return o
        dict[oLabel] ?= oValue
        oLabel
    root = _getOrAdd root
    count = 0
    map = {}
    res = {}
    for l,e of dict
        map[l] = $ + count.toString 36
        count++
    myMap = (reMap map) $
    for l,e of dict
        res[map[l]] = ld.transform e, (r, val, key) ->
            r[key] = myMap val
    if root is myMap root
        return root
    res

fromAJson = (aJson,$='$') ->
    result = ""
    return aJson unless ld.isPlainObject aJson
    myMap = (reMap aJson) $
    for l,e of aJson
        result = aJson[l] = ld.transform e, (r,v,k) ->
            r[k] = aJson[k] = myMap v
    result

module.exports = {toAJson, fromAJson}
