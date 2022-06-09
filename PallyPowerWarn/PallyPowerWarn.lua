--[[
$Id: PallyPowerWarn.lua 25 2010-09-09 21:39:25Z stassart $

Author: Trelis @ Proudmoore
(pally (a) stassart o org)

Copyright 2010 Benjamin Stassart

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

]]

-- Disable PallyPowerWarn if the player is not a paladin
if select(2, UnitClass('player')) ~= "PALADIN" then
	DisableAddOn("PallyPowerWarn")
	return
end

local L = LibStub("AceLocale-3.0"):GetLocale("PallyPowerWarn")
local AceAddon = LibStub("AceAddon-3.0")

-- Functions marked with "*" are used by PallyPowerWarn
-- AceConsole: Print*, Printf, RegisterChatCommand, UnregisterChatCommand,
--		GetArgs
-- AceEvent: RegisterEvent*, UnregisterEvent, UnregisterAllEvents*
-- AceTimer: ScheduleTimer*, ScheduleRepeatingTimer, CancelTimer, CancelAllTimers, TimeLeft
-- LibSink: Pour*, RegisterSink*, SetSinkStorage, GetSinkAce2OptionsDataTable,
--		GetSinkAce3OptionsDataTable
PallyPowerWarn = AceAddon:NewAddon("PallyPowerWarn",
				"AceConsole-3.0",
				"AceEvent-3.0",
				"AceTimer-3.0",
				"LibSink-2.0")

local meta_version = GetAddOnMetadata("PallyPowerWarn","Version")
-- This doesn't get updated if this file isn't updated
-- local revision = ("$Revision: 25 $"):sub(12, -3)
PallyPowerWarn.DisplayVersion = ("v%s"):format(meta_version)

-- Add configmode support (i.e. OneButtonConfig)
-- Create the global table if it does not exist yet
CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
-- Declare our handler
CONFIGMODE_CALLBACKS["PallyPowerWarn"] = function(action)
	if action == "ON" then
		PallyPowerWarn.configMode = true
		PallyPowerWarn:UpdateLock()
	elseif action == "OFF" then
		PallyPowerWarn.configMode = false
		PallyPowerWarn:UpdateLock()
	end
end

