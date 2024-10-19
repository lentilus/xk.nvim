return require("telescope").register_extension({
	setup = function(ext_config, config) end,
	exports = {
		new_zettel = require("xettelkasten.zettel").insert,
		open_zettel = require("xettelkasten.zettel").find,
		grep = require("xettelkasten.zettel").grep,
		move_zettel = require("xettelkasten.zettel").mv,
		remove_zettel = require("xettelkasten.zettel").rm,
		publish_kasten = require("xettelkasten.git").publish,
		open_ref = require("xettelkasten.ref").find,
		journal = require("xettelkasten.journal").journal,
	},
})
