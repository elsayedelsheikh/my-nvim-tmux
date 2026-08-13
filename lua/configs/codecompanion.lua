-- Local-only LLM chat over ollama. No cloud adapter is configured, so nothing
-- in this file can send buffer contents off the machine.
--
-- Note on API shape: this plugin renamed `strategies` -> `interactions` and moved
-- adapters under `adapters.http`. Older README snippets found online use the old
-- keys; a compat shim still accepts `strategies`, but prefer the names below.

local MODEL = "qwen3.6:35b-a3b"

require("codecompanion").setup({
	adapters = {
		http = {
			-- The ollama adapter discovers pulled models from /api/tags on its own
			-- and reads the host from $OLLAMA_HOST (default http://localhost:11434),
			-- so only the defaults worth pinning are overridden here.
			extend = {
				ollama = {
					schema = {
						model = { default = MODEL },
						-- ollama otherwise falls back to the modelfile's num_ctx,
						-- which is commonly 4096 and silently truncates the older
						-- turns of a chat once a large selection is in context.
						num_ctx = { default = 16384 },
					},
				},
			},
		},
	},

	interactions = {
		-- Every interaction defaults to the copilot adapter upstream; point them all
		-- at ollama so no path can reach for a cloud provider.
		chat = { adapter = "ollama" },
		inline = { adapter = "ollama" },
		cmd = { adapter = "ollama" },
		background = { adapter = "ollama" },
	},

	display = {
		chat = {
			window = {
				layout = "vertical",
				width = 0.4,
			},
		},
	},

	opts = {
		-- qwen3.6 is a reasoning model, so replies open with a thinking block.
		-- Folding it keeps the chat buffer readable.
		log_level = "ERROR",
	},
})