-- Default Options for PallyPowerWarn
PallyPowerWarn.defaults = {
   profile = {
	display = {
		chat = true,
		number = 0,
		error = false,
		frame = true,
		fontSize = 18,
		fontFace = L["FRIZQT__.TTF"],
		fontEffect = L["OUTLINE"],
		lock = true,
	},
	blessing = {
		enable = true,
		readycheck = true,
		entercombat = false,
		aftercombat = true,
		mounted = true,
		vehicle = true,
		combat = false,
		pvp = false,
		bg = false,
		arena = true,
		wg = false,
		instance = true,
		raid = true,
		world = true,
		wrong = true,
		frequency = 5,
		sound = "ding",
		display = {
			color = { r=1, g=1, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	seal = {
		enable = true,
		readycheck = true,
		entercombat = true,
		aftercombat = true,
		mounted = true,
		vehicle = true,
		combat = false,
		wrong = false,
		frequency = 5,
		sound = "dong",
		display = {
			color = { r=0.7, g=0.7, b=1 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	rf = {
		enable = false,
		readycheck = true,
		entercombat = true,
		aftercombat = true,
		mounted = true,
		vehicle = true,
		frequency = 5,
		sound = "dong",
		display = {
			color = { r=0.7, g=0.5, b=0 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
	aura = {
		enable = true,
		readycheck = true,
		entercombat = true,
		aftercombat = true,
		mounted = true,
		vehicle = true,
		wrong = "crusader",
		frequency = 5,
		sound = "dong",
		display = {
			color = { r=0.7, g=1, b=0.7 },
			scroll = false,
			frames = true,
			time = 5,
		},
	},
   }
}

-- Sounds for alerts
local sounds = {
	ding = "Sound\\Doodad\\BellTollAlliance.wav",
	dong = "Sound\\Doodad\\BellTollHorde.wav",
}

-- COMBAT_LOG_EVENT events that are tracked
local trackedEvents = {}

-- All Blessing Spell IDs
local blessing_ids = {
	[20217] = true, -- "Blessing of Kings",
	[25898] = true, -- "Greater Blessing of Kings",
	[19740] = true, -- "Blessing of Might",
	[19834] = true, -- "Blessing of Might",
	[19835] = true, -- "Blessing of Might",
	[19836] = true, -- "Blessing of Might",
	[19837] = true, -- "Blessing of Might",
	[19838] = true, -- "Blessing of Might",
	[25291] = true, -- "Blessing of Might",
	[27140] = true, -- "Blessing of Might",
	[48931] = true, -- "Blessing of Might",
	[48932] = true, -- "Blessing of Might",
	[25782] = true, -- "Greater Blessing of Might",
	[25916] = true, -- "Greater Blessing of Might",
	[27141] = true, -- "Greater Blessing of Might",
	[48933] = true, -- "Greater Blessing of Might",
	[48934] = true, -- "Greater Blessing of Might",
	[20911] = true, -- "Blessing of Sanctuary",
	[26899] = true, -- "Greater Blessing of Sanctuary",
	[19742] = true, -- "Blessing of Wisdom",
	[19850] = true, -- "Blessing of Wisdom",
	[19852] = true, -- "Blessing of Wisdom",
	[19853] = true, -- "Blessing of Wisdom",
	[19854] = true, -- "Blessing of Wisdom",
	[25290] = true, -- "Blessing of Wisdom",
	[27142] = true, -- "Blessing of Wisdom",
	[48935] = true, -- "Blessing of Wisdom",
	[48936] = true, -- "Blessing of Wisdom",
	[25894] = true, -- "Greater Blessing of Wisdom",
	[25918] = true, -- "Greater Blessing of Wisdom",
	[27143] = true, -- "Greater Blessing of Wisdom",
	[48937] = true, -- "Greater Blessing of Wisdom",
	[48938] = true, -- "Greater Blessing of Wisdom",
}

-- All Seal Spell IDs
local seal_ids = {
	[20164] = true, -- "Seal of Justice",
	[20165] = true, -- "Seal of Light",
	[20166] = true, -- "Seal of Wisdom",
	[21084] = true, -- "Seal of Righteousness",
	-- [53720] = true, -- "Seal of the Martyr",
	[31801] = true, -- "Seal of Vengeance",
	[20375] = true, -- "Seal of Command",
	[53736] = true, -- "Seal of Corruption",
	-- [31892] = true, -- "Seal of Blood",
}

-- All Aura Spell IDs
local aura_ids = {
	[465] = true, -- "Devotion Aura",
	[10290] = true, -- "Devotion Aura",
	[643] = true, -- "Devotion Aura",
	[10291] = true, -- "Devotion Aura",
	[1032] = true, -- "Devotion Aura",
	[10292] = true, -- "Devotion Aura",
	[10293] = true, -- "Devotion Aura",
	[27149] = true, -- "Devotion Aura",
	[48941] = true, -- "Devotion Aura",
	[48942] = true, -- "Devotion Aura",
	[7294] = true, -- "Retribution Aura",
	[10298] = true, -- "Retribution Aura",
	[10299] = true, -- "Retribution Aura",
	[10300] = true, -- "Retribution Aura",
	[10301] = true, -- "Retribution Aura",
	[27150] = true, -- "Retribution Aura",
	[54043] = true, -- "Retribution Aura",
	[19746] = true, -- "Concentration Aura",
	[19876] = true, -- "Shadow Resistance Aura",
	[19895] = true, -- "Shadow Resistance Aura",
	[19896] = true, -- "Shadow Resistance Aura",
	[27151] = true, -- "Shadow Resistance Aura",
	[48943] = true, -- "Shadow Resistance Aura",
	[19888] = true, -- "Frost Resistance Aura",
	[19897] = true, -- "Frost Resistance Aura",
	[19898] = true, -- "Frost Resistance Aura",
	[27152] = true, -- "Frost Resistance Aura",
	[48945] = true, -- "Frost Resistance Aura",
	[19891] = true, -- "Fire Resistance Aura",
	[19899] = true, -- "Fire Resistance Aura",
	[19900] = true, -- "Fire Resistance Aura",
	[27153] = true, -- "Fire Resistance Aura",
	[48947] = true, -- "Fire Resistance Aura",
	[32223] = true, -- "Crusader Aura",
}

-- Track the last alert of a given type
local AlertTimes = {}

-- Players that have had buffs fade
local BuffFades = {}

-- Crusader Aura
local CrusaderSpell = GetSpellInfo(32223)

-- Imp Phase Shift
-- local PhaseShiftSpell = GetSpellInfo(4511)

-- OnInitialize is called when the addon is loaded
function PallyPowerWarn:OnInitialize()
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	-- Attach to configuration settings
	self.db = LibStub("AceDB-3.0"):New("PallyPowerWarnDB",
			PallyPowerWarn.defaults, "profile")
	-- Load options
	LibStub("AceConfig-3.0"):RegisterOptionsTable("PallyPowerWarn",
		PallyPowerWarn.options, {"ppwarn", "ppw"} )

	-- Add options to Blizzard's Addon Interface
	self.optionsFrame = AceConfigDialog:AddToBlizOptions("PallyPowerWarn",
		"PallyPowerWarn")

	-- Configure what the default options are
	self.db:RegisterDefaults(self.defaults)

	-- Display version number when loading

	self:Print(self.DisplayVersion..L[" Loaded. Use /ppw for options."])

	-- ConfigMode (OneButtonConfig) off by default
	self.configMode = false

	-- self:GetLocaleSpells()

	-- Register Scrolling Combat Text
	self:RegisterSink("PPW", "PallyPowerWarn", nil, "SinkPrint")
end

-- Called when the user enables the addon
function PallyPowerWarn:OnEnable()
	self:LoadEvents()
	-- self:PrintAssignments()
end

-- Called when the user disables the addon
function PallyPowerWarn:OnDisable()
	self:UnregisterAllEvents()
end

-- function PallyPowerWarn:GetLocaleSpells()
	-- lN["Earth Shield"] = GetSpellInfo(name_ids["Earth Shield"])
-- end

-- Events handled by PallyPowerWarn
function PallyPowerWarn:LoadEvents()
	-- Disable all previous events from this addon
	self:UnregisterAllEvents()
	
	trackedEvents = {}

	-- Always monitor the coombatlog
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	-- Detect fading buffs
	trackedEvents["SPELL_AURA_REMOVED"] = true

	-- Detect talent spec change
	-- self:RegisterEvent("LEARNED_SPELL_IN_TAB")
	-- self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

	-- Ready Check
	if (self.db.profile.blessing.enable and self.db.profile.blessing.readycheck) or
	   (self.db.profile.seal.enable and self.db.profile.seal.readycheck) or
	   (self.db.profile.rf.enable and self.db.profile.rf.readycheck) or
	   (self.db.profile.aura.enable and self.db.profile.aura.readycheck) then
		self:RegisterEvent("READY_CHECK")
	end
	
	-- Enter combat
	if (self.db.profile.blessing.enable and self.db.profile.blessing.entercombat) or
	   (self.db.profile.seal.enable and self.db.profile.seal.entercombat) or
	   (self.db.profile.rf.enable and self.db.profile.rf.entercombat) or
	   (self.db.profile.aura.enable and self.db.profile.aura.entercombat) then
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
	end

	-- After combat
	if (self.db.profile.blessing.enable and self.db.profile.blessing.aftercombat) or
	   (self.db.profile.seal.enable and self.db.profile.seal.aftercombat) or
	   (self.db.profile.rf.enable and self.db.profile.rf.aftercombat) or
	   (self.db.profile.aura.enable and self.db.profile.aura.aftercombat) then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end

	-- Custom Message Frame
	if (not self.msgFrame) and self.db.profile.display.frame then
		self:CreateCustomFrame()
	end
end

-- Process combat log events
function PallyPowerWarn:COMBAT_LOG_EVENT_UNFILTERED(_,
   timestamp,
   event,
   sourceGUID,
   sourceName,
   sourceFlags,
   destGUID,
   destName,
   destFlags,
   ...)

	local substring

	-- If paladin is dead, don't issue warnings
	if (UnitIsDeadOrGhost("player")) then
		return
	end

	-- End if it isn't an event we care about
	if not trackedEvents[event] then
		-- self:Print("NOT tracked")
		-- self:Print(timestamp, event, sourceGUID, sourceName,
		--		sourceFlags, destGUID, destName, destFlags)
		-- self:Print(...)
		return
	end

	if event == "SPELL_AURA_REMOVED" then
		if self.db.profile.blessing.enable and
		   sourceGUID == UnitGUID("player") and blessing_ids[select(1,...)] then
			if self:IsBlessingCheckEnabled() then
				-- Was it replaced by a new blessing?
				-- When a player dies, the buffs are removed right before
				-- they die, so we need to delay checking to see if they died
				BuffFades[destName] = select(2,...)
				self:ScheduleTimer(self.CheckFades, 1, self)
			end
		end
		if self.db.profile.seal.enable and
		   sourceGUID == UnitGUID("player") and seal_ids[select(1,...)] then
			if not (self.db.profile.seal.combat and InCombatLockdown()) then
				-- When a player dies, the buffs are removed right before
				-- they die, so we need to delay checking to see if they died
				self:ScheduleTimer(self.CheckSeal, 1, self)
			end
		end
	end
	
	-- self:Print("tracked")
	-- self:Print(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
	-- self:Print(...)
end

-- Conditions to check for Blessing Fade
function PallyPowerWarn:IsBlessingCheckEnabled()
	-- Check when mounted?
	if (self.db.profile.blessing.mounted and IsMounted()) then
		return false
	end

	-- Check when in vehicle?
	if (self.db.profile.blessing.vehicle and UnitInVehicle("player")) then
		return false
	end

	-- Check when in combat?
	if (self.db.profile.blessing.combat and InCombatLockdown()) then
		return false
	end

	-- Check when PvP flagged?
	if (self.db.profile.blessing.pvp) then
		if UnitIsPVP("player") or UnitIsPVPFreeForAll("player") then
			return false
		end
	end

	-- Do we check in this location?
	if (not self:IsBlessingCheckLocation()) then
		return false
	end

	return true
end

-- Check all players that have had buffs fade
function PallyPowerWarn:CheckFades()
	for k, v in pairs (BuffFades) do
		-- self:Print("k = "..k..", v = "..v)
		self:CheckBuffFade(k, v)
	end
	BuffFades = {}
end

-- Check if a buff faded
function PallyPowerWarn:CheckBuffFade(unitid, oldBlessing)
	local name = UnitName(unitid)
	local hasbuff, visible, isdead = self:HasBuffs(unitid)
	if hasbuff == false and visible == true and isdead == false then
		local blessing = self:GetMyBlessing(unitid)
		if not blessing then
			self:LimitedMessage(
			  oldBlessing .. L[" faded from "] ..name,
			  "blessing",
			  self.db.profile.blessing.frequency)
		end
	end
end

-- Called to open the configuration
function PallyPowerWarn:OpenConfig()
	if InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory("PallyPowerWarn");
	else
		InterfaceOptionsFrame_OpenToFrame("PallyPowerWarn");
	end
end

-- Show the version number
function PallyPowerWarn:ShowVersion()
	self:Print(self.DisplayVersion)
end

-- Ready Check event
function PallyPowerWarn:READY_CHECK()
	-- self:Print("READY_CHECK")
	if self.db.profile.blessing.readycheck then
		self:CheckBlessings()
	end
	if self.db.profile.seal.readycheck then
		self:CheckSeal()
	end
	if self.db.profile.rf.readycheck then
		self:CheckRF()
	end
	if self.db.profile.aura.readycheck then
		self:CheckAura()
	end
end

-- Enter combat event
function PallyPowerWarn:PLAYER_REGEN_DISABLED()
	-- self:Print("PLAYER_REGEN_DISABLED")
	if self.db.profile.blessing.entercombat then
		self:CheckBlessings()
	end
	if self.db.profile.seal.entercombat then
		self:CheckSeal()
	end
	if self.db.profile.rf.entercombat then
		self:CheckRF()
	end
	if self.db.profile.aura.entercombat then
		self:CheckAura()
	end
end

-- Leave combat event
function PallyPowerWarn:PLAYER_REGEN_ENABLED()
	-- self:Print("PLAYER_REGEN_ENABLED")
	if self.db.profile.blessing.aftercombat then
		self:CheckBlessings()
	end
	if self.db.profile.seal.aftercombat then
		self:CheckSeal()
	end
	if self.db.profile.rf.aftercombat then
		self:CheckRF()
	end
	if self.db.profile.aura.aftercombat then
		self:CheckAura()
	end
end

-- Has the paladin fully buffed blessings?
function PallyPowerWarn:CheckBlessings()
	local missing_buffs = 0
	local wrong_buffs = 0
	local num_raid = GetNumRaidMembers()
	local max_raid = 0
	local unit_prefix
	local israid = 0
	local smartpets = PallyPower.opt.smartpets
	local PlayersMissingBuffs = {}
	local PlayersWrongBuffs = {}

	-- Enabled?
	if (not self.db.profile.blessing.enable) then
		return
	end

	-- Don't warn if dead
	if (UnitIsDeadOrGhost("player")) then
		return
	end

	-- Check when mounted?
	if (self.db.profile.blessing.mounted and IsMounted()) then
		return
	end

	-- Check when in vehicle?
	if (self.db.profile.blessing.vehicle and UnitInVehicle("player")) then
		return
	end

	-- Check when PvP flagged?
	if (self.db.profile.blessing.pvp) then
		if UnitIsPVP("player") or UnitIsPVPFreeForAll("player") then
			return
		end
	end

	-- Do we check in this location?
	if (not self:IsBlessingCheckLocation()) then
		return
	end

	if num_raid < 1 then
		-- party
		max_raid = MAX_PARTY_MEMBERS
		unit_prefix = "party"
		israid = 0
	else
		-- raid
		max_raid = MAX_RAID_MEMBERS
		unit_prefix = "raid"
		israid = 1
	end
	-- self:Print("max_raid: " .. max_raid)

	local hasbuff
	local visible

	-- player
	hasbuff, visible, isdead = self:HasBuffs("player")
	if visible and not hasbuff and not isdead then
		local name = UnitName("player")
		local blessing = self:GetMyBlessing("player")
		if blessing then
			wrong_buffs = wrong_buffs + 1
			PlayersWrongBuffs[name] = true
			-- self:Print(name.." has wrong buff")
		else
			missing_buffs = missing_buffs + 1
			PlayersMissingBuffs[name] = true
			-- self:Print(name.." is missing buffs")
		end
	end

	-- pet
	if UnitExists("playerpet") then
		hasbuff, visible, isdead = self:HasBuffs("playerpet")
		local name = UnitName("playerpet")
		if visible and not hasbuff and not isdead and
		   name ~= L["Unknown"] then
			local blessing = self:GetMyBlessing("playerpet")
			if blessing then
				wrong_buffs = wrong_buffs + 1
				PlayersWrongBuffs[name] = true
				-- self:Print(name.." has wrong buff")
			else
				missing_buffs = missing_buffs + 1
				PlayersMissingBuffs[name] = true
				-- self:Print(name.." is missing buffs")
			end
		end
	end

	for i = 1, max_raid do
		local unitid
		-- Check Player
		unitid = unit_prefix..i
		-- self:Print(unitid)
		if unitid and UnitExists(unitid) then
			hasbuff, visible, isdead = self:HasBuffs(unitid)

			-- Server lag will sometimes cause newly spawned units
			-- to show up as "Unknown"
			-- Can't check buffs properly on "Unknown" units
			local name = UnitName(unitid)

			if visible and not hasbuff and not isdead and
			   name ~= L["Unknown"] then
				local blessing = self:GetMyBlessing(unitid)
				if blessing then
					wrong_buffs = wrong_buffs + 1
					PlayersWrongBuffs[name] = true
					-- self:Print(name.." has wrong buff")
				else
					missing_buffs = missing_buffs + 1
					PlayersMissingBuffs[name] = true
					-- self:Print(name.." is missing buffs")
				end
			end
		end
		-- Check Player's pet if they have one
		unitid = unit_prefix.."pet"..i
		-- self:Print(unitid)
		if unitid and UnitExists(unitid) then
			hasbuff, visible, isdead = self:HasBuffs(unitid)

			-- Server lag will sometimes cause newly spawned units
			-- to show up as "Unknown"
			-- Can't check buffs properly on "Unknown" units
			local name = UnitName(unitid)

			if visible and not hasbuff and not isdead and
			   name ~= L["Unknown"] then
				-- By just checking phase shift,
				-- sometimes we would issue a warning about an
				-- Imp missing a blessing and then it would
				-- immediately shift

				-- If it is an Imp,
				-- we should ignore it if is phased
				-- if not UnitBuff(unitid, PhaseShiftSpell) then

				-- Just ignore Imps period
				if not self:IsImp(unitid) then
					local blessing = self:GetMyBlessing(unitid)
					if blessing then
						wrong_buffs = wrong_buffs + 1
						PlayersWrongBuffs[name] = true
						-- self:Print(name.." has wrong buff")
					else
						missing_buffs = missing_buffs + 1
						PlayersMissingBuffs[name] = true
						-- self:Print(name.." is missing buffs")
					end
				end
			end
		end
	end

	if missing_buffs > 0 then
		local message = L["Missing Buffs"] .. ": " .. missing_buffs
		self:LimitedMessage(message, "blessing",
			self.db.profile.blessing.frequency)

		-- Print players missing buffs
		local player_string = ""
		for k, v in pairs (PlayersMissingBuffs) do
			if player_string == "" then
				player_string = k
			else
				player_string = player_string..", "..k
			end
		end
		self:ChatMessage(L["Players missing buffs: "]..player_string,
			"blessing")
	end

	if wrong_buffs > 0 then
		if self.db.profile.blessing.wrong then
			local message = L["Wrong Buffs"] .. ": " .. wrong_buffs
			self:LimitedMessage(message, "blessing",
				self.db.profile.blessing.frequency)
		end

		-- Print players missing buffs
		local player_string = ""
		for k, v in pairs (PlayersWrongBuffs) do
			if player_string == "" then
				player_string = k
			else
				player_string = player_string..", "..k
			end
		end
		self:ChatMessage(L["Players with wrong buffs: "]..player_string,
			"blessing")
	end
end

-- Does the pally have a seal?
function PallyPowerWarn:CheckSeal()
	-- Enabled?
	if (not self.db.profile.seal.enable) then
		return
	end

	-- Don't warn if dead
	if (UnitIsDeadOrGhost("player")) then
		return
	end

	-- Check when mounted?
	if (self.db.profile.seal.mounted and IsMounted()) then
		return
	end

	-- Check when in vehicle?
	if (self.db.profile.seal.vehicle and UnitInVehicle("player")) then
		return
	end

	local seal_spell = PallyPower.Seals[PallyPower.opt.seal]
	local spell, expire = self:GetSeal()
	-- self:Print ("seal_spell: "..tostring(seal_spell)..", spell: "..tostring(spell))
	if (not spell) then
		self:LimitedMessage(L["Missing Seal"], "seal",
			self.db.profile.seal.frequency)
	elseif (seal_spell ~= spell) and self.db.profile.seal.wrong then
		self:LimitedMessage(L["Wrong Seal"], "seal",
			self.db.profile.seal.frequency)
	end
end

-- Does the pally have Righteous Fury?
function PallyPowerWarn:CheckRF()
	-- Enabled?
	if (not self.db.profile.rf.enable) then
		return
	end

	-- Don't warn if dead
	if (UnitIsDeadOrGhost("player")) then
		return
	end

	-- Check when mounted?
	if (self.db.profile.rf.mounted and IsMounted()) then
		return
	end

	-- Check when in vehicle?
	if (self.db.profile.rf.vehicle and UnitInVehicle("player")) then
		return
	end

	-- Is Righteous Fury enabled in PallyPower?
	local rf_enabled = PallyPower.opt.rf
	local rf_on = UnitBuff("player", PallyPower.RFSpell)

	-- Is Righteous Fury on?
	if rf_enabled and not rf_on then
		self:LimitedMessage(L["Missing Righteous Fury"], "rf",
			self.db.profile.rf.frequency)
	elseif not rf_enabled and rf_on then
		self:LimitedMessage(L["Righteous Fury is on"], "rf",
			self.db.profile.rf.frequency)
	end
end

-- Does the pally have an aura?
function PallyPowerWarn:CheckAura()
	-- Enabled?
	if (not self.db.profile.aura.enable) then
		return
	end

	-- Don't warn if dead
	if (UnitIsDeadOrGhost("player")) then
		return
	end

	-- Check when mounted?
	if (self.db.profile.aura.mounted and IsMounted()) then
		return
	end

	-- Check when in vehicle?
	if (self.db.profile.aura.vehicle and UnitInVehicle("player")) then
		return
	end

	-- If we are checking for wrong aura, then get the assigned aura
	local aura_spell = nil
	if (self.db.profile.aura.wrong ~= "any") then
		local name = UnitName("player")
		local AuraID = PallyPower_AuraAssignments[name]
		aura_spell = PallyPower.Auras[AuraID]
	end

	local spell, expire = self:GetAura()
	-- self:Print ("aura_spell: "..tostring(aura_spell)..", spell: "..tostring(spell))
	if (not spell) then
		self:LimitedMessage(L["Missing Aura"], "aura",
			self.db.profile.aura.frequency)
	elseif (aura_spell ~= spell) and (spell == CrusaderSpell) and
		(self.db.profile.aura.wrong == "crusader") then
		self:LimitedMessage(L["Wrong Aura"], "aura",
			self.db.profile.aura.frequency)
	elseif (aura_spell ~= spell) and
			(self.db.profile.aura.wrong == "pp") then
		self:LimitedMessage(L["Wrong Aura"], "aura",
			self.db.profile.aura.frequency)
	end
end

-- Has PallyPower assigned buff?
-- returns hasbuff, visible
function PallyPowerWarn:HasBuffs(unitid)
	local hasbuff = false
	local visible = false

	if not unitid or not UnitExists(unitid) then
		return nil
	end

	-- Get Info on unit
	local class
	local name = UnitName(unitid)
	local isdead = UnitIsDeadOrGhost(unitid) == 1
	local ispet = self:IsPet(unitid)

	if ispet then
		class = self:GetPetClass(unitid)
	else
		class = select(2, UnitClass(unitid))
	end

	-- Determine any buffs assigned to that unit
	local player_name = UnitName("player")
	if PallyPower.ClassToID[class] then
		local class_id = PallyPower.ClassToID[class]
		-- self:Print(name.." "..class_id)
		local normal, greater = PallyPower:GetSpellID(class_id, name)
		local spell = PallyPower.Spells[normal]
		local spell2 = PallyPower.GSpells[greater]
		-- self:Print(name.." assigned "..tostring(spell))
		visible = IsSpellInRange(spell, unitid) == 1
		if self:IsBuffActive(spell, spell2, unitid) then
			hasbuff = true
		else
			hasbuff = false
		end
	elseif visible then
		self:Print(L["Unable to determine class_id for "]..tostring(name).." "..tostring(class))
	end

	-- self:Print(tostring(name)..": visible: "..tostring(visible)..", hasbuff: "..tostring(hasbuff)..", isdead: "..tostring(isdead))
	return hasbuff, visible, isdead
end

-- IsPet
function PallyPowerWarn:IsPet(unitid)
	return not UnitIsPlayer(unitid) and
		(UnitPlayerControlled(unitid) or UnitPlayerOrPetInRaid(unitid))
end

-- Get the class for pets
function PallyPowerWarn:GetPetClass(unitid)
	local class = "PET"
	local ispet = self:IsPet(unitid)

	if not ispet then
		return nil
	end

	if PallyPower.opt.smartpets then
		local pclass = select(2, UnitClass(unitid))
		local family = UnitCreatureFamily(unitid)
						
		if pclass == "WARRIOR" then -- Hunter pets
			class = pclass
		elseif pclass == "ROGUE" then -- DK Ghoul
			class = pclass
		elseif pclass == "MAGE" then -- Water Elemental, Imp
			if family == L["PET_IMP"] then
				class = "WARLOCK"
			else
				class = pclass
			end
		elseif pclass == "PALADIN" then -- Other Warlock pets
			if family == L["PET_FELHUNTER"] or
			   family == L["PET_SUCCUBUS"] then
				class = "WARLOCK"
			else
				class = "WARRIOR"
			end
		end
	end
	return class
end

-- Is unitid an imp?
function PallyPowerWarn:IsImp(unitid)
	-- First is it a pet?
	local ispet = self:IsPet(unitid)
	if not ispet then
		return false
	end

	-- Does it show 
	local family = UnitCreatureFamily(unitid)
	if family ~= L["PET_IMP"] then
		return false
	end

	-- Is it a Mage?
	-- Imps show as Mage class
	local pclass = select(2, UnitClass(unitid))
	if pclass ~= "MAGE" then
		return false
	end

	-- It is an Imp
	return true
end

-- Better performance than the IsBuffActive in PallyPower
-- that one cycles through all buffs and debuffs on players
function PallyPowerWarn:IsBuffActive(spellName, gspellName, unitID)
	if UnitBuff(unitID, spellName) then
		local buffName, _, _, _, _, buffDuration,
			buffExpire = UnitBuff(unitID, spellName)
		return buffExpire, buffDuration, buffName
	elseif UnitBuff(unitID, gspellName) then
		local buffName, _, _, _, _, buffDuration,
			buffExpire = UnitBuff(unitID, gspellName)
		return buffExpire, buffDuration, buffName
	else
		return nil
	end
end

-- Get the paladin's current blessing on target
-- returns nil if no blessing
function PallyPowerWarn:GetMyBlessing(unitid)
	local spell

	-- Go through all buffs on a unit until you find a blessing
	-- cast by the player (if any)
	local i = 1
	local buffName, _, _, _, _, _, _, _, _, _,
		buffID = UnitBuff(unitid, i, "player")
	while buffName do
		if blessing_ids[buffID] and buffName then
			spell = buffName
			break
		end
		i = i + 1
		buffName, _, _, _, _, _, _, _, _, _,
			buffID = UnitBuff(unitid, i, "player")
	end
	return spell
end

-- Get the paladin's current seal
-- returns nil if no seal
function PallyPowerWarn:GetSeal()
	local spell
	local sealExpire = 9999
	local sealDuration = 30*60

	-- Go through all the player's self buffs until you find a seal (if any)
	local i = 1
	local buffName, _, _, _, _, buffDuration, buffExpire, _, _, _,
		buffID = UnitBuff("player", i, "player")
	while buffExpire do
		if seal_ids[buffID] and buffExpire then
			spell = buffName
			sealExpire = buffExpire - GetTime()
			break
		end
		i = i + 1
		buffName, _, _, _, _, buffDuration, buffExpire, _, _, _,
			buffID = UnitBuff("player", i, "player")
	end
	return spell, sealExpire, sealDuration
end

-- Get the paladin's current aura
-- returns nil if no aura
function PallyPowerWarn:GetAura()
	local spell

	-- Go through all the player's self buffs until you find an aura (if any)
	local i = 1
	local buffName, _, _, _, _, _, _, _, _, _,
		buffID = UnitBuff("player", i, "player")
	while buffName do
		if aura_ids[buffID] and buffName then
			spell = buffName
			break
		end
		i = i + 1
		buffName, _, _, _, _, _, _, _, _, _,
			buffID = UnitBuff("player", i, "player")
	end
	return spell
end

-- Check if this is a location where we check Blessings
function PallyPowerWarn:IsBlessingCheckLocation()
	local zone = GetRealZoneText()

	-- First check for Wintergrasp by zone text
	-- If warn in Wintergrasp is selected, it will warn
	-- even if World warnings are otherwise disabled
	if zone == L["ZONE_WG"] then
		if self.db.profile.blessing.wg then
			return true
		else
			return false
		end
	end

	local inInstance, instanceType = IsInInstance();

	-- Then check instance type
	if not self.db.profile.blessing.bg and instanceType == "pvp" then
		return false
	elseif not self.db.profile.blessing.arena and instanceType == "arena" then
		return false
	elseif not self.db.profile.blessing.instance and instanceType == "party" then
		return false
	elseif not self.db.profile.blessing.raid and instanceType == "raid" then
		return false
	elseif not self.db.profile.blessing.world then
		-- "none"
		return false
	end

	return true
end

-- Print PallyPower blessing assignments
-- This can be used to test that PallyPowerWarn is reading the PallyPower
-- assignments
-- /run PallyPowerWarn:PrintAssignments()
function PallyPowerWarn:PrintAssignments()
	local name = UnitName("player")

	local list = {}
	local blessings
	for i = 1, 4 do
		list[i] = 0
	end
	for id = 1, PALLYPOWER_MAXCLASSES do
		local class_name = ""
		if PallyPower.ClassID[id] then
			class_name = PallyPower.ClassID[id]
		else
			class_name = "unknown"
		end
		local bid = PallyPower_Assignments[name][id]
		if bid and bid > 0 then
			local pp_spell = PallyPower.Spells[bid]
			if (blessings) then
				blessings = blessings .. ", "
			else
				blessings = ""
			end
			blessings = blessings .. class_name .. ": " .. pp_spell
		end
		if PallyPower_NormalAssignments[name] and
		   PallyPower_NormalAssignments[name][id] then
			for class_id, tnames in pairs(PallyPower_NormalAssignments[name]) do
				for tname, bid in pairs(tnames) do
					if bid and bid > 0 then
						local pp_spell = PallyPower.Spells[bid]
						if (blessings) then
							blessings = blessings .. ", "
						else
							blessings = ""
						end
						blessings = blessings .. tname .. ": " .. pp_spell
					end
				end
			end
		end
	end
	if not (blessings) then
		blessings = "Nothing"
	end
	self:Print(name ..": ".. blessings)
end

-- Don't display a message of this type more often than limit
function PallyPowerWarn:LimitedMessage(str, type, limit)
	local last_time = 0
	if AlertTimes[type] then
		last_time = AlertTimes[type]
	end

	if (limit == 0) or ((GetTime() - last_time) > limit) then
		AlertTimes[type] = GetTime()
		self:Message(str, type)
	end
end

function PallyPowerWarn:ChatMessage(str, type)
	local c, t
	if type == "blessing" then
		c = self.db.profile.blessing.display.color
		t = self.db.profile.blessing.display.time
		opt_sound = self.db.profile.blessing.sound
	elseif type == "seal" then
		c = self.db.profile.seal.display.color
		t = self.db.profile.seal.display.time
		opt_sound = self.db.profile.seal.sound
	elseif type == "rf" then
		c = self.db.profile.rf.display.color
		t = self.db.profile.rf.display.time
		opt_sound = self.db.profile.rf.sound
	elseif type == "aura" then
		c = self.db.profile.aura.display.color
		t = self.db.profile.aura.display.time
		opt_sound = self.db.profile.aura.sound
	end
	if (type == "blessing" and self.db.profile.blessing.display.frames) or
	   (type == "seal" and self.db.profile.seal.display.frames) or
	   (type == "rf" and self.db.profile.rf.display.frames) or
	   (type == "aura" and self.db.profile.aura.display.frames) then
		-- Display Chat Message?
		if self.db.profile.display.chat then
			if self.db.profile.display.number == 0 then
				self:Print(str)
			else
				local chatframe = getglobal("ChatFrame" .. self.db.profile.display.number)
				chatframe:AddMessage(str, c.r, c.g, c.b)
			end
		end
	end
end

-- Display alerts to the user
function PallyPowerWarn:Message(str, type)
	local c, t
	if type == "blessing" then
		c = self.db.profile.blessing.display.color
		t = self.db.profile.blessing.display.time
		opt_sound = self.db.profile.blessing.sound
	elseif type == "seal" then
		c = self.db.profile.seal.display.color
		t = self.db.profile.seal.display.time
		opt_sound = self.db.profile.seal.sound
	elseif type == "rf" then
		c = self.db.profile.rf.display.color
		t = self.db.profile.rf.display.time
		opt_sound = self.db.profile.rf.sound
	elseif type == "aura" then
		c = self.db.profile.aura.display.color
		t = self.db.profile.aura.display.time
		opt_sound = self.db.profile.aura.sound
	end
	if (type == "blessing" and self.db.profile.blessing.display.frames) or
	   (type == "seal" and self.db.profile.seal.display.frames) or
	   (type == "rf" and self.db.profile.rf.display.frames) or
	   (type == "aura" and self.db.profile.aura.display.frames) then
		-- Display Chat Message?
		if self.db.profile.display.chat then
			if self.db.profile.display.number == 0 then
				self:Print(str)
			else
				local chatframe = getglobal("ChatFrame" .. self.db.profile.display.number)
				chatframe:AddMessage(str, c.r, c.g, c.b)
			end
		end
		-- Display to Blizzard Error frame?
		if self.db.profile.display.error then
			UIErrorsFrame:AddMessage(str, c.r, c.g, c.b, 1, t)
		end
		-- Display to Custom Frame?
		if self.db.profile.display.frame then
			self.msgFrame:SetTimeVisible(t)
			self.msgFrame:AddMessage(str, c.r, c.g, c.b, 1, t)
		end
	end
	if (type == "blessing" and self.db.profile.blessing.display.scroll) or
	   (type == "seal" and self.db.profile.seal.display.scroll) or
	   (type == "rf" and self.db.profile.rf.display.scroll) or
	   (type == "aura" and self.db.profile.aura.display.scroll) then
		-- Use LibSink to handle scrolling text
		self:Pour(str, c.r, c.g, c.b)
	end
	
	if opt_sound ~= "none" then
		local sound = sounds[opt_sound]
		if string.find(sound, "%\\") then
			PlaySoundFile(sound)
		else
			PlaySound(sound)
		end
	end
end

-- Scrolling Combat Text output
function PallyPowerWarn:SinkPrint(addon, message, r, g, b)
 	if not self.msgFrame then self:CreateCustomFrame() end
 	self.msgFrame:AddMessage(message, r, g, b, 1, UIERRORS_HOLD_TIME)
end

-- Create the output frame
function PallyPowerWarn:CreateCustomFrame()
	self.dragButton = CreateFrame("Button",nil,UIParent)
	self.dragButton.owner = self
	self.dragButton:Hide()
	self.dragButton:ClearAllPoints()
	self.dragButton:SetWidth(250)
	self.dragButton:SetHeight(20)
	
	if self.db.profile.display.x and self.db.profile.display.y then
		self.dragButton:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT",
			self.db.profile.display.x, self.db.profile.display.y)
	else 
		self.dragButton:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0)
	end	
	
	self.dragButton:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	})
	self.dragButton:SetBackdropColor(0,0,0.3,.6)	
	
	self.dragButton:SetMovable(true)
	self.dragButton:RegisterForDrag("LeftButton")
	self.dragButton:SetScript("OnDragStart",
		function() this.owner.dragButton:StartMoving() end )
	self.dragButton:SetScript("OnDragStop",
		function()
			this.owner.dragButton:StopMovingOrSizing()
			self.db.profile.display.x = this.owner.dragButton:GetLeft()
			self.db.profile.display.y = this.owner.dragButton:GetTop()
		end
	)

	self.msgFrame = CreateFrame("MessageFrame")
	self.msgFrame.owner = self
	self.msgFrame:ClearAllPoints()
	self.msgFrame:SetWidth(400)
	self.msgFrame:SetHeight(75)
	self.msgFrame:SetPoint("TOP", self.dragButton, "TOP", 0, 0)
	self.msgFrame:SetInsertMode("TOP")
	self.msgFrame:SetFrameStrata("HIGH")
	self.msgFrame:SetToplevel(true)

	self.msgText = self.dragButton:CreateFontString(nil, "BACKGROUND",
		"GameFontNormalSmall")
	self.msgText:SetText("PallyPowerWarn Display")
	self.msgText:SetPoint("TOP", self.dragButton, "TOP", 0, -5)

	self:UpdateLock()
	self:UpdateFont()
	
	self.msgFrame:Show()
end

-- Update the font in the custom frame
function PallyPowerWarn:UpdateFont()
	if self.db.profile.display.frame and self.msgFrame then
		self.msgFrame:SetFont("Fonts\\" .. self.db.profile.display.fontFace,
			self.db.profile.display.fontSize,
			self.db.profile.display.fontEffect)
	end
end

-- Lock or unlock the custom frame
function PallyPowerWarn:UpdateLock()
	if self.db.profile.display.frame and self.msgFrame then
		if self.db.profile.display.lock and not self.configMode then
			self.dragButton:SetMovable(false)
			self.dragButton:RegisterForDrag()
			self.msgFrame:SetBackdrop(nil)
			self.msgFrame:SetBackdropColor(0,0,0,0)
			self.dragButton:Hide()
		else
			self.dragButton:Show()
			self.dragButton:SetMovable(true)
			self.dragButton:RegisterForDrag("LeftButton")
			self.msgFrame:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			})
			self.msgFrame:SetBackdropColor(0,0,0.3,.3)
		end
	end
end

