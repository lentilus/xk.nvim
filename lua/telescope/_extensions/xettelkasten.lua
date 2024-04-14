return require("telescope").register_extension {
  setup = function(ext_config, config) end,
  exports = {
    zettel_find = require("xettelkasten.zettel").find,
    ref_rm = require("xettelkasten.ref").rm,
    ref_find = require("xettelkasten.ref").find,
    ref_insert = require("xettelkasten.ref").insert,
    tag_rm = require("xettelkasten.tag").rm,
  },
}
