local addonName, lfg = ...

lfg.defaults = {

  enabled = false,
  autoInvite = false,
  autoWhisper = false,
  linkColor = "cffff00ff",
  whisperText = "I'm Down!",

  channel = {
    [1] = true,
    [2] = true,
    [3] = false,
    [4] = true,
    [5] = false,
    [6] = false
  },

  channelNames = {
    "1. General",
    "2. Trade",
    "3. Local Defense",
    "4. Looking For Group",
    "5. World Defense",
    "6. Guild Recruitment"
  },

  criteria = {
    ["1"] = {
      "LF",
      "lf"
    },

    ["2"] = {
      "HEAL",
      "heal",
      "Heal",
      "TANK",
      "tank",
      "Tank",
      "DPS",
      "dps",
    },

    ["3"] = {
      "RFC",
      "rfc",
      "rfk",
      "RFK",
      "SFK",
      "sfk",
      "WC",
      "wc",
    }

  }

}
LFGSettings = LFGSettings or lfg.defaults

function lfg.toggle()
  if LFGSettings.enabled then
    print(addonName .. " Disabled")
    LFGSettings.enabled = false
  else
    print(addonName .. " Enabled")
    LFGSettings.enabled = true
  end
end


function lfg.handleChatEvent(...)
  if not LFGSettings.enabled  then return value  end
  local msg, fromPlayer, _, eventChannel = ...

  for channelNumber,listening in ipairs(LFGSettings.channel) do
    if eventChannel:find(channelNumber) and listening then
      lfg.parseMSG(msg, fromPlayer, channelNumber)
    end
  end

end

-- Parse the message to see if it meets our search criteria
function lfg.parseMSG(msg, fromPlayer, channelNumber)
 
  local matches = {}
  local playerLink = "|"..LFGSettings.linkColor.."|Hplayer:"..fromPlayer.."|h["..fromPlayer.."]|h|r";
  local minCriteria = 0

  for _,searchCrit in pairs(LFGSettings.criteria) do
    if table.getn(searchCrit) > 0 then minCriteria = minCriteria + 1 end
    for _,crit in pairs(searchCrit) do
      if msg:find(crit) then
        table.insert(matches, crit)
        break
      end
    end
  end

  if table.getn(matches) >= minCriteria then
    PlaySound(SOUNDKIT.READY_CHECK)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("["..channelNumber.."] "..playerLink.." "..msg)
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    if LFGSettings.autoWhisper then
      SendChatMessage(LFGSettings.whisperText, "WHISPER", nil, fromPlayer:Split("-")[1])
    end

  end
  
end

function string:Split(sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(self, "([^"..sep.."]+)") do
      table.insert(str)
  end
  return t
end


