{pack, unpack, unalias} = require "./index.coffee"

a = {a:[1,2],b:[1,2],c:[1,2]}
b = {a:a,b:a,c:a}
c = {a:b,b:b,c:b}
d = {a:c,b:c,c:c}
e = {a:d,b:d,c:d}
f = [e,e,e,e]
g = [f,f,f,f]

bigObject = [g,g,g,f,f,g]

strOrigin = JSON.stringify bigObject

packed = pack bigObject

console.log strPacked = JSON.stringify packed

unpacked = unpack packed
strUnpacked = JSON.stringify unpacked
if (strOrigin is strUnpacked)
    console.log "SUCCEEDED [#{strPacked.length}/#{strOrigin.length}]"
else
    console.log "FAILED ['origin' and 'after' strings should be equal]"
    console.log " origin json: #{strOrigin}"
    console.log ".. and after: #{strUnpacked}"
    throw "    'origin' and 'after' strings should be equal"

console.log pack {a:{a:1,b:2}, b:{b:2,a:1}}

a =
    "$":
        "$a": a: "$b", b: 12
        "$b": [1,2,3]
    hey: ["$a", "$b", "$a", 12]
    ho: a: "$a", b: "$a"

console.log JSON.stringify unalias a
b =
    "$":
        "$a": a: "$b", b: 12
        "$b": [1,2, "$a"]
    hey: ["$a", "$b", "$a", 12]
    ho: a: "$a", b: "$a"



