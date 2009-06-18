--[[
	
	Filger - Adapted for Hodir Hardmode-
	Copyright (c) 2009, Nils Ruesch
	Modified by Priscylla
	-Not For Distribution-
	All rights reserved.
	
]]

local configmode = false;
local spells = {
	["MAGE"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["SHAMAN"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["WARLOCK"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["DRUID"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["PRIEST"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["ROGUE"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["WARRIOR"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["DEATHKNIGHT"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["PALADIN"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
	["HUNTER"] = {
		{
			Name = "Hodir",
			Richtung = "RIGHT",
			Abstand = 10,
			Mode = "ICON",
			
			{ spellName = "Singed", size = 30, scale = 1.5, unitId = "target", caster = "all", filter = "DEBUFF", barWidth = 120 },
			{ spellName = "Storm Cloud", size = 50, scale = 1.5, unitId = "player", caster = "ALL", filter = "BUFF", barWidth = 120 },
		},
	},
};

local class = select(2, UnitClass("player"));
local classcolor = RAID_CLASS_COLORS[class];
local active, bars = {}, {};

--local minuten = string.format("|cff%02x%02x%02m|r", classcolor.r*255, classcolor.g*255, classcolor.b*255);
--local sekunden = string.format("|cff%02x%02x%02s|r", classcolor.r*255, classcolor.g*255, classcolor.b*255);

local time, Update;
local function OnUpdate(self, elapsed)
	time = self.filter == "CD" and self.expirationTime+self.duration-GetTime() or self.expirationTime-GetTime();
	if ( self:GetParent().Mode == "BAR" ) then
		self.statusbar:SetValue(time);
		--self.time:SetFormattedText(time >= 60 and "%d"..minuten or ( time >= 10 and "%d"..sekunden or "%.1f"..sekunden ), time);
		self.time:SetFormattedText(SecondsToTimeAbbrev(time));
	end
	if ( time < 0 and self.filter == "CD" ) then
		local id = self:GetParent().Id;
		for index, value in ipairs(active[id]) do
			if ( self.spellName == value.data.spellName ) then
				tremove(active[id], index);
				break;
			end
		end
		self:SetScript("OnUpdate", nil);
		Update(self:GetParent());
	end
end

function Update(self)
	local id = self.Id;
	if ( not bars[id] ) then
		bars[id] = {};
	end
	for index, value in ipairs(bars[id]) do
		value:Hide();
	end
	local bar;
	for index, value in ipairs(active[id]) do
		bar = bars[id][index];
		if ( not bar ) then
			bar = CreateFrame("Frame", "FilgerAnker"..id.."Frame"..index, self);
			bar:SetWidth(value.data.size);
			bar:SetHeight(value.data.size);
			bar:SetScale(value.data.scale);
			if ( index == 1 ) then
				if ( configmode ) then
					bar:SetFrameStrata("BACKGROUND");
				end
				if ( self.Richtung == "UP" ) then
					bar:SetPoint("BOTTOM", self);
				elseif ( self.Richtung == "RIGHT" ) then
					bar:SetPoint("LEFT", self);
				elseif ( self.Richtung == "LEFT" ) then
					bar:SetPoint("RIGHT", self);
				else
					bar:SetPoint("TOP", self);
				end
			else
				if ( self.Richtung == "UP" ) then
					bar:SetPoint("BOTTOM", bars[id][index-1], "TOP", 0, self.Abstand);
				elseif ( self.Richtung == "RIGHT" ) then
					bar:SetPoint("LEFT", bars[id][index-1], "RIGHT", self.Mode == "ICON" and self.Abstand or value.data.barWidth+self.Abstand, 0);
				elseif ( self.Richtung == "LEFT" ) then
					bar:SetPoint("RIGHT", bars[id][index-1], "LEFT", self.Mode == "ICON" and -self.Abstand or -(value.data.barWidth+self.Abstand), 0);
				else
					bar:SetPoint("TOP", bars[id][index-1], "BOTTOM", 0, -self.Abstand);
				end
			end
			if ( self.Mode == "ICON" ) then
				bar.icon = bar:CreateTexture("$parentIcon", "BACKGROUND");
				bar.icon:SetAllPoints();
				bar.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93);
				
				bar.count = bar:CreateFontString(nil, "ARTWORK", "NumberFontNormal");
				bar.count:SetPoint("BOTTOMRIGHT", -2, 2);
				bar.count:SetJustifyH("RIGHT");
				
				bar.cooldown = CreateFrame("Cooldown", nil, bar, "CooldownFrameTemplate");
				bar.cooldown:SetAllPoints();
				bar.cooldown:SetReverse();
				
				bar.overlay = bar:CreateTexture(nil, "OVERLEY");
				bar.overlay:SetTexture("Interface\\AddOns\\hodirauras\\Textures\\border");
				bar.overlay:SetPoint("TOPLEFT", -3, 3);
				bar.overlay:SetPoint("BOTTOMRIGHT", 3, -3);
				bar.overlay:SetVertexColor(0.25, 0.25, 0.25);
			else
				bar.icon = bar:CreateTexture(nil, "BACKGROUND");
				bar.icon:SetAllPoints();
				bar.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93);
				
				bar.count = bar:CreateFontString(nil, "ARTWORK", "NumberFontNormal");
				bar.count:SetPoint("BOTTOMRIGHT");
				bar.count:SetJustifyH("RIGHT");
				
				bar.statusbar = CreateFrame("StatusBar", nil, bar);
				if ( configmode ) then
					bar.statusbar:SetFrameStrata("BACKGROUND");
				end
				bar.statusbar:SetWidth(value.data.barWidth or 200);
				bar.statusbar:SetHeight(value.data.size);
				bar.statusbar:SetStatusBarTexture("Interface\\AddOns\\hodirauras\\Textures\\statusbar");
				bar.statusbar:SetStatusBarColor(0.4, 0.4, 0.4, 1);
				bar.statusbar:SetPoint("LEFT", bar, "RIGHT");
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(0);
				bar.statusbar.background = bar.statusbar:CreateTexture(nil, "BACKGROUND");
				bar.statusbar.background:SetAllPoints();
				bar.statusbar.background:SetTexture("Interface\\AddOns\\hodirauras\\Textures\\statusbar");
				bar.statusbar.background:SetVertexColor(classcolor.r, classcolor.g, classcolor.b, 0.7);
				
				bar.time = bar.statusbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightRight");
				bar.time:SetPoint("RIGHT", bar.statusbar, -2, 1);
				
				bar.spellname = bar.statusbar:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
				bar.spellname:SetPoint("LEFT", bar.statusbar, 2, 1);
				bar.spellname:SetPoint("RIGHT", bar.time, "LEFT");
				bar.spellname:SetJustifyH("CENTER");
			end
			
			tinsert(bars[id], bar);
		end
		
		bar.spellName = value.data.spellName;
		
		bar.icon:SetTexture(value.icon);
		bar.count:SetText(value.count > 1 and value.count or "");
		if ( self.Mode == "BAR" ) then
			bar.spellname:SetText(value.data.displayName or value.data.spellName);
		end
		if ( value.duration > 0 ) then
			if ( self.Mode == "ICON" ) then
				CooldownFrame_SetTimer(bar.cooldown, value.data.filter == "CD" and value.expirationTime or value.expirationTime-value.duration, value.duration, 1);
				if ( value.data.filter == "CD" ) then
					bar.expirationTime = value.expirationTime;
					bar.duration = value.duration;
					bar.filter = value.data.filter;
					bar:SetScript("OnUpdate", OnUpdate);
				end
			else
				bar.statusbar:SetMinMaxValues(0, value.duration);
				bar.expirationTime = value.expirationTime;
				bar.duration = value.duration;
				bar.filter = value.data.filter;
				bar:SetScript("OnUpdate", OnUpdate);
			end
		else
			if ( self.Mode == "ICON" ) then
				bar.cooldown:Hide();
			else
				bar.statusbar:SetMinMaxValues(0, 1);
				bar.statusbar:SetValue(1);
				bar.time:SetText("");
				bar:SetScript("OnUpdate", nil);
			end
		end
		
		bar:Show();
	end
end

local function OnEvent(self, event, ...)
	local unit = ...;
	if ( ( unit == "target" or unit == "player" ) or event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "SPELL_UPDATE_COOLDOWN" ) then
		local data, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, start, enabled, slotLink;
		local id = self.Id;
		for i=1, #spells[class][id], 1 do
			data = spells[class][id][i];
			if ( data.filter == "BUFF" ) then
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitBuff(data.unitId, data.spellName);
			elseif ( data.filter == "DEBUFF" ) then
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitDebuff(data.unitId, data.spellName);
			else
				if ( type(data.spellName) == "string" ) then
					start, duration, enabled = GetSpellCooldown(data.spellName);
					icon = GetSpellTexture(data.spellName);
				else
					slotLink = GetInventoryItemLink("player", data.spellName);
					if ( slotLink ) then
						name, _, _, _, _, _, _, _, _, icon = GetItemInfo(slotLink);
						if ( not data.displayName ) then
							data.displayName = name;
						end
						start, duration, enabled = GetInventoryItemCooldown("player", data.spellName);
					end
				end
				count = 0;
				caster = "all";
			end
			if ( not active[id] ) then
				active[id] = {};
			end
			for index, value in ipairs(active[id]) do
				if ( data.spellName == value.data.spellName ) then
					tremove(active[id], index);
					break;
				end
			end
			if ( ( name and ( caster == data.caster or data.caster == "all" ) ) or ( ( enabled or 0 ) > 0 and ( duration or 0 ) > 1.5 ) ) then
				table.insert(active[id], { data = data, icon = icon, count = count, duration = duration, expirationTime = expirationTime or start });
			end
		end
		Update(self);
	end
end

if ( spells and spells[class] ) then
	for index in pairs(spells) do
		if ( index ~= class ) then
			spells[index] = nil;
		end
	end
	local data, frame;
	for i=1, #spells[class], 1 do
		data = spells[class][i];
		
		frame = CreateFrame("Frame", "FilgerAnker"..i, UIParent);
		frame.Id = i;
		frame.Richtung = data.Richtung or "DOWN";
		frame.Abstand = data.Abstand or 3;
		frame.Mode = data.Mode or "ICON";
		frame:SetWidth(spells[class][i][1] and spells[class][i][1].size or 100);
		frame:SetHeight(spells[class][i][1] and spells[class][i][1].size or 20);
		frame:SetPoint("CENTER");
		frame:SetMovable(1);
		
		if ( configmode ) then
			frame:SetFrameStrata("DIALOG");
			frame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "", insets = { left = 0, right = 0, top = 0, bottom = 0 }});
			frame:EnableMouse(1);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", function(self)
				if ( IsShiftKeyDown() and IsAltKeyDown() ) then
					self:StartMoving();
				end
			end);
			frame:SetScript("OnDragStop", function(self)
				self:StopMovingOrSizing();
			end);
			
			frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightCenter");
			frame.text:SetPoint("CENTER");
			frame.text:SetText(data.Name and data.Name or "FilgerAnker"..i);
			
			for j=1, #spells[class][i], 1 do
				data = spells[class][i][j];
				if ( not active[i] ) then
					active[i] = {};
				end
				table.insert(active[i], { data = data, icon = "Interface\\Icons\\temp", count = 9, duration = 0, expirationTime = 0 });
			end
			Update(frame);
		else
			for j=1, #spells[class][i], 1 do
				data = spells[class][i][j];
				if ( data.filter == "CD" ) then
					frame:RegisterEvent("SPELL_UPDATE_COOLDOWN");
					break;
				end
			end
			frame:RegisterEvent("UNIT_AURA");
			frame:RegisterEvent("PLAYER_TARGET_CHANGED");
			frame:RegisterEvent("PLAYER_ENTERING_WORLD");
			frame:SetScript("OnEvent", OnEvent);
		end
	end
end
