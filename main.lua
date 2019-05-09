fennel = require("lib.fennel")
table.insert(package.loaders, fennel.make_searcher({correlate=true}))
pp = function(x) print(require("lib.fennelview")(x)) end

require("game")
