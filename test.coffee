{toAJson, fromAJson} = require "./index"

a = {a:[1,2],b:[1,2],c:[1,2]}
b = {a:a,b:a,c:a}
c = {a:b,b:b,c:b}
d = {a:c,b:c,c:c}
e = {a:d,b:d,c:d}
f = [e,e,e,e]
g = [f,f,f,f]

bigObject = [g,g,g,f,f,g]
str = JSON.stringify bigObject
aJson = toAJson bigObject

console.log str3 = JSON.stringify aJson

obj = fromAJson aJson
str2 = JSON.stringify obj
if (str is str2)
    console.log "SUCCEEDED [#{str3.length}/#{str.length}]"
else
    console.log "FAILED"


