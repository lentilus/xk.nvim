
return require("telescope").register_extension {
  setup = function(ext_config, config) end,
  exports = {
    zettel = require("xettelkasten").zettel,
    ref = require("xettelkasten").ref,
  },
}
