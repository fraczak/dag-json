dag-json
========

Compress a json using tree to dag transformation. For example:

        ajson = require "dag-json"

        #lets generate a bigger json
        big = (f=(x)->if(x)then(ff=f(x-1);{a:ff,b:ff})else[1,2]) 16
        console.log (JSON.stringify big).length
        # 1048565

        console.log packed = ajson.pack big
        #{ '$0': [ 1, 2 ],
        #  '$1': { a: '$0', b: '$0' },
        #  '$2': { a: '$1', b: '$1' },
        #  '$3': { a: '$2', b: '$2' },
        #  '$4': { a: '$3', b: '$3' },
        #  '$5': { a: '$4', b: '$4' },
        #  '$6': { a: '$5', b: '$5' },
        #  '$7': { a: '$6', b: '$6' },
        #  '$8': { a: '$7', b: '$7' },
        #  '$9': { a: '$8', b: '$8' },
        #  '$a': { a: '$9', b: '$9' },
        #  '$b': { a: '$a', b: '$a' },
        #  '$c': { a: '$b', b: '$b' },
        #  '$d': { a: '$c', b: '$c' },
        #  '$e': { a: '$d', b: '$d' },
        #  '$f': { a: '$e', b: '$e' },
        #  '$g': { a: '$f', b: '$f' } }
        console.log (JSON.stringify packed).length
        # 412

        unpacked = ajson.unpack packed
        console.log (JSON.stringify unpacked) is JSON.stringify big
        # true

Thus, common subtrees are extracted and reused.

Also, if you want just aliasing, you can do something like that:

        {pack, unpack, unalias} = require "./index"
        a =
            "$":
                "$a": a: "$b", b: 12
                "$b": [1,2,3]
            hey: ["$a", "$b", "$a", 12]
            ho: a: "$a", b: "$a"

        console.log JSON.stringify unalias a
        # {"hey":[{"a":[1,2,3],"b":12},[1,2,3],{"a":[1,2,3],"b":12},12],
        #  "ho":{"a":{"a":[1,2,3],"b":12},"b":{"a":[1,2,3],"b":12}}}