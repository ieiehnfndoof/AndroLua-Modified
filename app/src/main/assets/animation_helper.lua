-- Animation Helper for AndroLua Modified
-- Easy-to-use animation functions for Lua scripts
-- Usage: local anim = require "animation_helper"

local M = {}
local AnimHelper = luajava.bindClass("com.androlua.LuaAnimationHelper")

-- GUI Animations (for Android Views)
function M.fadeIn(view, duration)
    AnimHelper.fadeIn(view, duration or 400)
end

function M.fadeOut(view, duration)
    AnimHelper.fadeOut(view, duration or 400)
end

function M.slideInLeft(view, duration)
    AnimHelper.slideInLeft(view, duration or 400)
end

function M.slideInRight(view, duration)
    AnimHelper.slideInRight(view, duration or 400)
end

function M.slideInTop(view, duration)
    AnimHelper.slideInTop(view, duration or 400)
end

function M.slideInBottom(view, duration)
    AnimHelper.slideInBottom(view, duration or 400)
end

function M.scaleIn(view, duration)
    AnimHelper.scaleIn(view, duration or 400)
end

function M.scaleOut(view, duration)
    AnimHelper.scaleOut(view, duration or 400)
end

function M.rotate(view, from, to, duration)
    AnimHelper.rotate(view, from or 0, to or 360, duration or 600)
end

function M.rotateLoop(view, duration)
    AnimHelper.rotateLoop(view, duration or 1000)
end

function M.bounce(view, duration)
    AnimHelper.bounce(view, duration or 600)
end

function M.shake(view, duration)
    AnimHelper.shake(view, duration or 500)
end

function M.pulse(view, duration)
    AnimHelper.pulse(view, duration or 800)
end

function M.flip(view, duration)
    AnimHelper.flip(view, duration or 600)
end

function M.moveTo(view, x, y, duration)
    AnimHelper.moveTo(view, x or 0, y or 0, duration or 400)
end

function M.colorChange(view, fromColor, toColor, duration)
    AnimHelper.colorChange(view, fromColor, toColor, duration or 600)
end

-- HTML Animations (for WebView)
-- Returns an HTML page with the given content and animation type
-- animType: "fadeIn", "slideUp", "pulse", "bounce", "rotate", "rainbow"
function M.htmlAnimation(content, animType, webview)
    local html = AnimHelper.getHtmlAnimationTemplate(content, animType or "fadeIn")
    if webview then
        webview.loadDataWithBaseURL(nil, html, "text/html", "UTF-8", nil)
    end
    return html
end

-- Shortcut: show animated text in a WebView
function M.animatedText(text, animType, webview)
    local content = string.format('<div class="animated" style="font-size:24px;text-align:center;padding:40px;">%s</div>', text)
    return M.htmlAnimation(content, animType, webview)
end

-- Shortcut: show animated button in a WebView  
function M.animatedButton(text, animType, webview)
    local content = string.format([[
        <div style="text-align:center;padding:40px;">
          <button class="animated" style="padding:16px 32px;font-size:20px;border:none;border-radius:8px;
          background:linear-gradient(135deg,#667eea,#764ba2);color:white;cursor:pointer;">%s</button>
        </div>]], text)
    return M.htmlAnimation(content, animType, webview)
end

return M
