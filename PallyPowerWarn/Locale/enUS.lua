
local L = LibStub("AceLocale-3.0"):NewLocale("PallyPowerWarn", "enUS", true);
if not L then return end

----------------------------------------
-- These are required for functionality
----------------------------------------

L["ZONE_WG"] = "Wintergrasp"
L["PET_FELHUNTER"] = "Felhunter"
L["PET_GHOUL"] = "Ghoul"
L["PET_IMP"] = "Imp"
L["PET_SUCCUBUS"] = "Succubus"
-- Font Face
L["FRIZQT__.TTF"] = true
L["ARIALN.TTF"] = true
L["skurri.ttf"] = true
L["MORPHEUS.ttf"] = true
-- Not really required, but if the font changed
-- the name of the font may have changed too
L["Friz Quadrata TT"] = true
L["Arial"] = true
L["Skurri"] = true
L["Morpheus"] = true

-------------------------------------------
-- These are not required for functionality
-------------------------------------------

L["Options for PallyPowerWarn"] = true

L["Show UI"] = true
L["Shows the Graphical User Interface"] = true

L["Show version"] = true

L["Blessings"] = true
L["Alerts for blessings."] = true
L["Enable checking blessings."] = true

L["Seals"] = true
L["Alerts for seals."] = true
L["Enable checking seals."] = true

L["Righteous Fury"] = true
L["Alerts for Righteous Fury."] = true
L["Enable checking Righteous Fury."] = true

L["Auras"] = true
L["Alerts for auras."] = true
L["Enable checking auras."] = true

L["When to check"] = true
L["Disable checks"] = true
L["Other Options"] = true

L["Enable"] = true
L["Ready Check"] = true
L["Notify on ready check."] = true
L["Enter Combat"] = true
L["Notify when entering combat."] = true
L["After Combat"] = true
L["Notify after the end of combat."] = true
L["No Mounted"] = true
L["Disable notifications when mounted."] = true
L["No Vehicle"] = true
L["Disable notifications when in a vehicle."] = true
L["No Combat"] = true
L["Disable notifications when in combat."] = true
L["No PvP"] = true
L["Disable notifications when PvP flagged."] = true
L["Sound"] = true
L["Play a sound when a buff is missing."] = true
L["Ding"] = true
L["Dong"] = true
L["None"] = true
L["Frequency"] = true
L["Do not warn more often than (5=default)"] = true

L["Location"] = true
L["Battleground"] = true
L["Warn when in battlegrounds."] = true
L["Arena"] = true
L["Warn when in arena."] = true
L["Warn when in Wintergrasp."] = true
L["5-man"] = true
L["Warn when in a 5-man instance."] = true
L["Raid"] = true
L["Warn when in a raid instance."] = true
L["Other"] = true
L["Warn when not in an instance, arena, or battleground."] = true

L["Wrong Buffs"] = true
L["Warn for wrong buffs."] = true
L["Displays a warning if your blessings do not match PallyPower."] = true

L["Wrong Seal"] = true
L["Warn for wrong seal."] = true
L["Displays a warning if your seal does not match PallyPower."] = true

L["Wrong Aura"] = true
L["Warn for wrong aura."] = true
L["Warn for Crusader only"] = true
L["Non-PallyPower Aura"] = true
L["Any aura is fine"] = true
L["Help"] = [[Options:

Any aura is fine - No warnings for wrong aura.

Warn for Crusader only - Will warn if you have crusader and PallyPower is not set to Crusader.

Non-PallyPower Aura - Will warn if your aura is different than PallyPower.]]

L["Display"] = true
L["Settings for how to display the message."] = true

L["Color"] = true
L["Sets the color of the text when displaying messages."] = true
L["Scroll output"] = true
L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"] = true
L["Frames output"] = true
L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"] = true
L["Time to display message"] = true
L["Set the time the message will be displayed (5=default)"] = true

L["General Display"] = true
L["General Display settings and options for the Custom Message Frame."] = true
L["Chat Window Options"] = true
L["Chat Message"] = true
L["Display message in Chat Frame."] = true
L["Chat number"] = true
L["Choose which chat to display the messages in (0=default)."] = true
L["Error Frame"] = true
L["Display message in Blizzard UI Error Frame."] = true
L["Message Frame"] = true
L["Display message in Custom Message Frame."] = true
L["Lock"] = true
L["Toggle locking of the Custom Message Frame."] = true
L["Font Size"] = true
L["Set the font size in the Custom Message Frame."] = true
L["Font Face"] = true
L["Set the font face in the Custom Message Frame."] = true
L["Font Effect"] = true
L["Set the font effect in the Custom Message Frame."] = true
L["OUTLINE"] = true
L["THICKOUTLINE"] = true
L["MONOCHROME"] = true

L[" faded from "] = true
L["Missing Buffs"] = true
L["Missing Seal"] = true
L["Missing Righteous Fury"] = true
L["Righteous Fury is on"] = true
L["Missing Aura"] = true
L["Unknown"] = true

L["Players missing buffs: "] = true
L["Players with wrong buffs: "] = true

L[" Loaded. Use /ppw for options."] = true
L["Unable to determine class_id for "] = true
L["Version "] = "Version "
L["\n\nThis addon provides warnings for Blessings, Seals, Righteous Fury, and Auras."] = "\n\nThis addon provides warnings for Blessings, Seals, Righteous Fury, and Auras."
