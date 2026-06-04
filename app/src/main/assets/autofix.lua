-- AutoFix Errors Module for AndroLua Modified
-- Automatically detects and fixes common Lua syntax errors

local M = {}

-- Common fix patterns: {pattern, fix description, fix function}
local fixes = {
    -- Missing 'end' for if/while/for/function
    {
        check = function(src, err)
            return err and err:find("'<eof>'") and (src:find("%bif%b") or src:find("%bfor%b") or src:find("%bwhile%b") or src:find("%bfunction%b"))
        end,
        desc = "Missing 'end' — added at end of file",
        fix = function(src) return src .. "\nend" end
    },
    -- Missing 'then' after if condition
    {
        check = function(src, err)
            return err and err:find("'then'")
        end,
        desc = "Missing 'then' after if condition",
        fix = function(src, line)
            local lines = {}
            local n = 0
            for l in src:gmatch("[^\n]*") do
                n = n + 1
                if n == line and l:find("^%s*if ") and not l:find(" then") then
                    l = l .. " then"
                end
                table.insert(lines, l)
            end
            return table.concat(lines, "\n")
        end
    },
    -- Missing 'do' in for/while
    {
        check = function(src, err)
            return err and err:find("'do'")
        end,
        desc = "Missing 'do' — added after loop",
        fix = function(src, line)
            local lines = {}
            local n = 0
            for l in src:gmatch("[^\n]*") do
                n = n + 1
                if n == line and not l:find(" do") and (l:find("^%s*for ") or l:find("^%s*while ")) then
                    l = l .. " do"
                end
                table.insert(lines, l)
            end
            return table.concat(lines, "\n")
        end
    },
    -- Unmatched parentheses
    {
        check = function(src, err)
            return err and err:find("')'") 
        end,
        desc = "Missing closing parenthesis ')'",
        fix = function(src, line)
            local lines = {}
            local n = 0
            for l in src:gmatch("[^\n]*") do
                n = n + 1
                if n == line then
                    local opens = select(2, l:gsub("%(", ""))
                    local closes = select(2, l:gsub("%)", ""))
                    if opens > closes then
                        l = l .. string.rep(")", opens - closes)
                    end
                end
                table.insert(lines, l)
            end
            return table.concat(lines, "\n")
        end
    },
    -- String not closed
    {
        check = function(src, err)
            return err and (err:find("unfinished string") or err:find("unfinished long"))
        end,
        desc = "Unclosed string — added closing quote",
        fix = function(src, line)
            local lines = {}
            local n = 0
            for l in src:gmatch("[^\n]*") do
                n = n + 1
                if n == line then
                    -- Count quotes
                    local dq = select(2, l:gsub('"', ''))
                    local sq = select(2, l:gsub("'", ""))
                    if dq % 2 ~= 0 then l = l .. '"' end
                    if sq % 2 ~= 0 then l = l .. "'" end
                end
                table.insert(lines, l)
            end
            return table.concat(lines, "\n")
        end
    },
}

function M.tryFix(src)
    -- First check for errors
    local ok, err = pcall(loadstring, src)
    if ok then
        return src, "No errors found!", false
    end

    -- Parse error line
    local line = 1
    if err then
        local ln = err:match(":(%d+):")
        if ln then line = tonumber(ln) end
    end

    -- Try each fix
    for _, fix in ipairs(fixes) do
        if fix.check(src, err) then
            local fixed = fix.fix(src, line)
            -- Verify fix worked
            local ok2, err2 = pcall(loadstring, fixed)
            if ok2 or (err2 and err2 ~= err) then
                return fixed, "Fixed: " .. fix.desc, true
            end
        end
    end

    -- Generic: try adding 'end' statements
    local fixed = src
    local tries = 0
    while tries < 5 do
        local ok2, err2 = pcall(loadstring, fixed)
        if ok2 then
            return fixed, "Fixed by adding " .. tries .. " 'end' statement(s)", true
        end
        if err2 and err2:find("'<eof>'") then
            fixed = fixed .. "\nend"
            tries = tries + 1
        else
            break
        end
    end

    -- Could not auto-fix
    return src, "Could not auto-fix: " .. (err or "unknown error"), false
end

function M.showAutoFixDialog(activity, editor)
    local src = editor.getText().toString()
    local fixed, msg, success = M.tryFix(src)

    if success then
        local dlg = AlertDialogBuilder(activity)
        dlg.setTitle("Auto Fix")
        dlg.setMessage("Fix found!\n\n" .. msg .. "\n\nApply fix?")
        dlg.setPositiveButton("Apply Fix", {
            onClick = function()
                editor.setText(fixed)
                Toast.makeText(activity, "Fix applied!", Toast.LENGTH_SHORT).show()
            end
        })
        dlg.setNegativeButton("Cancel", nil)
        dlg.show()
    else
        Toast.makeText(activity, msg, Toast.LENGTH_LONG).show()
    end
end

return M
