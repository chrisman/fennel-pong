require("love.event")
local fennel = require("lib.fennel")
local view = require("lib.fennelview")
local event, channel = ...
local function display(s)
  io.write(s)
  return io.flush()
end
do local _ = display end
local function prompt()
  return display("\n>> ")
end
do local _ = prompt end
local function read_chunk()
  local input = io.read()
  if input then
    return (input .. "\n")
  end
end
do local _ = read_chunk end
local input = ""
local function _0_(...)
  if channel then
    local bytestream, clearstream = fennel.granulate(read_chunk)
    local function _0_()
      local c = (bytestream() or 10)
      input = (input .. string.char(c))
      return c
    end
    local read = fennel.parser(_0_)
    while true do
      prompt()
      input = ""
      do
        local ok, ast = pcall(read)
        local function _1_(...)
          if not ok then
            return display(("Parse error:" .. ast .. "\n"))
          else
            love.event.push(event, input)
            return display(channel:demand())
          end
        end
        _1_(...)
      end
    end
    return nil
  end
end
_0_(...)
local function start_repl()
  local code = love.filesystem.read("stdio.fnl")
  local function _1_()
    if code then
      return love.filesystem.newFileData(fennel.compileString(code), "io")
    else
      return love.filesystem.read("lib/stdio.lua")
    end
  end
  local lua = _1_()
  local thread = love.thread.newThread(lua)
  local io_channel = love.thread.newChannel()
  thread:start("eval", io_channel)
  local function _2_(input)
    local ok, val = pcall(fennel.eval, input)
    local function _3_()
      if ok then
        return view(val)
      else
        return val
      end
    end
    return io_channel:push(_3_())
  end
  love.handlers.eval = _2_
  return nil
end
return {start = start_repl}
