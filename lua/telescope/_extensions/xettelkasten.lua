return require("telescope").register_extension({
	setup = function(ext_config, config) end,
	exports = {
		open_zettel = require("xettelkasten.zettel").find,
		open_ref = require("xettelkasten.ref").find,
	},
})
