-- ============================================================
-- AndroLua Modified - Complete Command Guide
-- Long-press any code block to copy it!
-- ============================================================

local Guide = {}
Guide.__index = Guide

function Guide.new(activity)
  local self = setmetatable({}, Guide)
  self.activity = activity
  return self
end

-- Show full guide in a scrollable dialog
function Guide:show()
  require "import"
  import "android.app.AlertDialog"
  import "android.widget.ScrollView"
  import "android.widget.LinearLayout"
  import "android.widget.TextView"
  import "android.widget.Button"
  import "android.graphics.Color"
  import "android.text.ClipboardManager"

  local sections = self:getSections()
  local sv = ScrollView(self.activity)
  local ll = LinearLayout(self.activity)
  ll.Orientation = 1
  ll.setPadding(20,20,20,20)
  sv.addView(ll)

  local function addTitle(txt)
    local tv = TextView(self.activity)
    tv.Text = txt
    tv.TextSize = 17
    tv.setTextColor(0xFF2196F3)
    tv.setPadding(0,24,0,8)
    ll.addView(tv)
  end

  local function addCode(code, desc)
    local row = LinearLayout(self.activity)
    row.Orientation = 1
    row.setPadding(12,12,12,12)
    row.setBackgroundColor(0xFF1E1E1E)

    local dv = TextView(self.activity)
    dv.Text = "-- " .. desc
    dv.TextSize = 12
    dv.setTextColor(0xFF888888)
    row.addView(dv)

    local cv = TextView(self.activity)
    cv.Text = code
    cv.TextSize = 13
    cv.setTextColor(0xFF00FF88)
    row.addView(cv)

    -- Long press to copy
    row.setOnLongClickListener(function()
      local clip = self.activity.getSystemService("clipboard")
      clip.setText(code)
      import "android.widget.Toast"
      Toast.makeText(self.activity, "Copied!", Toast.LENGTH_SHORT).show()
      return true
    end)

    local margin = LinearLayout.LayoutParams(-1,-2)
    margin.setMargins(0,6,0,6)
    ll.addView(row, margin)
  end

  for _, section in ipairs(sections) do
    addTitle(section.title)
    for _, item in ipairs(section.items) do
      addCode(item.cmd, item.desc)
    end
  end

  AlertDialog.Builder(self.activity)
    .setTitle("AndroLua Command Guide")
    .setView(sv)
    .setPositiveButton("Close", nil)
    .show()
end

