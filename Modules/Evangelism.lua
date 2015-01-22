--[[
Author: Starinnia
CPR is a combo points display addon based on Funkydude's BasicComboPoints
Evangelism.lua - A module for tracking Evangelism stacks
$Date: 2013-11-27 08:36:16 -0600 (Wed, 27 Nov 2013) $
$Revision: 332 $
Project Version: @project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2014 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

if select(2, UnitClass("player")) ~= "PRIEST" then return end

local UnitBuff = UnitBuff

local cpr = LibStub("AceAddon-3.0"):GetAddon("ComboPointsRedux")
local modName = "Evangelism"
local mod = cpr:NewModule(modName)
local buff = GetSpellInfo(81661)

function mod:OnInitialize()
	self.abbrev = "EV"
	self.MAX_POINTS = 5
	self.displayName = buff
	self.events = { "UNIT_AURA" }
end

local oldCount = 0
function mod:UNIT_AURA(_, unit)
	if unit ~= "player" then return end
	
	local _, _, _, count = UnitBuff("player", buff)
	
	if count then
		if self.graphics then
			local r, g, b = cpr:GetColorByPoints(modName, count)
			for i = count, 1, -1 do
				self.graphics.points[i].icon:SetVertexColor(r, g, b)
				self.graphics.points[i]:Show()
			end
			for j = self.MAX_POINTS, count+1, -1 do
				self.graphics.points[j]:Hide()
			end
		end
		if self.text then self.text:SetNumPoints(count) end
		
		--should prevent spamming issues when UNIT_AURA fires and
		--the aura we care about hasn't changed
		if oldCount ~= count then
			oldCount = count
			cpr:DoFlash(modName, count)
		end
	else
		if self.graphics then
			for i = 1, self.MAX_POINTS do
				self.graphics.points[i]:Hide()
			end
		end
		if self.text then self.text:SetNumPoints("") end
		
		oldCount = 0
	end
end