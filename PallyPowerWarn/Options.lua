--[[
$Id: Options.lua 26 2010-09-09 21:50:07Z stassart $

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

local L = LibStub("AceLocale-3.0"):GetLocale("PallyPowerWarn")

PallyPowerWarn.options = {
	name = L["Options for PallyPowerWarn"],
	handler = PallyPowerWarn,
	type ='group',
	childGroups ='tree',
	args = {
		ui = {
			name = L["Show UI"],
			type = "execute",
			desc = L["Shows the Graphical User Interface"],
			func = "OpenConfig",
			guiHidden = true,
			order = 999,
		},
		version = {
			name = L["Show version"],
			type = "execute",
			desc = L["Show version"],
			func = "ShowVersion",
			guiHidden = true,
			order = 998,
		},
		display = {
			name = L["General Display"],
			type = 'group',
			desc = L["General Display settings and options for the Custom Message Frame."],
			order = 100, 
			args = {
				info = {
					type = "description",
					order = 101,
					name = "Version " .. PallyPowerWarn.DisplayVersion .. "\n\nThis addon provides warnings for Blessings, Seals, Righteous Fury, and Auras.",
				},
				chatheader = {
					order = 109,
					type = "header",
					name = L["Chat Window Options"],
				},
				chat = {
					name = L["Chat Message"],
					type = "toggle",
					desc = L["Display message in Chat Frame."],
					get = function(info) return PallyPowerWarn.db.profile.display.chat end,
					set = function(info,v) PallyPowerWarn.db.profile.display.chat = v end,
					order = 110,
				},
				number= {
					name = L["Chat number"],
					type = "range",
					desc = L["Choose which chat to display the messages in (0=default)."],
					get = function(info) return PallyPowerWarn.db.profile.display.number end,
					set = function(info,v)
						PallyPowerWarn.db.profile.display.number = v
					end,
					step = 1,
					min = 0,
					max = 10,
					order = 111,
				},
				frameheader = {
					name = L["Message Frame"],
					type = "header",
					order = 112
				},
				-- error = {
				-- 	name = L["Error Frame"],
				-- 	type = "toggle",
				-- 	desc = L["Display message in Blizzard UI Error Frame."],
				-- 	get = function(info) return PallyPowerWarn.db.profile.display.error end,
				-- 	set = function(info,v) PallyPowerWarn.db.profile.display.error = v end,
				-- 	order = 120,
				-- },
				-- h121 = {type = "header", name = " ", order = 121},
				frame = {
					name = L["Message Frame"],
					type = "toggle",
					desc = L["Display message in Custom Message Frame."],
					get = function(info) return PallyPowerWarn.db.profile.display.frame end,
					set = function(info,v)
						PallyPowerWarn.db.profile.display.frame = v
						PallyPowerWarn:LoadEvents()
					end,
					order = 130,
				},
				lock = {
					name = L["Lock"],
					type = "toggle",
					desc = L["Toggle locking of the Custom Message Frame."],
					get = function(info) return PallyPowerWarn.db.profile.display.lock end,
					set = function(info,v)
						PallyPowerWarn.db.profile.display.lock = v
						PallyPowerWarn:UpdateLock()
					end,
					order = 131,
				},
				fontFace = {
					name = L["Font Face"],
					type = "select",
					desc = L["Set the font face in the Custom Message Frame."],
					get = function(info) return PallyPowerWarn.db.profile.display.fontFace end,
					set = function(info,v)
						PallyPowerWarn.db.profile.display.fontFace = v
						PallyPowerWarn:UpdateFont()
					end,
					values = {
						[L["FRIZQT__.TTF"]] = L["Friz Quadrata TT"],
						[L["ARIALN.TTF"]] = L["Arial"],
						[L["skurri.ttf"]] = L["Skurri"],
						[L["MORPHEUS.ttf"]] = L["Morpheus"],
					},
					order = 132,
				},
				fontSize = {
					name = L["Font Size"],
					type = "range",
					desc = L["Set the font size in the Custom Message Frame."],
					get = function(info) return PallyPowerWarn.db.profile.display.fontSize end,
					set = function(info,v)
						PallyPowerWarn.db.profile.display.fontSize = v
						PallyPowerWarn:UpdateFont()
					end,
					step = 1,
					min = 8,
					max = 32,
					order = 133,
				},
				fontEffect = {
					name = L["Font Effect"],
					type = "select",
					desc = L["Set the font effect in the Custom Message Frame."],
					get = function(info) return PallyPowerWarn.db.profile.display.fontEffect end,
					set = function(info,v)
						PallyPowerWarn.db.profile.display.fontEffect = v
						PallyPowerWarn:UpdateFont()
					end,
					values = {
						["none"] = L["None"],
						["OUTLINE"] = L["OUTLINE"],
						["THICKOUTLINE"] = L["THICKOUTLINE"],
						["MONOCHROME"] = L["MONOCHROME"],
					},
					order = 134,
				},
			}
		},
		blessing = {
			name = L["Blessings"],
			type = 'group',
			desc = L["Alerts for blessings."],
			order = 200, 
			args = {
				info = {
					type = "description",
					order = 201,
					name = L["Alerts for blessings."],
				},
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Enable checking blessings."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.enable end,
					set = function(info,v)
						PallyPowerWarn.db.profile.blessing.enable = v
						PallyPowerWarn:LoadEvents()
					end,
					order = 202, 
				},
				whenheader = {
					order = 203,
					type = "header",
					name = L["When to check"],
				},
				readycheck = {
					name = L["Ready Check"],
					type = "toggle",
					desc = L["Notify on ready check."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.readycheck end,
					set = function(info,v)
						PallyPowerWarn.db.profile.blessing.readycheck = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 204, 
				},
				entercombat = {
					name = L["Enter Combat"],
					type = "toggle",
					desc = L["Notify when entering combat."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.entercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.blessing.entercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 205,
				},
				aftercombat = {
					name = L["After Combat"],
					type = "toggle",
					desc = L["Notify after the end of combat."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.aftercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.blessing.aftercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 206,
				},
				disableheader = {
					order = 207,
					type = "header",
					name = L["Disable checks"],
				},
				mounted = {
					name = L["No Mounted"],
					type = "toggle",
					desc = L["Disable notifications when mounted."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.mounted end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.mounted = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 208,
				},
				vehicle = {
					name = L["No Vehicle"],
					type = "toggle",
					desc = L["Disable notifications when in a vehicle."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.vehicle end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.vehicle = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 209,
				},
				combat = {
					name = L["No Combat"],
					type = "toggle",
					desc = L["Disable notifications when in combat."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.combat end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.combat = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 210,
				},
				pvp = {
					name = L["No PvP"],
					type = "toggle",
					desc = L["Disable notifications when PvP flagged."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.pvp end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.pvp = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 211,
				},
				locationheader = {
					order = 212,
					type = "header",
					name = L["Location"],
				},
				bg = {
					name = L["Battleground"],
					type = "toggle",
					desc = L["Warn when in battlegrounds."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.bg end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.bg = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 213,
				},
				arena = {
					name = L["Arena"],
					type = "toggle",
					desc = L["Warn when in arena."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.arena end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.arena = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 214,
				},
				wintergrasp = {
					name = L["ZONE_WG"],
					type = "toggle",
					desc = L["Warn when in Wintergrasp."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.wg end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.wg = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 215,
				},
				instance = {
					name = L["5-man"],
					type = "toggle",
					desc = L["Warn when in a 5-man instance."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.instance end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.instance = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 216,
				},
				raid = {
					name = L["Raid"],
					type = "toggle",
					desc = L["Warn when in a raid instance."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.raid end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.raid = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 217,
				},
				world = {
					name = L["Other"],
					type = "toggle",
					desc = L["Warn when not in an instance, arena, or battleground."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.world end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.world = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 218,
				},
				wrongheader = {
					order = 219,
					type = "header",
					name = L["Wrong Buffs"],
				},
				wrong = {
					name = L["Wrong Buffs"],
					type = "toggle",
					desc = L["Warn for wrong buffs."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.wrong end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.wrong = v end,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 220,
				},
				wronginfo = {
					type = "description",
					order = 221,
					name = L["Displays a warning if your blessings do not match PallyPower."],
				},
				otherheader = {
					order = 222,
					type = "header",
					name = L["Other Options"],
				},
				time = {
					name = L["Frequency"],
					type = "range",
					desc = L["Do not warn more often than (5=default)"],
					get = function(info) return PallyPowerWarn.db.profile.blessing.frequency end,
					set = function(info,v)
						PallyPowerWarn.db.profile.blessing.frequency = v
						end,
					step = 1,
					min = 0,
					max = 30,
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 223,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when a buff is missing."],
					get = function(info) return PallyPowerWarn.db.profile.blessing.sound end,
					set = function(info,v) PallyPowerWarn.db.profile.blessing.sound = v	end,
					values = {
						["ding"] = L["Ding"],
						["dong"] = L["Dong"],
						["none"] = L["None"],
					},
					disabled = function() return not PallyPowerWarn.db.profile.blessing.enable end,
					order = 224,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = PallyPowerWarn.db.profile.blessing.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) PallyPowerWarn.db.profile.blessing.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return PallyPowerWarn.db.profile.blessing.display.scroll end,
							set = function(info,t) PallyPowerWarn.db.profile.blessing.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return PallyPowerWarn.db.profile.blessing.display.frames end,
							set = function(info,t) PallyPowerWarn.db.profile.blessing.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return PallyPowerWarn.db.profile.blessing.display.time end,
							set = function(info,v)
								PallyPowerWarn.db.profile.blessing.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		seal = {
			name = L["Seals"],
			type = 'group',
			desc = L["Alerts for seals."],
			order = 300, 
			args = {
				info = {
					type = "description",
					order = 301,
					name = L["Alerts for seals."],
				},
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Enable checking seals."],
					get = function(info) return PallyPowerWarn.db.profile.seal.enable end,
					set = function(info,v)
						PallyPowerWarn.db.profile.seal.enable = v
						PallyPowerWarn:LoadEvents()
					end,
					order = 302, 
				},
				whenheader = {
					order = 303,
					type = "header",
					name = L["When to check"],
				},
				readycheck = {
					name = L["Ready Check"],
					type = "toggle",
					desc = L["Notify on ready check."],
					get = function(info) return PallyPowerWarn.db.profile.seal.readycheck end,
					set = function(info,v)
						PallyPowerWarn.db.profile.seal.readycheck = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 304, 
				},
				entercombat = {
					name = L["Enter Combat"],
					type = "toggle",
					desc = L["Notify when entering combat."],
					get = function(info) return PallyPowerWarn.db.profile.seal.entercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.seal.entercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 305,
				},
				aftercombat = {
					name = L["After Combat"],
					type = "toggle",
					desc = L["Notify after the end of combat."],
					get = function(info) return PallyPowerWarn.db.profile.seal.aftercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.seal.aftercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 306,
				},
				disableheader = {
					order = 307,
					type = "header",
					name = L["Disable checks"],
				},
				mounted = {
					name = L["No Mounted"],
					type = "toggle",
					desc = L["Disable notifications when mounted."],
					get = function(info) return PallyPowerWarn.db.profile.seal.mounted end,
					set = function(info,v) PallyPowerWarn.db.profile.seal.mounted = v end,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 308,
				},
				vehicle = {
					name = L["No Vehicle"],
					type = "toggle",
					desc = L["Disable notifications when in a vehicle."],
					get = function(info) return PallyPowerWarn.db.profile.seal.vehicle end,
					set = function(info,v) PallyPowerWarn.db.profile.seal.vehicle = v end,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 309,
				},
				combat = {
					name = L["No Combat"],
					type = "toggle",
					desc = L["Disable notifications when in combat."],
					get = function(info) return PallyPowerWarn.db.profile.seal.combat end,
					set = function(info,v) PallyPowerWarn.db.profile.seal.combat = v end,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 310,
				},
				wrongheader = {
					order = 311,
					type = "header",
					name = L["Wrong Seal"],
				},
				wrong = {
					name = L["Wrong Seal"],
					type = "toggle",
					desc = L["Warn for wrong seal."],
					get = function(info) return PallyPowerWarn.db.profile.seal.wrong end,
					set = function(info,v) PallyPowerWarn.db.profile.seal.wrong = v end,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 312,
				},
				wronginfo = {
					type = "description",
					order = 313,
					name = L["Displays a warning if your seal does not match PallyPower."],
				},
				otherheader = {
					order = 314,
					type = "header",
					name = L["Other Options"],
				},
				time = {
					name = L["Frequency"],
					type = "range",
					desc = L["Do not warn more often than (5=default)"],
					get = function(info) return PallyPowerWarn.db.profile.seal.frequency end,
					set = function(info,v)
						PallyPowerWarn.db.profile.seal.frequency = v
						end,
					step = 1,
					min = 0,
					max = 30,
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 315,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when a buff is missing."],
					get = function(info) return PallyPowerWarn.db.profile.seal.sound end,
					set = function(info,v) PallyPowerWarn.db.profile.seal.sound = v	end,
					values = {
						["ding"] = L["Ding"],
						["dong"] = L["Dong"],
						["none"] = L["None"],
					},
					disabled = function() return not PallyPowerWarn.db.profile.seal.enable end,
					order = 316,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = PallyPowerWarn.db.profile.seal.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) PallyPowerWarn.db.profile.seal.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return PallyPowerWarn.db.profile.seal.display.scroll end,
							set = function(info,t) PallyPowerWarn.db.profile.seal.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return PallyPowerWarn.db.profile.seal.display.frames end,
							set = function(info,t) PallyPowerWarn.db.profile.seal.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return PallyPowerWarn.db.profile.seal.display.time end,
							set = function(info,v)
								PallyPowerWarn.db.profile.seal.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		rf = {
			name = L["Righteous Fury"],
			type = 'group',
			desc = L["Alerts for Righteous Fury."],
			order = 400, 
			args = {
				info = {
					type = "description",
					order = 401,
					name = L["Alerts for Righteous Fury."],
				},
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Enable checking Righteous Fury."],
					get = function(info) return PallyPowerWarn.db.profile.rf.enable end,
					set = function(info,v)
						PallyPowerWarn.db.profile.rf.enable = v
						PallyPowerWarn:LoadEvents()
					end,
					order = 402, 
				},
				whenheader = {
					order = 403,
					type = "header",
					name = L["When to check"],
				},
				readycheck = {
					name = L["Ready Check"],
					type = "toggle",
					desc = L["Notify on ready check."],
					get = function(info) return PallyPowerWarn.db.profile.rf.readycheck end,
					set = function(info,v)
						PallyPowerWarn.db.profile.rf.readycheck = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.rf.enable end,
					order = 404, 
				},
				entercombat = {
					name = L["Enter Combat"],
					type = "toggle",
					desc = L["Notify when entering combat."],
					get = function(info) return PallyPowerWarn.db.profile.rf.entercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.rf.entercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.rf.enable end,
					order = 405,
				},
				aftercombat = {
					name = L["After Combat"],
					type = "toggle",
					desc = L["Notify after the end of combat."],
					get = function(info) return PallyPowerWarn.db.profile.rf.aftercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.rf.aftercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.rf.enable end,
					order = 406,
				},
				disableheader = {
					order = 407,
					type = "header",
					name = L["Disable checks"],
				},
				mounted = {
					name = L["No Mounted"],
					type = "toggle",
					desc = L["Disable notifications when mounted."],
					get = function(info) return PallyPowerWarn.db.profile.rf.mounted end,
					set = function(info,v) PallyPowerWarn.db.profile.rf.mounted = v end,
					disabled = function() return not PallyPowerWarn.db.profile.rf.enable end,
					order = 408,
				},
				vehicle = {
					name = L["No Vehicle"],
					type = "toggle",
					desc = L["Disable notifications when in a vehicle."],
					get = function(info) return PallyPowerWarn.db.profile.rf.vehicle end,
					set = function(info,v) PallyPowerWarn.db.profile.rf.vehicle = v end,
					disabled = function() return not PallyPowerWarn.db.profile.rf.enable end,
					order = 409,
				},
				otherheader = {
					order = 410,
					type = "header",
					name = L["Other Options"],
				},
				time = {
					name = L["Frequency"],
					type = "range",
					desc = L["Do not warn more often than (5=default)"],
					get = function(info) return PallyPowerWarn.db.profile.rf.frequency end,
					set = function(info,v)
						PallyPowerWarn.db.profile.rf.frequency = v
						end,
					step = 1,
					min = 0,
					max = 30,
					disabled = function() return not PallyPowerWarn.db.profile.rf.enable end,
					order = 411,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when a buff is missing."],
					get = function(info) return PallyPowerWarn.db.profile.rf.sound end,
					set = function(info,v) PallyPowerWarn.db.profile.rf.sound = v	end,
					values = {
						["ding"] = L["Ding"],
						["dong"] = L["Dong"],
						["none"] = L["None"],
					},
					disabled = function() return not PallyPowerWarn.db.profile.rf.enable end,
					order = 412,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = PallyPowerWarn.db.profile.rf.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) PallyPowerWarn.db.profile.rf.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return PallyPowerWarn.db.profile.rf.display.scroll end,
							set = function(info,t) PallyPowerWarn.db.profile.rf.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return PallyPowerWarn.db.profile.rf.display.frames end,
							set = function(info,t) PallyPowerWarn.db.profile.rf.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return PallyPowerWarn.db.profile.rf.display.time end,
							set = function(info,v)
								PallyPowerWarn.db.profile.rf.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
		aura = {
			name = L["Auras"],
			type = 'group',
			desc = L["Alerts for auras."],
			order = 500, 
			args = {
				info = {
					type = "description",
					order = 501,
					name = L["Alerts for auras."],
				},
				enable = {
					name = L["Enable"],
					type = "toggle",
					desc = L["Enable checking auras."],
					get = function(info) return PallyPowerWarn.db.profile.aura.enable end,
					set = function(info,v)
						PallyPowerWarn.db.profile.aura.enable = v
						PallyPowerWarn:LoadEvents()
					end,
					order = 502, 
				},
				whenheader = {
					order = 503,
					type = "header",
					name = L["When to check"],
				},
				readycheck = {
					name = L["Ready Check"],
					type = "toggle",
					desc = L["Notify on ready check."],
					get = function(info) return PallyPowerWarn.db.profile.aura.readycheck end,
					set = function(info,v)
						PallyPowerWarn.db.profile.aura.readycheck = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 504, 
				},
				entercombat = {
					name = L["Enter Combat"],
					type = "toggle",
					desc = L["Notify when entering combat."],
					get = function(info) return PallyPowerWarn.db.profile.aura.entercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.aura.entercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 505,
				},
				aftercombat = {
					name = L["After Combat"],
					type = "toggle",
					desc = L["Notify after the end of combat."],
					get = function(info) return PallyPowerWarn.db.profile.aura.aftercombat end,
					set = function(info,v)
						PallyPowerWarn.db.profile.aura.aftercombat = v
						PallyPowerWarn:LoadEvents()
					end,
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 506,
				},
				disableheader = {
					order = 507,
					type = "header",
					name = L["Disable checks"],
				},
				mounted = {
					name = L["No Mounted"],
					type = "toggle",
					desc = L["Disable notifications when mounted."],
					get = function(info) return PallyPowerWarn.db.profile.aura.mounted end,
					set = function(info,v) PallyPowerWarn.db.profile.aura.mounted = v end,
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 508,
				},
				vehicle = {
					name = L["No Vehicle"],
					type = "toggle",
					desc = L["Disable notifications when in a vehicle."],
					get = function(info) return PallyPowerWarn.db.profile.aura.vehicle end,
					set = function(info,v) PallyPowerWarn.db.profile.aura.vehicle = v end,
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 509,
				},
				wrongheader = {
					order = 510,
					type = "header",
					name = L["Wrong Aura"],
				},
				wrong = {
					name = L["Wrong Aura"],
					type = "select",
					-- style = "radio",
					desc = L["Warn for wrong aura."],
					get = function(info) return PallyPowerWarn.db.profile.aura.wrong end,
					set = function(info,v) PallyPowerWarn.db.profile.aura.wrong = v end,
					values = {
						["any"] = L["Any aura is fine"],
						["crusader"] = L["Warn for Crusader only"],
						["pp"] = L["Non-PallyPower Aura"],
					},
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 511,
				},
				wronginfo = {
					type = "description",
					order = 512,
					name = L["Help"],
				},
				otherheader = {
					order = 513,
					type = "header",
					name = L["Other Options"],
				},
				time = {
					name = L["Frequency"],
					type = "range",
					desc = L["Do not warn more often than (5=default)"],
					get = function(info) return PallyPowerWarn.db.profile.aura.frequency end,
					set = function(info,v)
						PallyPowerWarn.db.profile.aura.frequency = v
						end,
					step = 1,
					min = 0,
					max = 30,
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 514,
				},
				sound = {
					name = L["Sound"],
					type = "select",
					desc = L["Play a sound when a buff is missing."],
					get = function(info) return PallyPowerWarn.db.profile.aura.sound end,
					set = function(info,v) PallyPowerWarn.db.profile.aura.sound = v	end,
					values = {
						["ding"] = L["Ding"],
						["dong"] = L["Dong"],
						["none"] = L["None"],
					},
					disabled = function() return not PallyPowerWarn.db.profile.aura.enable end,
					order = 515,
				},
				display = {
					name = L["Display"],
					type = 'group',
					desc = L["Settings for how to display the message."], 
					args = {
						color = {
							name = L["Color"],
							type = 'color',
							desc = L["Sets the color of the text when displaying messages."],
							get = function(info)
							local v = PallyPowerWarn.db.profile.aura.display.color
								return v.r,v.g,v.b
								end,
							set = function(info,r,g,b) PallyPowerWarn.db.profile.aura.display.color = {r=r,g=g,b=b} end
						},
						scroll = {
							type = 'toggle',
							name = L["Scroll output"],
							desc = L["Toggle showing messages in scrolling text. (Settings are in the 'Output Category')"],
							get = function(info) return PallyPowerWarn.db.profile.aura.display.scroll end,
							set = function(info,t) PallyPowerWarn.db.profile.aura.display.scroll = t end,
						},
						frames = {
							type = 'toggle',
							name = L["Frames output"],
							desc = L["Toggle whether the message will show up in the frames. (Settings are in the 'General Display' category.)"],
							get = function(info) return PallyPowerWarn.db.profile.aura.display.frames end,
							set = function(info,t) PallyPowerWarn.db.profile.aura.display.frames = t end,
						},
						time = {
							--hidden = true,
							name = L["Time to display message"],
							type = "range",
							desc = L["Set the time the message will be displayed (5=default)"],
							get = function(info) return PallyPowerWarn.db.profile.aura.display.time end,
							set = function(info,v)
								PallyPowerWarn.db.profile.aura.display.time = v
							end,
							step = 1,
							min = 1,
							max = 20,
							order = 111,
						},
					}
				},
			}
		},
	}
}

