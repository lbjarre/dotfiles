-- statusline.lua
-- Custom statusline

-- Helper func for creating a highlight group
local function hlgroup(name, fg, bg)
    vim.cmd("highlight " .. name .. " ctermfg=" .. fg .. " ctermbg=" .. bg)
end

hlgroup("StatusModeNormal", 0, 7)
hlgroup("StatusModeInsert", 0, 4)
hlgroup("StatusModeVisual", 0, 11)
hlgroup("StatusModeReplace", 0, 1)
hlgroup("StatusMain", 0, 15)
hlgroup("StatusLeft", 0, 7)

-- Mapping between output from `mode`-call and printable name in the statusline
local modes_printname = {
    -- normal modes
    n       = { name = "normal",             hl = "%#StatusModeNormal#" },
    no      = { name = "n·operator pending", hl = "%#StatusModeNormal#" },
    -- visual modes
    v       = { name = "visual",  hl = "%#StatusModeVisual#" },
    V       = { name = "v·line",  hl = "%#StatusModeVisual#" },
    [""]  = { name = "v·block", hl = "%#StatusModeVisual#" },
    -- insert
    i       = { name = "insert", hl = "%#StatusModeInsert#" },
    -- replace
    R       = { name = "replace",   hl = "%#StatusModeReplace#" },
    Rv      = { name = "v·replace", hl = "%#StatusModeReplace#" },
    -- select modes
    s       = { name = "select" },
    S       = { name = "s·line" },
    [""]  = { name = "s·block" },
    -- other modes -- don't really know too much about these other ones
    c       = { name = "command" },
    cv      = { name = "vim ex" },
    ce      = { name = "ex" },
    r       = { name = "prompt" },
    rm      = { name = "more" },
    ['r?']  = { name = "confirm" },
    ['!']   = { name = "shell" },
    t       = { name = "terminal" },
}

-- Get statusline info for the current mode,
-- including name and highlight group
local function mode()
    -- get mode name from vim and lookup info from above table
    local m = vim.api.nvim_get_mode().mode
    local mode_info = modes_printname[m]

    -- Completely unknown mode from the above table:
    -- -> just normal hl and name as received
    if mode_info == nil then
        return "%#StatusModeNormal# " .. m .. " "
    end

    -- Known name but no given hl group:
    -- -> known name with normal hl group
    if mode_info.hl == nil then
        return "%#StatusModeNormal# " .. mode_info.name .. " "
    end

    -- Known name and given hl group:
    -- -> just use it!
    return mode_info.hl .. " " .. mode_info.name .. " "
end

-- Get statusline info about LSP clients
local function lsp()
    local clients = vim.lsp.get_active_clients()

    -- cases without any lsp clients active
    if clients == nil or #clients == 0 then
        return ""
    end

    -- if we only have one client, print out the name
    if #clients == 1 then
        return clients[1].name
    end

    -- if we have more than one, just print the number of active clients
    return #clients
end

-- Render statusline
function statusline()
    return table.concat {
        -- Right block:
        -- mode
        mode(),
        "%#StatusMain#",
        -- Filename
        " %f",
        -- Left-right sep
        "%=",
        -- Left block:
        "%#StatusLeft# ",
        -- LSP status
        lsp(),
        -- line & col
        " %l,%c",
        -- percentage through file
        " %p%% ",
        -- filetype
        vim.bo.filetype,
        " ",
    }
end

vim.o.statusline = "%!luaeval('statusline()')"

