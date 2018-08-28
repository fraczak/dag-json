isArray = (x) -> Array.isArray(x)

isString = (x) ->
  (typeof x is "string") or (x instanceof String)

isNumber = (x) ->
  (typeof x is "number") or (x instanceof Number)

isPlainObject = (x) ->
  return false if isArray(x) or isNumber(x) or isString(x)
  true

reMap = (map) -> ($) -> (x) ->
  if (isString x) and x.startsWith $
    return map[x]
  x

toAJson = (root, $="$") ->
  dict = {}
  _getOrAdd = (o) ->
    if isArray o
      oValue = o.map _getOrAdd
      oLabel = "#{$}[#{oValue.join ','}]"
    else if isPlainObject o
      oValue = {}
      aux = []
      for l in Object.keys(o).sort()
        oValue[l] = _getOrAdd o[l]
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
  myMap = reMap(map) $
  for l,e of dict
    res[map[l]] = Object.keys(e).reduce (r, key) ->
      val = e[key]
      r[key] = myMap val
      r
    , if isArray(e) then [] else {}
  if root is myMap root
    return root
  res

fromAJson = (aJson,$='$') ->
  result = ""
  return aJson unless isPlainObject aJson
  myMap = (reMap aJson) $
  for l,e of aJson
    result = aJson[l] = Object.keys(e).reduce (r,k) ->
      v = e[k]
      r[k] = aJson[k] = myMap v
      r
    , if isArray(e) then [] else {}
  result

unalias = (obj, $="$") ->
  return obj unless obj[$]
  myMap = (reMap obj[$]) $
  res = {}
  mem = {}
  sub = (o) ->
    if isArray(o) or isPlainObject(o)
      Object.keys(o).reduce (r,k) ->
        v = o[k]
        r[k] = sub v
        r
      , if isArray(o) then [] else {}
    else
      aux = myMap o
      return aux if aux is o
      return mem[o] if mem[o]
      mem[o] = "ERROR: circular definition for #{o}"
      mem[o] = sub myMap o
  for l,e of obj when l isnt $
    res[l] = sub e
  res

module.exports =
  pack: toAJson
  unpack: fromAJson
  unalias: unalias
