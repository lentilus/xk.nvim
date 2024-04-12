
return require("telescope").register_extension {
  setup = function(ext_config, config) end,
  exports = {
    ref_rm = require("xettelkasten").ref_rm,
    ref_find = require("xettelkasten").ref_find,
    ref_insert = require("xettelkasten").ref_insert,
    zettel_find = require("xettelkasten").zettel_find,
  },
}