function Guide:getSections()
  return {
    {
      title = "NEW: GUI Animations",
      items = {
        {cmd='local anim = require "animation_helper"', desc="Load animation module (do this first)"},
        {cmd='anim.fadeIn(myView, 500)',           desc="Fade in (500ms)"},
        {cmd='anim.fadeOut(myView, 500)',          desc="Fade out"},
        {cmd='anim.slideInLeft(myView, 400)',      desc="Slide in from left"},
        {cmd='anim.slideInRight(myView, 400)',     desc="Slide in from right"},
        {cmd='anim.slideInTop(myView, 400)',       desc="Slide in from top"},
        {cmd='anim.slideInBottom(myView, 400)',    desc="Slide in from bottom"},
        {cmd='anim.scaleIn(myView, 400)',          desc="Scale in (springy)"},
        {cmd='anim.scaleOut(myView, 400)',         desc="Scale out and hide"},
        {cmd='anim.bounce(myView, 600)',           desc="Bounce up and down"},
        {cmd='anim.shake(myView, 500)',            desc="Shake left and right"},
        {cmd='anim.pulse(myView, 800)',            desc="Pulse/throb forever"},
        {cmd='anim.rotate(myView, 0, 360, 600)',  desc="Rotate from 0 to 360 degrees"},
        {cmd='anim.rotateLoop(myView, 1000)',      desc="Spin forever"},
        {cmd='anim.flip(myView, 600)',             desc="3D flip on Y axis"},
        {cmd='anim.moveTo(myView, 100, 200, 400)',desc="Move to position x=100 y=200"},
        {cmd='anim.colorChange(v,0xFFFF0000,0xFF0000FF,600)', desc="Animate background color"},
      }
    },
    {
      title = "NEW: HTML Animations (WebView)",
      items = {
        {cmd='local anim = require "animation_helper"', desc="Load module first"},
        {cmd='anim.animatedText("Hello!", "fadeIn",   wv)', desc="Animated text - fade in"},
        {cmd='anim.animatedText("Hello!", "slideUp",  wv)', desc="Animated text - slide up"},
        {cmd='anim.animatedText("Hello!", "bounce",   wv)', desc="Animated text - bounce"},
        {cmd='anim.animatedText("Hello!", "pulse",    wv)', desc="Animated text - pulse"},
        {cmd='anim.animatedText("Hello!", "rotate",   wv)', desc="Animated text - rotate"},
        {cmd='anim.animatedText("Hello!", "rainbow",  wv)', desc="Animated text - rainbow colors"},
        {cmd='anim.animatedButton("Click Me","fadeIn",wv)', desc="Animated button in WebView"},
      }
    },
    {
      title = "NEW: Auto Fix Errors",
      items = {
        {cmd='-- Go to: Menu > Code > Auto Fix Errors',  desc="Use from menu (easiest)"},
        {cmd='local af = require "autofix"\naf.showAutoFixDialog(activity, editor)', desc="Call from code"},
        {cmd='local af = require "autofix"\nlocal fixed,msg,ok = af.tryFix(sourceCode)', desc="Fix code, get result"},
      }
    },
    {
      title = "Android UI Widgets",
      items = {
        {cmd='local btn = Button(activity)\nbtn.Text = "Click"\nbtn.onClick = function() end', desc="Button"},
        {cmd='local tv = TextView(activity)\ntv.Text = "Hello"\ntv.TextSize = 20', desc="Text label"},
        {cmd='local et = EditText(activity)\net.Hint = "Type here..."', desc="Text input"},
        {cmd='local iv = ImageView(activity)', desc="Image view"},
        {cmd='local ll = LinearLayout(activity)\nll.Orientation = 1', desc="Vertical layout"},
        {cmd='local rl = RelativeLayout(activity)', desc="Relative layout"},
        {cmd='local wv = WebView(activity)', desc="Web view"},
        {cmd='activity.setContentView(layout.main)', desc="Set main layout"},
        {cmd='Toast.makeText(activity,"Hi!",0).show()', desc="Show toast message"},
      }
    },
    {
      title = "Java / Android API",
      items = {
        {cmd='import "android.content.Intent"\nlocal i = Intent()\ni.setAction(Intent.ACTION_VIEW)', desc="Create Intent"},
        {cmd='import "android.net.Uri"\nactivity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("http://google.com")))', desc="Open URL"},
        {cmd='import "android.graphics.Color"\nview.setBackgroundColor(Color.RED)', desc="Set color"},
        {cmd='import "android.os.Vibrator"\nactivity.getSystemService("vibrator").vibrate(500)', desc="Vibrate 500ms"},
        {cmd='import "android.media.MediaPlayer"\nlocal mp = MediaPlayer()\nmp.setDataSource("/sdcard/music.mp3")\nmp.prepare()\nmp.start()', desc="Play audio"},
        {cmd='activity.finish()', desc="Close/exit app"},
        {cmd='activity.setTitle("My App")', desc="Set title bar text"},
      }
    },
    {
      title = "File I/O",
      items = {
        {cmd='local f=io.open("/sdcard/test.txt","w")\nf:write("Hello")\nf:close()', desc="Write file"},
        {cmd='local f=io.open("/sdcard/test.txt","r")\nprint(f:read("*a"))\nf:close()', desc="Read file"},
        {cmd='os.remove("/sdcard/test.txt")', desc="Delete file"},
        {cmd='os.rename("old.txt","new.txt")', desc="Rename file"},
        {cmd='print(activity.LuaExtDir)', desc="Get app data directory"},
      }
    },
    {
      title = "Lua Basics",
      items = {
        {cmd='print("Hello World")', desc="Print to console"},
        {cmd='local x = 42\nlocal s = "text"\nlocal b = true', desc="Variables"},
        {cmd='if x > 10 then\n  print("big")\nelseif x > 5 then\n  print("medium")\nelse\n  print("small")\nend', desc="If / elseif / else"},
        {cmd='for i = 1, 10 do\n  print(i)\nend', desc="Numeric for loop"},
        {cmd='local t = {"a","b","c"}\nfor i,v in ipairs(t) do\n  print(i,v)\nend', desc="Table loop"},
        {cmd='while x > 0 do\n  x = x - 1\nend', desc="While loop"},
        {cmd='function add(a, b)\n  return a + b\nend\nprint(add(3, 4))', desc="Function"},
        {cmd='local ok, err = pcall(function()\n  error("oops")\nend)\nprint(ok, err)', desc="Error handling"},
      }
    },
    {
      title = "WebView & HTML",
      items = {
        {cmd='local wv = WebView(activity)\nwv.loadUrl("https://google.com")', desc="Load URL"},
        {cmd='wv.getSettings().setJavaScriptEnabled(true)', desc="Enable JavaScript"},
        {cmd='wv.loadData("<h1>Hi</h1>","text/html","UTF-8")', desc="Load HTML string"},
        {cmd='wv.loadUrl("javascript:alert(\'Hello from Lua!\')")', desc="Run JavaScript"},
      }
    },
  }
end

return Guide
