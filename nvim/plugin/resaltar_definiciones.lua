-- Resalta dónde empieza cada clase y método en Python:
--   * una línea separadora encima de cada def/class
--   * negrita en `def` y en el nombre del método
-- :ResaltarDefs activa/desactiva el resaltado.

local ns = vim.api.nvim_create_namespace("resaltar_definiciones")
local activo = true

local function color(grupo, campo)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = grupo, link = false })
	return ok and hl[campo] or nil
end

-- Mezcla dos colores: peso `t` para `a`, el resto para `b`
local function mezclar(a, b, t)
	local resultado = 0
	for _, desplazamiento in ipairs({ 16, 8, 0 }) do
		local ca = bit.band(bit.rshift(a, desplazamiento), 0xff)
		local cb = bit.band(bit.rshift(b, desplazamiento), 0xff)
		resultado = resultado * 256 + math.floor(ca * t + cb * (1 - t) + 0.5)
	end
	return resultado
end

local function definir_colores()
	-- El fondo es transparente (plugin/after/transparency.lua), así que se usa el de CursorLine
	local fondo = color("Normal", "bg") or color("CursorLine", "bg") or 0x1a1b26
	local metodo = color("@function", "fg") or color("Function", "fg") or 0x7aa2f7

	vim.api.nvim_set_hl(0, "DefSeparador", { fg = mezclar(metodo, fondo, 0.45) })

	for _, grupo in ipairs({ "@function.python", "@function.method.python", "@keyword.function.python" }) do
		local base = grupo
		local hl = {}
		while base do
			hl = vim.api.nvim_get_hl(0, { name = base, link = false })
			if next(hl) then
				break
			end
			base = base:match("^(.*)%.[^.]+$")
		end
		hl.bold = true
		vim.api.nvim_set_hl(0, grupo, hl)
	end
end

local consulta
local function resaltar(buf)
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	if not activo then
		return
	end
	local ok, parser = pcall(vim.treesitter.get_parser, buf, "python")
	if not ok or not parser then
		return
	end
	consulta = consulta
		or vim.treesitter.query.parse("python", "(function_definition) @metodo (class_definition) @clase")
	local arbol = parser:parse()[1]

	for id, nodo in consulta:iter_captures(arbol:root(), buf) do
		local es_clase = consulta.captures[id] == "clase"
		local fila, columna = nodo:start()

		-- Si tiene decoradores (@property, @override...), el separador va encima de ellos
		local fila_separador = fila
		local padre = nodo:parent()
		if padre and padre:type() == "decorated_definition" then
			fila_separador = padre:start()
		end

		if fila_separador > 0 then
			vim.api.nvim_buf_set_extmark(buf, ns, fila_separador, 0, {
				virt_lines_above = true,
				virt_lines = {
					{ { string.rep(" ", columna), "" }, { string.rep(es_clase and "━" or "─", 80 - columna), "DefSeparador" } },
				},
			})
		end
	end
end

local grupo = vim.api.nvim_create_augroup("resaltar_definiciones", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", { group = grupo, callback = definir_colores })

vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "TextChanged", "InsertLeave" }, {
	group = grupo,
	callback = function(evento)
		if vim.bo[evento.buf].filetype == "python" then
			resaltar(evento.buf)
		end
	end,
})

vim.api.nvim_create_user_command("ResaltarDefs", function()
	activo = not activo
	resaltar(vim.api.nvim_get_current_buf())
end, { desc = "Activar/desactivar el resaltado de def/class" })

definir_colores()
