local A = _G.Apex
A.Quests = {}

A.Quests.Sea1 = {
    {Q = "Bandit Quest", Level = 1, M = "Bandit", Pos = CFrame.new(1059, 17, 1531), Reward = 25, Enemy = "Bandit", Region = "Starter Island", Type = "Kill"},
    {Q = "Monkey Quest", Level = 14, M = "Monkey", Pos = CFrame.new(-1597, 300, -125), Reward = 75, Enemy = "Monkey", Region = "Jungle", Type = "Kill"},
    {Q = "Gorilla Quest", Level = 20, M = "Gorilla", Pos = CFrame.new(-1230, 60, -485), Reward = 120, Enemy = "Gorilla", Region = "Jungle", Type = "Kill"},
    {Q = "Pirate Beginner", Level = 25, M = "Pirate", Pos = CFrame.new(5811, 20, 901), Reward = 175, Enemy = "Pirate", Region = "Pirate Village", Type = "Kill"},
    {Q = "Pirate Soldier", Level = 30, M = "Pirate Soldier", Pos = CFrame.new(5285, 35, 1050), Reward = 225, Enemy = "Pirate Soldier", Region = "Pirate Village", Type = "Kill"},
    {Q = "Brute", Level = 35, M = "Brute", Pos = CFrame.new(5350, 30, 1100), Reward = 275, Enemy = "Brute", Region = "Pirate Village", Type = "Kill"},
    {Q = "Desert Bandit", Level = 45, M = "Desert Bandit", Pos = CFrame.new(1006, 15, 4160), Reward = 400, Enemy = "Desert Bandit", Region = "Desert", Type = "Kill"},
    {Q = "Desert Officer", Level = 50, M = "Desert Officer", Pos = CFrame.new(1100, 25, 4260), Reward = 500, Enemy = "Desert Officer", Region = "Desert", Type = "Kill"},
    {Q = "Snow Bandit", Level = 55, M = "Snow Bandit", Pos = CFrame.new(1338, 100, -1550), Reward = 600, Enemy = "Snow Bandit", Region = "Frozen Village", Type = "Kill"},
    {Q = "Snowman", Level = 60, M = "Snowman", Pos = CFrame.new(1350, 110, -1500), Reward = 650, Enemy = "Snowman", Region = "Frozen Village", Type = "Kill"},
    {Q = "Winter Bandit", Level = 65, M = "Winter Bandit", Pos = CFrame.new(1400, 100, -1600), Reward = 700, Enemy = "Winter Bandit", Region = "Frozen Village", Type = "Kill"},
    {Q = "Sky Bandit", Level = 75, M = "Sky Bandit", Pos = CFrame.new(-4950, 700, -2500), Reward = 900, Enemy = "Sky Bandit", Region = "Sky Island", Type = "Kill"},
    {Q = "Dark Master", Level = 85, M = "Dark Master", Pos = CFrame.new(-4800, 650, -2400), Reward = 1100, Enemy = "Dark Master", Region = "Sky Island", Type = "Kill"},
    {Q = "Prisoner", Level = 90, M = "Prisoner", Pos = CFrame.new(4850, 50, 750), Reward = 1200, Enemy = "Prisoner", Region = "Prison", Type = "Kill"},
    {Q = "Chief Guard", Level = 95, M = "Chief Guard", Pos = CFrame.new(4950, 50, 800), Reward = 1350, Enemy = "Chief Guard", Region = "Prison", Type = "Kill"},
    {Q = "Shanda", Level = 100, M = "Shanda", Pos = CFrame.new(4200, 50, 900), Reward = 1500, Enemy = "Shanda", Region = "Prison", Type = "Boss"},
    {Q = "Royal Squad", Level = 125, M = "Royal Squad", Pos = CFrame.new(-3900, 120, 5700), Reward = 2000, Enemy = "Royal Squad", Region = "Colosseum", Type = "Kill"},
    {Q = "Royal Soldier", Level = 150, M = "Royal Soldier", Pos = CFrame.new(-3850, 130, 5750), Reward = 2500, Enemy = "Royal Soldier", Region = "Colosseum", Type = "Kill"},
    {Q = "Military Soldier", Level = 155, M = "Military Soldier", Pos = CFrame.new(-4200, 30, 4300), Reward = 2600, Enemy = "Military Soldier", Region = "Marine Fortress", Type = "Kill"},
    {Q = "Military Spy", Level = 160, M = "Military Spy", Pos = CFrame.new(-4150, 35, 4350), Reward = 2750, Enemy = "Military Spy", Region = "Marine Fortress", Type = "Kill"},
    {Q = "Fishman Warrior", Level = 175, M = "Fishman Warrior", Pos = CFrame.new(3695, 10, -1950), Reward = 3000, Enemy = "Fishman Warrior", Region = "Underwater City", Type = "Kill"},
    {Q = "Fishman Chief", Level = 185, M = "Fishman Chief", Pos = CFrame.new(3700, 15, -1900), Reward = 3200, Enemy = "Fishman Chief", Region = "Underwater City", Type = "Kill"},
    {Q = "Frozen Bandit", Level = 200, M = "Frozen Bandit", Pos = CFrame.new(1200, 100, -1800), Reward = 3800, Enemy = "Frozen Bandit", Region = "Frozen Village", Type = "Kill"},
    {Q = "Yeti", Level = 225, M = "Yeti", Pos = CFrame.new(1150, 110, -1900), Reward = 4500, Enemy = "Yeti", Region = "Frozen Village", Type = "Boss"},
    {Q = "Fire Thrower", Level = 250, M = "Fire Thrower", Pos = CFrame.new(-2100, 70, -1000), Reward = 5000, Enemy = "Fire Thrower", Region = "Magma Village", Type = "Kill"},
    {Q = "Fire Soldier", Level = 260, M = "Fire Soldier", Pos = CFrame.new(-2050, 75, -1050), Reward = 5300, Enemy = "Fire Soldier", Region = "Magma Village", Type = "Kill"},
    {Q = "Magma Chief", Level = 275, M = "Magma Chief", Pos = CFrame.new(-2000, 80, -1100), Reward = 5800, Enemy = "Magma Chief", Region = "Magma Village", Type = "Boss"},
    {Q = "Buggy", Level = 350, M = "Buggy", Pos = CFrame.new(-1150, 30, 1600), Reward = 8000, Enemy = "Buggy", Region = "Orange Town", Type = "Boss"},
    {Q = "Giant Island Captain", Level = 375, M = "Giant Island Captain", Pos = CFrame.new(-1650, 100, -4700), Reward = 9000, Enemy = "Giant Island Captain", Region = "Rocky Shore", Type = "Kill"},
    {Q = "Vice Admiral", Level = 400, M = "Vice Admiral", Pos = CFrame.new(-4650, 25, -1950), Reward = 10500, Enemy = "Vice Admiral", Region = "Marine Base", Type = "Boss"},
    {Q = "Warden", Level = 425, M = "Warden", Pos = CFrame.new(5100, 50, 680), Reward = 12000, Enemy = "Warden", Region = "Prison", Type = "Kill"},
    {Q = "Chief Warden", Level = 450, M = "Chief Warden", Pos = CFrame.new(5150, 55, 720), Reward = 13500, Enemy = "Chief Warden", Region = "Prison", Type = "Kill"},
    {Q = "Swan", Level = 475, M = "Swan", Pos = CFrame.new(5200, 60, 760), Reward = 15000, Enemy = "Swan", Region = "Prison", Type = "Boss"},
    {Q = "Military Captain", Level = 500, M = "Military Captain", Pos = CFrame.new(-4400, 30, 4200), Reward = 17000, Enemy = "Military Captain", Region = "Marine Fortress", Type = "Kill"},
    {Q = "Fishman Raider", Level = 525, M = "Fishman Raider", Pos = CFrame.new(3800, 10, -1800), Reward = 19000, Enemy = "Fishman Raider", Region = "Underwater City", Type = "Kill"},
    {Q = "Fishman Captain", Level = 550, M = "Fishman Captain", Pos = CFrame.new(3850, 15, -1750), Reward = 21000, Enemy = "Fishman Captain", Region = "Underwater City", Type = "Kill"},
    {Q = "Thunder God", Level = 575, M = "Thunder God", Pos = CFrame.new(2300, 400, -5500), Reward = 24000, Enemy = "Thunder God", Region = "Upper Sky", Type = "Boss"},
    {Q = "Sky Enemy", Level = 580, M = "Sky Enemy", Pos = CFrame.new(-5000, 650, -2800), Reward = 25000, Enemy = "Sky Enemy", Region = "Sky Island", Type = "Kill"},
    {Q = "God's Guard", Level = 600, M = "God's Guard", Pos = CFrame.new(-4750, 700, -2600), Reward = 27000, Enemy = "God's Guard", Region = "Sky Island", Type = "Kill"},
    {Q = "Wysper", Level = 650, M = "Wysper", Pos = CFrame.new(-4800, 750, -2500), Reward = 32000, Enemy = "Wysper", Region = "Sky Island", Type = "Boss"},
    {Q = "Bored Captain", Level = 660, M = "Bored Captain", Pos = CFrame.new(-1500, 10, 4800), Reward = 33000, Enemy = "Bored Captain", Region = "Fountain Island", Type = "Kill"},
    {Q = "Shanks", Level = 700, M = "Shanks", Pos = CFrame.new(-1450, 15, 4850), Reward = 40000, Enemy = "Shanks", Region = "Fountain Island", Type = "Boss"},
}

A.Quests.Sea2 = {
    {Q = "Raider", Level = 700, M = "Raider", Pos = CFrame.new(-1400, 100, 3500), Reward = 42000, Enemy = "Raider", Region = "Kingdom of Roses", Type = "Kill"},
    {Q = "Mercenary", Level = 725, M = "Mercenary", Pos = CFrame.new(-1350, 110, 3550), Reward = 44000, Enemy = "Mercenary", Region = "Kingdom of Roses", Type = "Kill"},
    {Q = "Diamond", Level = 750, M = "Diamond", Pos = CFrame.new(-1300, 115, 3600), Reward = 48000, Enemy = "Diamond", Region = "Kingdom of Roses", Type = "Boss"},
    {Q = "Swan Pirate", Level = 775, M = "Swan Pirate", Pos = CFrame.new(990, 120, 1300), Reward = 50000, Enemy = "Swan Pirate", Region = "Forgotten Island", Type = "Kill"},
    {Q = "Don Swan", Level = 800, M = "Don Swan", Pos = CFrame.new(1050, 125, 1350), Reward = 55000, Enemy = "Don Swan", Region = "Forgotten Island", Type = "Boss"},
    {Q = "Factory Staff", Level = 800, M = "Factory Staff", Pos = CFrame.new(-2650, 75, -1050), Reward = 53000, Enemy = "Factory Staff", Region = "Green Zone", Type = "Kill"},
    {Q = "Factory Staff Elite", Level = 825, M = "Factory Staff Elite", Pos = CFrame.new(-2600, 80, -1100), Reward = 56000, Enemy = "Factory Staff Elite", Region = "Green Zone", Type = "Kill"},
    {Q = "Marine Lieutenant", Level = 850, M = "Marine Lieutenant", Pos = CFrame.new(-2050, 50, 2500), Reward = 58000, Enemy = "Marine Lieutenant", Region = "Hot and Cold", Type = "Kill"},
    {Q = "Marine Captain", Level = 875, M = "Marine Captain", Pos = CFrame.new(-2000, 55, 2550), Reward = 61000, Enemy = "Marine Captain", Region = "Hot and Cold", Type = "Kill"},
    {Q = "Ship Officer", Level = 875, M = "Ship Officer", Pos = CFrame.new(-1950, 60, 2600), Reward = 62000, Enemy = "Ship Officer", Region = "Hot and Cold", Type = "Kill"},
    {Q = "Island Empress", Level = 900, M = "Island Empress", Pos = CFrame.new(-1900, 65, 2650), Reward = 66000, Enemy = "Island Empress", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Kilo Admiral", Level = 925, M = "Kilo Admiral", Pos = CFrame.new(2250, 30, -6800), Reward = 70000, Enemy = "Kilo Admiral", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Captain Elephant", Level = 950, M = "Captain Elephant", Pos = CFrame.new(2300, 35, -6750), Reward = 75000, Enemy = "Captain Elephant", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Beautiful Pirate", Level = 975, M = "Beautiful Pirate", Pos = CFrame.new(2400, 40, -6600), Reward = 80000, Enemy = "Beautiful Pirate", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Ice Admiral", Level = 1000, M = "Ice Admiral", Pos = CFrame.new(1500, 110, -2700), Reward = 85000, Enemy = "Ice Admiral", Region = "Frozen Castle", Type = "Boss"},
    {Q = "Cyborg", Level = 1000, M = "Cyborg", Pos = CFrame.new(650, 10, -1100), Reward = 90000, Enemy = "Cyborg", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Fishman Raider", Level = 1100, M = "Fishman Raider", Pos = CFrame.new(-1100, 10, -1500), Reward = 95000, Enemy = "Fishman Raider", Region = "Deep Sea", Type = "Kill"},
    {Q = "Fishman Captain", Level = 1125, M = "Fishman Captain", Pos = CFrame.new(-1050, 15, -1550), Reward = 100000, Enemy = "Fishman Captain", Region = "Deep Sea", Type = "Kill"},
    {Q = "Arctic Explorer", Level = 1150, M = "Arctic Explorer", Pos = CFrame.new(1600, 115, -2600), Reward = 105000, Enemy = "Arctic Explorer", Region = "Frozen Castle", Type = "Kill"},
    {Q = "Big Mom", Level = 1175, M = "Big Mom", Pos = CFrame.new(1550, 120, -2650), Reward = 110000, Enemy = "Big Mom", Region = "Frozen Castle", Type = "Boss"},
    {Q = "Magma Admiral", Level = 1200, M = "Magma Admiral", Pos = CFrame.new(-1800, 80, -2200), Reward = 115000, Enemy = "Magma Admiral", Region = "Magma Lake", Type = "Boss"},
    {Q = "Tiki Outpost Pirate", Level = 1225, M = "Tiki Outpost Pirate", Pos = CFrame.new(-1750, 85, -2250), Reward = 120000, Enemy = "Tiki Outpost Pirate", Region = "Tiki Outpost", Type = "Kill"},
    {Q = "Tiki Outpost Soldier", Level = 1250, M = "Tiki Outpost Soldier", Pos = CFrame.new(-1700, 90, -2300), Reward = 125000, Enemy = "Tiki Outpost Soldier", Region = "Tiki Outpost", Type = "Kill"},
    {Q = "Tiki Outpost Elite", Level = 1275, M = "Tiki Outpost Elite", Pos = CFrame.new(-1650, 95, -2350), Reward = 130000, Enemy = "Tiki Outpost Elite", Region = "Tiki Outpost", Type = "Kill"},
    {Q = "Dragon Crew Warrior", Level = 1300, M = "Dragon Crew Warrior", Pos = CFrame.new(5800, 50, -1200), Reward = 140000, Enemy = "Dragon Crew Warrior", Region = "Dragon Dojo", Type = "Kill"},
    {Q = "Dragon Crew Archer", Level = 1325, M = "Dragon Crew Archer", Pos = CFrame.new(5850, 55, -1250), Reward = 145000, Enemy = "Dragon Crew Archer", Region = "Dragon Dojo", Type = "Kill"},
    {Q = "Oni", Level = 1350, M = "Oni", Pos = CFrame.new(5900, 60, -1300), Reward = 150000, Enemy = "Oni", Region = "Dragon Dojo", Type = "Kill"},
    {Q = "Diamond", Level = 1400, M = "Diamond", Pos = CFrame.new(-1300, 115, 3600), Reward = 155000, Enemy = "Diamond", Region = "Kingdom of Roses", Type = "Boss"},
    {Q = "Jeremy", Level = 1425, M = "Jeremy", Pos = CFrame.new(-2800, 60, 1800), Reward = 160000, Enemy = "Jeremy", Region = "Kingdom of Roses", Type = "Boss"},
    {Q = "Fajita", Level = 1450, M = "Fajita", Pos = CFrame.new(-3100, 50, 1200), Reward = 165000, Enemy = "Fajita", Region = "Rocky Shore", Type = "Boss"},
    {Q = "Smoke Admiral", Level = 1475, M = "Smoke Admiral", Pos = CFrame.new(-2400, 45, 2000), Reward = 170000, Enemy = "Smoke Admiral", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Awakened Ice Admiral", Level = 1500, M = "Awakened Ice Admiral", Pos = CFrame.new(1550, 115, -2650), Reward = 175000, Enemy = "Awakened Ice Admiral", Region = "Frozen Castle", Type = "Boss"},
    {Q = "Order", Level = 1500, M = "Order", Pos = CFrame.new(-2900, 40, 1400), Reward = 180000, Enemy = "Order", Region = "Kingdom of Roses", Type = "Boss"},
    {Q = "Darkbeard", Level = 1550, M = "Darkbeard", Pos = CFrame.new(3750, 15, -7000), Reward = 200000, Enemy = "Darkbeard", Region = "Dark Arena", Type = "Boss"},
    {Q = "Core Brain", Level = 1500, M = "Core Brain", Pos = CFrame.new(2500, 45, -6500), Reward = 185000, Enemy = "Core Brain", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Captain Elephant Sea2", Level = 1300, M = "Captain Elephant", Pos = CFrame.new(2350, 38, -6700), Reward = 140000, Enemy = "Captain Elephant", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Beautiful Pirate Sea2", Level = 1325, M = "Beautiful Pirate", Pos = CFrame.new(2450, 43, -6550), Reward = 145000, Enemy = "Beautiful Pirate", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Tide Keeper", Level = 1400, M = "Tide Keeper", Pos = CFrame.new(-1200, 10, -1400), Reward = 160000, Enemy = "Tide Keeper", Region = "Deep Sea", Type = "Boss"},
    {Q = "Rip Indra", Level = 1550, M = "Rip Indra", Pos = CFrame.new(-5000, 300, 4000), Reward = 250000, Enemy = "Rip Indra", Region = "Floating Turtle", Type = "Boss"},
    {Q = "Lost Soul", Level = 1050, M = "Lost Soul", Pos = CFrame.new(-1600, 50, 3000), Reward = 88000, Enemy = "Lost Soul", Region = "Kingdom of Roses", Type = "Kill"},
    {Q = "Dangerous Enemy", Level = 1100, M = "Dangerous Enemy", Pos = CFrame.new(-1550, 55, 3050), Reward = 93000, Enemy = "Dangerous Enemy", Region = "Kingdom of Roses", Type = "Kill"},
    {Q = "Rogue Pirate", Level = 1150, M = "Rogue Pirate", Pos = CFrame.new(-1500, 60, 3100), Reward = 100000, Enemy = "Rogue Pirate", Region = "Kingdom of Roses", Type = "Kill"},
    {Q = "Forgotten Soldier", Level = 1200, M = "Forgotten Soldier", Pos = CFrame.new(950, 115, 1250), Reward = 115000, Enemy = "Forgotten Soldier", Region = "Forgotten Island", Type = "Kill"},
    {Q = "Sunker Pirate", Level = 1250, M = "Sunker Pirate", Pos = CFrame.new(900, 110, 1200), Reward = 125000, Enemy = "Sunker Pirate", Region = "Forgotten Island", Type = "Kill"},
    {Q = "Man and His Brother", Level = 1150, M = "Man and His Brother", Pos = CFrame.new(-2050, 50, 2500), Reward = 105000, Enemy = "Man and His Brother", Region = "Hot and Cold", Type = "Kill"},
    {Q = "Clueless Pirate", Level = 1300, M = "Clueless Pirate", Pos = CFrame.new(-1950, 60, 2600), Reward = 140000, Enemy = "Clueless Pirate", Region = "Hot and Cold", Type = "Kill"},
}

A.Quests.Sea3 = {
    {Q = "Royal Guard", Level = 1550, M = "Royal Guard", Pos = CFrame.new(-5500, 350, 5300), Reward = 210000, Enemy = "Royal Guard", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Royal Soldier", Level = 1575, M = "Royal Soldier", Pos = CFrame.new(-5450, 355, 5350), Reward = 220000, Enemy = "Royal Soldier", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Pistol Billionaire", Level = 1600, M = "Pistol Billionaire", Pos = CFrame.new(-5400, 360, 5400), Reward = 230000, Enemy = "Pistol Billionaire", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Dragon Crew Recruit", Level = 1625, M = "Dragon Crew Recruit", Pos = CFrame.new(5900, 60, -1400), Reward = 240000, Enemy = "Dragon Crew Recruit", Region = "Dragon Dojo", Type = "Kill"},
    {Q = "Dragon Crew Warrior Sea3", Level = 1650, M = "Dragon Crew Warrior", Pos = CFrame.new(5950, 65, -1450), Reward = 250000, Enemy = "Dragon Crew Warrior", Region = "Dragon Dojo", Type = "Kill"},
    {Q = "Helmet Chaos", Level = 1675, M = "Helmet Chaos", Pos = CFrame.new(-5350, 365, 5450), Reward = 260000, Enemy = "Helmet Chaos", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Peaches", Level = 1700, M = "Peaches", Pos = CFrame.new(-5300, 370, 5500), Reward = 275000, Enemy = "Peaches", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Reef High Guard", Level = 1725, M = "Reef High Guard", Pos = CFrame.new(-4900, 10, 5800), Reward = 285000, Enemy = "Reef High Guard", Region = "Deep Fortress", Type = "Kill"},
    {Q = "Seat Kingdom Guard", Level = 1750, M = "Seat Kingdom Guard", Pos = CFrame.new(-4850, 15, 5850), Reward = 295000, Enemy = "Seat Kingdom Guard", Region = "Deep Fortress", Type = "Kill"},
    {Q = "Reef Pirate", Level = 1775, M = "Reef Pirate", Pos = CFrame.new(-4800, 20, 5900), Reward = 305000, Enemy = "Reef Pirate", Region = "Deep Fortress", Type = "Kill"},
    {Q = "Stone Guard", Level = 1800, M = "Stone Guard", Pos = CFrame.new(-4750, 25, 5950), Reward = 320000, Enemy = "Stone Guard", Region = "Deep Fortress", Type = "Kill"},
    {Q = "Stone", Level = 1825, M = "Stone", Pos = CFrame.new(-4700, 30, 6000), Reward = 335000, Enemy = "Stone", Region = "Deep Fortress", Type = "Boss"},
    {Q = "Royal Squad Sea3", Level = 1850, M = "Royal Squad", Pos = CFrame.new(-5250, 375, 5550), Reward = 345000, Enemy = "Royal Squad", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Royal Soldier Sea3", Level = 1875, M = "Royal Soldier", Pos = CFrame.new(-5200, 380, 5600), Reward = 355000, Enemy = "Royal Soldier", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Kaffed", Level = 1900, M = "Kaffed", Pos = CFrame.new(-5150, 385, 5650), Reward = 370000, Enemy = "Kaffed", Region = "Floating Turtle", Type = "Kill"},
    {Q = "Water Warrior", Level = 1925, M = "Water Warrior", Pos = CFrame.new(4300, 10, -7300), Reward = 380000, Enemy = "Water Warrior", Region = "Turtle Mansion", Type = "Kill"},
    {Q = "Water Fighter", Level = 1950, M = "Water Fighter", Pos = CFrame.new(4350, 15, -7350), Reward = 395000, Enemy = "Water Fighter", Region = "Turtle Mansion", Type = "Kill"},
    {Q = "Sea Soldier", Level = 1975, M = "Sea Soldier", Pos = CFrame.new(4400, 20, -7400), Reward = 410000, Enemy = "Sea Soldier", Region = "Turtle Mansion", Type = "Kill"},
    {Q = "Frozen Warrior", Level = 2000, M = "Frozen Warrior", Pos = CFrame.new(4450, 25, -7450), Reward = 425000, Enemy = "Frozen Warrior", Region = "Turtle Mansion", Type = "Kill"},
    {Q = "Tide Keeper Sea3", Level = 2025, M = "Tide Keeper", Pos = CFrame.new(-1200, 10, -1400), Reward = 440000, Enemy = "Tide Keeper", Region = "Deep Sea", Type = "Boss"},
    {Q = "Island Champion", Level = 2050, M = "Island Champion", Pos = CFrame.new(4500, 30, -7500), Reward = 460000, Enemy = "Island Champion", Region = "Turtle Mansion", Type = "Boss"},
    {Q = "Beautiful Pirate Sea3", Level = 2075, M = "Beautiful Pirate", Pos = CFrame.new(2450, 43, -6550), Reward = 475000, Enemy = "Beautiful Pirate", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Longma", Level = 2100, M = "Longma", Pos = CFrame.new(5650, 70, -1450), Reward = 500000, Enemy = "Longma", Region = "Dragon Dojo", Type = "Boss"},
    {Q = "Captain Elephant Sea3", Level = 2125, M = "Captain Elephant", Pos = CFrame.new(2350, 38, -6700), Reward = 510000, Enemy = "Captain Elephant", Region = "Hot and Cold", Type = "Boss"},
    {Q = "Cake Prince", Level = 2150, M = "Cake Prince", Pos = CFrame.new(-2050, 80, -1200), Reward = 530000, Enemy = "Cake Prince", Region = "Magma Lake", Type = "Boss"},
    {Q = "Dough King", Level = 2200, M = "Dough King", Pos = CFrame.new(-2000, 85, -1250), Reward = 560000, Enemy = "Dough King", Region = "Magma Lake", Type = "Boss"},
    {Q = "Red Dragon", Level = 2225, M = "Red Dragon", Pos = CFrame.new(6100, 80, -1500), Reward = 575000, Enemy = "Red Dragon", Region = "Dragon Dojo", Type = "Kill"},
    {Q = "Electric Dragon", Level = 2250, M = "Electric Dragon", Pos = CFrame.new(6150, 85, -1550), Reward = 590000, Enemy = "Electric Dragon", Region = "Dragon Dojo", Type = "Kill"},
    {Q = "Rip Indra Sea3", Level = 2300, M = "Rip Indra", Pos = CFrame.new(-5000, 300, 4000), Reward = 620000, Enemy = "Rip Indra", Region = "Floating Turtle", Type = "Boss"},
    {Q = "Body of Water", Level = 2350, M = "Body of Water", Pos = CFrame.new(3200, 5, -6900), Reward = 650000, Enemy = "Body of Water", Region = "Deep Fortress", Type = "Boss"},
    {Q = "Great Tree", Level = 2400, M = "Great Tree", Pos = CFrame.new(-4900, 400, 5000), Reward = 680000, Enemy = "Great Tree", Region = "Floating Turtle", Type = "Boss"},
    {Q = "Soul Guitar User", Level = 2425, M = "Soul Guitar User", Pos = CFrame.new(4200, 30, -7200), Reward = 700000, Enemy = "Soul Guitar User", Region = "Haunted Castle", Type = "Boss"},
    {Q = "Elite Hunter", Level = 2450, M = "Elite Hunter", Pos = CFrame.new(4250, 35, -7250), Reward = 720000, Enemy = "Elite Hunter", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Zombie", Level = 1600, M = "Zombie", Pos = CFrame.new(-5800, 10, -6300), Reward = 230000, Enemy = "Zombie", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Vampire", Level = 1650, M = "Vampire", Pos = CFrame.new(-5750, 15, -6350), Reward = 250000, Enemy = "Vampire", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Demonic Soul", Level = 1700, M = "Demonic Soul", Pos = CFrame.new(-5700, 20, -6400), Reward = 275000, Enemy = "Demonic Soul", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Living Zombie", Level = 1750, M = "Living Zombie", Pos = CFrame.new(-5650, 25, -6450), Reward = 295000, Enemy = "Living Zombie", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Possessed Mummy", Level = 1800, M = "Possessed Mummy", Pos = CFrame.new(-5600, 30, -6500), Reward = 320000, Enemy = "Possessed Mummy", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Cursed Skeleton", Level = 1850, M = "Cursed Skeleton", Pos = CFrame.new(-5550, 35, -6550), Reward = 345000, Enemy = "Cursed Skeleton", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Ghost", Level = 1900, M = "Ghost", Pos = CFrame.new(-5500, 40, -6600), Reward = 370000, Enemy = "Ghost", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Reborn Skeleton", Level = 1950, M = "Reborn Skeleton", Pos = CFrame.new(-5450, 45, -6650), Reward = 395000, Enemy = "Reborn Skeleton", Region = "Haunted Castle", Type = "Kill"},
    {Q = "Frozen Flight", Level = 2000, M = "Frozen Flight", Pos = CFrame.new(3000, 10, -7000), Reward = 425000, Enemy = "Frozen Flight", Region = "Deep Fortress", Type = "Kill"},
    {Q = "Fearful Ghost", Level = 2050, M = "Fearful Ghost", Pos = CFrame.new(-5400, 50, -6700), Reward = 460000, Enemy = "Fearful Ghost", Region = "Haunted Castle", Type = "Boss"},
    {Q = "Chief of Staff", Level = 2100, M = "Chief of Staff", Pos = CFrame.new(-5350, 55, -6750), Reward = 500000, Enemy = "Chief of Staff", Region = "Haunted Castle", Type = "Boss"},
}

A.Quests.Bosses = {
    {Name = "Shanks", Level = 700, Sea = 1, Pos = CFrame.new(-1450, 15, 4850), SpawnTime = 30, RespawnTime = 60, Drops = {"Black Cape", "Bloxy Cola", "Wanted Poster"}, RequiredQuest = "Shanks", Island = "Fountain Island"},
    {Name = "Buggy", Level = 350, Sea = 1, Pos = CFrame.new(-1150, 30, 1600), SpawnTime = 15, RespawnTime = 30, Drops = {"Buggy's Cape", "Buggy's Sword"}, RequiredQuest = "Buggy", Island = "Orange Town"},
    {Name = "Bobby", Level = 100, Sea = 1, Pos = CFrame.new(-4600, 30, -1900), SpawnTime = 10, RespawnTime = 20, Drops = {"Bobby's Sword"}, RequiredQuest = "Logue Town", Island = "Logue Town"},
    {Name = "Yeti", Level = 225, Sea = 1, Pos = CFrame.new(1150, 110, -1900), SpawnTime = 15, RespawnTime = 30, Drops = {"Yeti Fur", "Yeti's Sword"}, RequiredQuest = "Yeti", Island = "Frozen Village"},
    {Name = "Magma Chief", Level = 275, Sea = 1, Pos = CFrame.new(-2000, 80, -1100), SpawnTime = 15, RespawnTime = 30, Drops = {"Magma Axe", "Magma Ore"}, RequiredQuest = "Magma Chief", Island = "Magma Village"},
    {Name = "Vice Admiral", Level = 400, Sea = 1, Pos = CFrame.new(-4650, 25, -1950), SpawnTime = 15, RespawnTime = 30, Drops = {"Vice Admiral's Cap", "Cloak"}, RequiredQuest = "Vice Admiral", Island = "Marine Base"},
    {Name = "Swan", Level = 475, Sea = 1, Pos = CFrame.new(5200, 60, 760), SpawnTime = 15, RespawnTime = 30, Drops = {"Swan's Glasses", "Swan's Coat"}, RequiredQuest = "Swan", Island = "Prison"},
    {Name = "Shanda", Level = 100, Sea = 1, Pos = CFrame.new(4200, 50, 900), SpawnTime = 10, RespawnTime = 20, Drops = {"Golden Headband"}, RequiredQuest = "Shanda", Island = "Prison"},
    {Name = "Thunder God", Level = 575, Sea = 1, Pos = CFrame.new(2300, 400, -5500), SpawnTime = 20, RespawnTime = 45, Drops = {"Thunder Gem", "Electric Glove"}, RequiredQuest = "Thunder God", Island = "Upper Sky"},
    {Name = "Wysper", Level = 650, Sea = 1, Pos = CFrame.new(-4800, 750, -2500), SpawnTime = 20, RespawnTime = 45, Drops = {"Wysper's Microphone"}, RequiredQuest = "Wysper", Island = "Sky Island"},
    {Name = "Diamond", Level = 750, Sea = 2, Pos = CFrame.new(-1300, 115, 3600), SpawnTime = 15, RespawnTime = 30, Drops = {"Diamond's Necklace", "Gemstone"}, RequiredQuest = "Diamond", Island = "Kingdom of Roses"},
    {Name = "Jeremy", Level = 1425, Sea = 2, Pos = CFrame.new(-2800, 60, 1800), SpawnTime = 20, RespawnTime = 45, Drops = {"Jeremy's Blade", "Dark Coin"}, RequiredQuest = "Jeremy", Island = "Kingdom of Roses"},
    {Name = "Fajita", Level = 1450, Sea = 2, Pos = CFrame.new(-3100, 50, 1200), SpawnTime = 20, RespawnTime = 45, Drops = {"Fajita's Sword", "Gravity Stone"}, RequiredQuest = "Fajita", Island = "Rocky Shore"},
    {Name = "Don Swan", Level = 800, Sea = 2, Pos = CFrame.new(1050, 125, 1350), SpawnTime = 20, RespawnTime = 45, Drops = {"Swan's Glasses", "Swan's Coat"}, RequiredQuest = "Don Swan", Island = "Forgotten Island"},
    {Name = "Cyborg", Level = 1000, Sea = 2, Pos = CFrame.new(650, 10, -1100), SpawnTime = 20, RespawnTime = 45, Drops = {"Cyborg's Arm", "Core Brain"}, RequiredQuest = "Cyborg", Island = "Hot and Cold"},
    {Name = "Ice Admiral", Level = 1000, Sea = 2, Pos = CFrame.new(1500, 110, -2700), SpawnTime = 25, RespawnTime = 60, Drops = {"Ice Heart", "Frozen Dark Blade"}, RequiredQuest = "Ice Admiral", Island = "Frozen Castle"},
    {Name = "Island Empress", Level = 900, Sea = 2, Pos = CFrame.new(-1900, 65, 2650), SpawnTime = 20, RespawnTime = 45, Drops = {"Empress's Gown", "Queen's Charm"}, RequiredQuest = "Island Empress", Island = "Hot and Cold"},
    {Name = "Kilo Admiral", Level = 925, Sea = 2, Pos = CFrame.new(2250, 30, -6800), SpawnTime = 25, RespawnTime = 60, Drops = {"Kilo Fruit", "Admiral's Badge"}, RequiredQuest = "Kilo Admiral", Island = "Hot and Cold"},
    {Name = "Captain Elephant", Level = 950, Sea = 2, Pos = CFrame.new(2300, 35, -6750), SpawnTime = 25, RespawnTime = 60, Drops = {"Elephant Armor", "Captain's Hat"}, RequiredQuest = "Captain Elephant", Island = "Hot and Cold"},
    {Name = "Beautiful Pirate", Level = 975, Sea = 2, Pos = CFrame.new(2400, 40, -6600), SpawnTime = 30, RespawnTime = 60, Drops = {"Beautiful Pirate's Sword", "Golden Rose"}, RequiredQuest = "Beautiful Pirate", Island = "Hot and Cold"},
    {Name = "Magma Admiral", Level = 1200, Sea = 2, Pos = CFrame.new(-1800, 80, -2200), SpawnTime = 25, RespawnTime = 60, Drops = {"Magma Heart", "Admiral's Coat"}, RequiredQuest = "Magma Admiral", Island = "Magma Lake"},
    {Name = "Big Mom", Level = 1175, Sea = 2, Pos = CFrame.new(1550, 120, -2650), SpawnTime = 30, RespawnTime = 75, Drops = {"Soul Fruit", "Big Mom's Wig"}, RequiredQuest = "Big Mom", Island = "Frozen Castle"},
    {Name = "Smoke Admiral", Level = 1475, Sea = 2, Pos = CFrame.new(-2400, 45, 2000), SpawnTime = 25, RespawnTime = 60, Drops = {"Smoke Badge", "Admiral's Pipe"}, RequiredQuest = "Smoke Admiral", Island = "Hot and Cold"},
    {Name = "Awakened Ice Admiral", Level = 1500, Sea = 2, Pos = CFrame.new(1550, 115, -2650), SpawnTime = 30, RespawnTime = 75, Drops = {"Ice Heart Awakened", "Frozen Heart"}, RequiredQuest = "Awakened Ice Admiral", Island = "Frozen Castle"},
    {Name = "Order", Level = 1500, Sea = 2, Pos = CFrame.new(-2900, 40, 1400), SpawnTime = 30, RespawnTime = 75, Drops = {"Order's Sword", "Puzzle Key"}, RequiredQuest = "Order", Island = "Kingdom of Roses"},
    {Name = "Darkbeard", Level = 1550, Sea = 2, Pos = CFrame.new(3750, 15, -7000), SpawnTime = 35, RespawnTime = 90, Drops = {"Dark Dagger", "Dark Fragment"}, RequiredQuest = "Darkbeard", Island = "Dark Arena"},
    {Name = "Core Brain", Level = 1500, Sea = 2, Pos = CFrame.new(2500, 45, -6500), SpawnTime = 30, RespawnTime = 75, Drops = {"Core Brain", "Mechanical Heart"}, RequiredQuest = "Core Brain", Island = "Hot and Cold"},
    {Name = "Tide Keeper", Level = 1400, Sea = 2, Pos = CFrame.new(-1200, 10, -1400), SpawnTime = 25, RespawnTime = 60, Drops = {"Tide Keeper's Trident", "Sea Pearl"}, RequiredQuest = "Tide Keeper", Island = "Deep Sea"},
    {Name = "Rip Indra", Level = 1550, Sea = 3, Pos = CFrame.new(-5000, 300, 4000), SpawnTime = 45, RespawnTime = 120, Drops = {"Dark Fragment", "Valkyrie Helm"}, RequiredQuest = "Rip Indra", Island = "Floating Turtle"},
    {Name = "Stone", Level = 1825, Sea = 3, Pos = CFrame.new(-4700, 30, 6000), SpawnTime = 30, RespawnTime = 75, Drops = {"Stone's Blade", "Rock Heart"}, RequiredQuest = "Stone", Island = "Deep Fortress"},
    {Name = "Longma", Level = 2100, Sea = 3, Pos = CFrame.new(5650, 70, -1450), SpawnTime = 35, RespawnTime = 90, Drops = {"Longma's Sword", "Dragon Scale"}, RequiredQuest = "Longma", Island = "Dragon Dojo"},
    {Name = "Cake Prince", Level = 2150, Sea = 3, Pos = CFrame.new(-2050, 80, -1200), SpawnTime = 40, RespawnTime = 100, Drops = {"Dough Fruit", "Cake Prince's Crown"}, RequiredQuest = "Cake Prince", Island = "Magma Lake"},
    {Name = "Dough King", Level = 2200, Sea = 3, Pos = CFrame.new(-2000, 85, -1250), SpawnTime = 45, RespawnTime = 120, Drops = {"Dough Fruit Awakened", "King's Crown"}, RequiredQuest = "Dough King", Island = "Magma Lake"},
    {Name = "Island Champion", Level = 2050, Sea = 3, Pos = CFrame.new(4500, 30, -7500), SpawnTime = 30, RespawnTime = 75, Drops = {"Champion's Belt", "Island Heart"}, RequiredQuest = "Island Champion", Island = "Turtle Mansion"},
    {Name = "Great Tree", Level = 2400, Sea = 3, Pos = CFrame.new(-4900, 400, 5000), SpawnTime = 50, RespawnTime = 150, Drops = {"Kitsune Ribbon", "Tushita"}, RequiredQuest = "Great Tree", Island = "Floating Turtle"},
    {Name = "Body of Water", Level = 2350, Sea = 3, Pos = CFrame.new(3200, 5, -6900), SpawnTime = 45, RespawnTime = 120, Drops = {"Water Key", "Sea Essence"}, RequiredQuest = "Body of Water", Island = "Deep Fortress"},
    {Name = "Soul Guitar User", Level = 2425, Sea = 3, Pos = CFrame.new(4200, 30, -7200), SpawnTime = 40, RespawnTime = 100, Drops = {"Soul Guitar", "Soul Essence"}, RequiredQuest = "Soul Guitar User", Island = "Haunted Castle"},
    {Name = "Fearful Ghost", Level = 2050, Sea = 3, Pos = CFrame.new(-5400, 50, -6700), SpawnTime = 30, RespawnTime = 75, Drops = {"Ghost ectoplasm", "Spectral Cloak"}, RequiredQuest = "Fearful Ghost", Island = "Haunted Castle"},
}

A.Quests.Materials = {
    {Name = "Magma Ore", Level = 250, Pos = CFrame.new(-2100, 70, -1000), Mobs = {"Fire Thrower", "Fire Soldier"}, Island = "Magma Village", Sea = 1},
    {Name = "Leather", Level = 30, Pos = CFrame.new(1059, 17, 1531), Mobs = {"Bandit", "Pirate"}, Island = "Starter Island", Sea = 1},
    {Name = "Scrap Metal", Level = 90, Pos = CFrame.new(4850, 50, 750), Mobs = {"Prisoner", "Chief Guard"}, Island = "Prison", Sea = 1},
    {Name = "Angel Wings", Level = 75, Pos = CFrame.new(-4950, 700, -2500), Mobs = {"Sky Bandit", "Dark Master"}, Island = "Sky Island", Sea = 1},
    {Name = "Fish Tail", Level = 175, Pos = CFrame.new(3695, 10, -1950), Mobs = {"Fishman Warrior", "Fishman Chief"}, Island = "Underwater City", Sea = 1},
    {Name = "Mystic Droplet", Level = 525, Pos = CFrame.new(3800, 10, -1800), Mobs = {"Fishman Raider", "Fishman Captain"}, Island = "Underwater City", Sea = 1},
    {Name = "Vampire Fang", Level = 1650, Pos = CFrame.new(-5750, 15, -6350), Mobs = {"Vampire"}, Island = "Haunted Castle", Sea = 3},
    {Name = "Dragon Scale", Level = 1625, Pos = CFrame.new(5900, 60, -1400), Mobs = {"Dragon Crew Recruit", "Dragon Crew Warrior"}, Island = "Dragon Dojo", Sea = 3},
    {Name = "Fool's Gold", Level = 725, Pos = CFrame.new(-1350, 110, 3550), Mobs = {"Raider", "Mercenary"}, Island = "Kingdom of Roses", Sea = 2},
    {Name = "Conjured Cocoa", Level = 800, Pos = CFrame.new(-2650, 75, -1050), Mobs = {"Factory Staff", "Factory Staff Elite"}, Island = "Green Zone", Sea = 2},
    {Name = "Large Bone", Level = 1600, Pos = CFrame.new(-5800, 10, -6300), Mobs = {"Zombie", "Cursed Skeleton"}, Island = "Haunted Castle", Sea = 3},
    {Name = "Mystic Droplet Sea2", Level = 1100, Pos = CFrame.new(-1100, 10, -1500), Mobs = {"Fishman Raider", "Fishman Captain"}, Island = "Deep Sea", Sea = 2},
    {Name = "Dragon Scale Sea2", Level = 1300, Pos = CFrame.new(5800, 50, -1200), Mobs = {"Dragon Crew Warrior", "Dragon Crew Archer"}, Island = "Dragon Dojo", Sea = 2},
    {Name = "Angel Wings Sea3", Level = 1700, Pos = CFrame.new(-5700, 20, -6400), Mobs = {"Demonic Soul", "Ghost"}, Island = "Haunted Castle", Sea = 3},
    {Name = "Scrap Metal Sea2", Level = 850, Pos = CFrame.new(-2050, 50, 2500), Mobs = {"Marine Lieutenant", "Marine Captain"}, Island = "Hot and Cold", Sea = 2},
    {Name = "Magma Ore Sea2", Level = 1200, Pos = CFrame.new(-1800, 80, -2200), Mobs = {"Tiki Outpost Pirate", "Tiki Outpost Soldier"}, Island = "Tiki Outpost", Sea = 2},
    {Name = "Leather Sea2", Level = 700, Pos = CFrame.new(-1400, 100, 3500), Mobs = {"Raider", "Mercenary"}, Island = "Kingdom of Roses", Sea = 2},
    {Name = "Fish Tail Sea3", Level = 2000, Pos = CFrame.new(3000, 10, -7000), Mobs = {"Frozen Flight", "Water Warrior"}, Island = "Deep Fortress", Sea = 3},
    {Name = "Frozen Heart", Level = 2000, Pos = CFrame.new(4450, 25, -7450), Mobs = {"Frozen Warrior", "Frozen Flight"}, Island = "Turtle Mansion", Sea = 3},
    {Name = "Cursed Cloth", Level = 1850, Pos = CFrame.new(-5550, 35, -6550), Mobs = {"Cursed Skeleton", "Reborn Skeleton"}, Island = "Haunted Castle", Sea = 3},
    {Name = "Ectoplasm", Level = 1900, Pos = CFrame.new(-5500, 40, -6600), Mobs = {"Ghost", "Reborn Skeleton"}, Island = "Haunted Castle", Sea = 3},
    {Name = "Dark Fragment", Level = 1550, Pos = CFrame.new(3750, 15, -7000), Mobs = {"Darkbeard"}, Island = "Dark Arena", Sea = 2},
    {Name = "Fire Essence", Level = 1200, Pos = CFrame.new(-1800, 80, -2200), Mobs = {"Magma Admiral"}, Island = "Magma Lake", Sea = 2},
    {Name = "Obsidian", Level = 1800, Pos = CFrame.new(-4750, 25, 5950), Mobs = {"Stone Guard", "Stone"}, Island = "Deep Fortress", Sea = 3},
}

A.Quests.IslandQuests = {
    ["Starter Island"] = {"Bandit Quest"},
    ["Jungle"] = {"Monkey Quest", "Gorilla Quest"},
    ["Pirate Village"] = {"Pirate Beginner", "Pirate Soldier", "Brute"},
    ["Desert"] = {"Desert Bandit", "Desert Officer"},
    ["Frozen Village"] = {"Snow Bandit", "Snowman", "Winter Bandit", "Frozen Bandit", "Yeti"},
    ["Sky Island"] = {"Sky Bandit", "Dark Master", "God's Guard"},
    ["Prison"] = {"Prisoner", "Chief Guard", "Shanda", "Warden", "Chief Warden", "Swan"},
    ["Colosseum"] = {"Royal Squad", "Royal Soldier"},
    ["Marine Fortress"] = {"Military Soldier", "Military Spy", "Military Captain"},
    ["Underwater City"] = {"Fishman Warrior", "Fishman Chief", "Fishman Raider", "Fishman Captain"},
    ["Magma Village"] = {"Fire Thrower", "Fire Soldier", "Magma Chief"},
    ["Orange Town"] = {"Buggy"},
    ["Rocky Shore"] = {"Giant Island Captain", "Fajita"},
    ["Marine Base"] = {"Vice Admiral"},
    ["Upper Sky"] = {"Thunder God"},
    ["Fountain Island"] = {"Bored Captain", "Shanks"},
    ["Kingdom of Roses"] = {"Raider", "Mercenary", "Diamond", "Lost Soul", "Dangerous Enemy", "Rogue Pirate"},
    ["Forgotten Island"] = {"Swan Pirate", "Don Swan", "Forgotten Soldier", "Sunker Pirate"},
    ["Green Zone"] = {"Factory Staff", "Factory Staff Elite"},
    ["Hot and Cold"] = {"Marine Lieutenant", "Marine Captain", "Ship Officer", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Smoke Admiral", "Awakened Ice Admiral", "Order", "Core Brain", "Man and His Brother", "Clueless Pirate"},
    ["Frozen Castle"] = {"Ice Admiral", "Arctic Explorer", "Big Mom"},
    ["Deep Sea"] = {"Fishman Raider", "Fishman Captain", "Tide Keeper"},
    ["Tiki Outpost"] = {"Tiki Outpost Pirate", "Tiki Outpost Soldier", "Tiki Outpost Elite"},
    ["Dragon Dojo"] = {"Dragon Crew Warrior", "Dragon Crew Archer", "Oni", "Longma", "Red Dragon", "Electric Dragon"},
    ["Dark Arena"] = {"Darkbeard"},
    ["Floating Turtle"] = {"Royal Guard", "Royal Soldier", "Pistol Billionaire", "Helmet Chaos", "Peaches", "Royal Squad Sea3", "Royal Soldier Sea3", "Kaffed", "Rip Indra", "Great Tree"},
    ["Deep Fortress"] = {"Reef High Guard", "Seat Kingdom Guard", "Reef Pirate", "Stone Guard", "Stone", "Body of Water", "Frozen Flight"},
    ["Turtle Mansion"] = {"Water Warrior", "Water Fighter", "Sea Soldier", "Frozen Warrior", "Island Champion"},
    ["Haunted Castle"] = {"Zombie", "Vampire", "Demonic Soul", "Living Zombie", "Possessed Mummy", "Cursed Skeleton", "Ghost", "Reborn Skeleton", "Fearful Ghost", "Chief of Staff", "Soul Guitar User"},
    ["Magma Lake"] = {"Magma Admiral", "Cake Prince", "Dough King"},
}

A.Quests.DifficultyRating = {
    ["Bandit Quest"] = 1,
    ["Monkey Quest"] = 1,
    ["Gorilla Quest"] = 2,
    ["Pirate Beginner"] = 1,
    ["Pirate Soldier"] = 2,
    ["Brute"] = 2,
    ["Desert Bandit"] = 3,
    ["Desert Officer"] = 3,
    ["Snow Bandit"] = 3,
    ["Snowman"] = 3,
    ["Winter Bandit"] = 4,
    ["Sky Bandit"] = 4,
    ["Dark Master"] = 5,
    ["Prisoner"] = 4,
    ["Chief Guard"] = 5,
    ["Shanda"] = 6,
    ["Royal Squad"] = 6,
    ["Royal Soldier"] = 7,
    ["Military Soldier"] = 6,
    ["Military Spy"] = 7,
    ["Fishman Warrior"] = 7,
    ["Fishman Chief"] = 8,
    ["Frozen Bandit"] = 8,
    ["Yeti"] = 9,
    ["Fire Thrower"] = 9,
    ["Fire Soldier"] = 9,
    ["Magma Chief"] = 10,
    ["Buggy"] = 10,
    ["Giant Island Captain"] = 11,
    ["Vice Admiral"] = 12,
    ["Warden"] = 12,
    ["Chief Warden"] = 13,
    ["Swan"] = 14,
    ["Military Captain"] = 13,
    ["Fishman Raider"] = 14,
    ["Fishman Captain"] = 15,
    ["Thunder God"] = 16,
    ["Sky Enemy"] = 15,
    ["God's Guard"] = 15,
    ["Wysper"] = 17,
    ["Bored Captain"] = 16,
    ["Shanks"] = 18,
    ["Raider"] = 12,
    ["Mercenary"] = 12,
    ["Diamond"] = 13,
    ["Swan Pirate"] = 14,
    ["Don Swan"] = 15,
    ["Factory Staff"] = 14,
    ["Factory Staff Elite"] = 15,
    ["Marine Lieutenant"] = 15,
    ["Marine Captain"] = 16,
    ["Ship Officer"] = 16,
    ["Island Empress"] = 17,
    ["Kilo Admiral"] = 18,
    ["Captain Elephant"] = 19,
    ["Beautiful Pirate"] = 20,
    ["Ice Admiral"] = 20,
    ["Cyborg"] = 21,
    ["Fishman Raider Sea2"] = 22,
    ["Fishman Captain Sea2"] = 22,
    ["Arctic Explorer"] = 23,
    ["Big Mom"] = 24,
    ["Magma Admiral"] = 24,
    ["Tiki Outpost Pirate"] = 25,
    ["Tiki Outpost Soldier"] = 25,
    ["Tiki Outpost Elite"] = 26,
    ["Dragon Crew Warrior"] = 26,
    ["Dragon Crew Archer"] = 27,
    ["Oni"] = 28,
    ["Diamond Sea2"] = 28,
    ["Jeremy"] = 29,
    ["Fajita"] = 30,
    ["Smoke Admiral"] = 30,
    ["Awakened Ice Admiral"] = 32,
    ["Order"] = 33,
    ["Darkbeard"] = 35,
    ["Core Brain"] = 32,
    ["Tide Keeper"] = 30,
    ["Rip Indra"] = 38,
    ["Royal Guard"] = 35,
    ["Royal Soldier Sea3"] = 35,
    ["Pistol Billionaire"] = 36,
    ["Dragon Crew Recruit"] = 36,
    ["Helmet Chaos"] = 37,
    ["Peaches"] = 38,
    ["Reef High Guard"] = 39,
    ["Seat Kingdom Guard"] = 40,
    ["Reef Pirate"] = 39,
    ["Stone Guard"] = 41,
    ["Stone"] = 42,
    ["Royal Squad Sea3"] = 40,
    ["Kaffed"] = 42,
    ["Water Warrior"] = 44,
    ["Water Fighter"] = 45,
    ["Sea Soldier"] = 46,
    ["Frozen Warrior"] = 47,
    ["Island Champion"] = 48,
    ["Longma"] = 50,
    ["Cake Prince"] = 52,
    ["Dough King"] = 55,
    ["Red Dragon"] = 53,
    ["Electric Dragon"] = 54,
    ["Body of Water"] = 56,
    ["Great Tree"] = 58,
    ["Soul Guitar User"] = 60,
    ["Fearful Ghost"] = 48,
    ["Zombie"] = 36,
    ["Vampire"] = 37,
    ["Demonic Soul"] = 39,
    ["Living Zombie"] = 40,
    ["Possessed Mummy"] = 42,
    ["Cursed Skeleton"] = 43,
    ["Ghost"] = 44,
    ["Reborn Skeleton"] = 46,
    ["Frozen Flight"] = 47,
    ["Chief of Staff"] = 50,
}

A.Quests.XPRate = {
    ["Bandit Quest"] = 50,
    ["Monkey Quest"] = 150,
    ["Gorilla Quest"] = 240,
    ["Pirate Beginner"] = 350,
    ["Pirate Soldier"] = 450,
    ["Brute"] = 550,
    ["Desert Bandit"] = 800,
    ["Desert Officer"] = 1000,
    ["Snow Bandit"] = 1200,
    ["Snowman"] = 1300,
    ["Winter Bandit"] = 1400,
    ["Sky Bandit"] = 1800,
    ["Dark Master"] = 2200,
    ["Prisoner"] = 2400,
    ["Chief Guard"] = 2700,
    ["Shanda"] = 3000,
    ["Royal Squad"] = 4000,
    ["Royal Soldier"] = 5000,
    ["Military Soldier"] = 5200,
    ["Military Spy"] = 5500,
    ["Fishman Warrior"] = 6000,
    ["Fishman Chief"] = 6400,
    ["Frozen Bandit"] = 7600,
    ["Yeti"] = 9000,
    ["Fire Thrower"] = 10000,
    ["Fire Soldier"] = 10600,
    ["Magma Chief"] = 11600,
    ["Buggy"] = 16000,
    ["Giant Island Captain"] = 18000,
    ["Vice Admiral"] = 21000,
    ["Warden"] = 24000,
    ["Chief Warden"] = 27000,
    ["Swan"] = 30000,
    ["Military Captain"] = 34000,
    ["Fishman Raider"] = 38000,
    ["Fishman Captain"] = 42000,
    ["Thunder God"] = 48000,
    ["Sky Enemy"] = 50000,
    ["God's Guard"] = 54000,
    ["Wysper"] = 64000,
    ["Bored Captain"] = 66000,
    ["Shanks"] = 80000,
    ["Raider"] = 84000,
    ["Mercenary"] = 88000,
    ["Diamond"] = 96000,
    ["Swan Pirate"] = 100000,
    ["Don Swan"] = 110000,
    ["Factory Staff"] = 106000,
    ["Factory Staff Elite"] = 112000,
    ["Marine Lieutenant"] = 116000,
    ["Marine Captain"] = 122000,
    ["Ship Officer"] = 124000,
    ["Island Empress"] = 132000,
    ["Kilo Admiral"] = 140000,
    ["Captain Elephant"] = 150000,
    ["Beautiful Pirate"] = 160000,
    ["Ice Admiral"] = 170000,
    ["Cyborg"] = 180000,
    ["Fishman Raider Sea2"] = 190000,
    ["Fishman Captain Sea2"] = 200000,
    ["Arctic Explorer"] = 210000,
    ["Big Mom"] = 220000,
    ["Magma Admiral"] = 230000,
    ["Tiki Outpost Pirate"] = 240000,
    ["Tiki Outpost Soldier"] = 250000,
    ["Tiki Outpost Elite"] = 260000,
    ["Dragon Crew Warrior"] = 280000,
    ["Dragon Crew Archer"] = 290000,
    ["Oni"] = 300000,
    ["Jeremy"] = 320000,
    ["Fajita"] = 330000,
    ["Smoke Admiral"] = 340000,
    ["Awakened Ice Admiral"] = 350000,
    ["Order"] = 360000,
    ["Darkbeard"] = 400000,
    ["Core Brain"] = 370000,
    ["Tide Keeper"] = 320000,
    ["Rip Indra"] = 500000,
    ["Royal Guard"] = 420000,
    ["Royal Soldier Sea3"] = 440000,
    ["Pistol Billionaire"] = 460000,
    ["Dragon Crew Recruit"] = 480000,
    ["Helmet Chaos"] = 520000,
    ["Peaches"] = 550000,
    ["Reef High Guard"] = 570000,
    ["Seat Kingdom Guard"] = 590000,
    ["Reef Pirate"] = 610000,
    ["Stone Guard"] = 640000,
    ["Stone"] = 670000,
    ["Kaffed"] = 740000,
    ["Water Warrior"] = 760000,
    ["Water Fighter"] = 790000,
    ["Sea Soldier"] = 820000,
    ["Frozen Warrior"] = 850000,
    ["Island Champion"] = 920000,
    ["Longma"] = 1000000,
    ["Cake Prince"] = 1060000,
    ["Dough King"] = 1120000,
    ["Red Dragon"] = 1150000,
    ["Electric Dragon"] = 1180000,
    ["Body of Water"] = 1300000,
    ["Great Tree"] = 1360000,
    ["Soul Guitar User"] = 1400000,
    ["Fearful Ghost"] = 920000,
    ["Zombie"] = 460000,
    ["Vampire"] = 500000,
    ["Demonic Soul"] = 550000,
    ["Living Zombie"] = 590000,
    ["Possessed Mummy"] = 640000,
    ["Cursed Skeleton"] = 690000,
    ["Ghost"] = 740000,
    ["Reborn Skeleton"] = 790000,
    ["Frozen Flight"] = 850000,
    ["Chief of Staff"] = 1000000,
}

A.Questsfunctions = {}

local function GetAllQuests()
    local all = {}
    for _, quest in ipairs(A.Quests.Sea1) do
        table.insert(all, quest)
    end
    for _, quest in ipairs(A.Quests.Sea2) do
        table.insert(all, quest)
    end
    for _, quest in ipairs(A.Quests.Sea3) do
        table.insert(all, quest)
    end
    return all
end

local function GetSeaForLevel(level)
    if level >= 1550 then
        return 3
    elseif level >= 700 then
        return 2
    else
        return 1
    end
end

local function GetSeaTable(sea)
    if sea == 1 then
        return A.Quests.Sea1
    elseif sea == 2 then
        return A.Quests.Sea2
    elseif sea == 3 then
        return A.Quests.Sea3
    end
    return {}
end

function A.Questsfunctions.GetQuestForLevel(level)
    local sea = GetSeaForLevel(level)
    local quests = GetSeaTable(sea)
    local bestQuest = nil
    local bestDiff = math.huge
    for _, quest in ipairs(quests) do
        local diff = level - quest.Level
        if diff >= 0 and diff < bestDiff then
            bestDiff = diff
            bestQuest = quest
        end
    end
    if not bestQuest then
        for _, quest in ipairs(quests) do
            if quest.Level <= level then
                bestQuest = quest
            end
        end
    end
    return bestQuest
end

function A.Questsfunctions.GetClosestQuest(level)
    local playerPos = nil
    if game and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            playerPos = hrp.Position
        end
    end
    if not playerPos then
        return A.Questsfunctions.GetQuestForLevel(level)
    end
    local allQuests = {}
    local sea = GetSeaForLevel(level)
    local quests = GetSeaTable(sea)
    for _, quest in ipairs(quests) do
        if quest.Level <= level then
            table.insert(allQuests, quest)
        end
    end
    if #allQuests == 0 then
        return nil
    end
    local closest = nil
    local closestDist = math.huge
    for _, quest in ipairs(allQuests) do
        if quest.Pos then
            local dist = (quest.Pos.Position - playerPos).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = quest
            end
        end
    end
    return closest
end

function A.Questsfunctions.GetQuestData(questName)
    local allQuests = GetAllQuests()
    for _, quest in ipairs(allQuests) do
        if quest.Q == questName or quest.Enemy == questName then
            return quest
        end
    end
    return nil
end

function A.Questsfunctions.GetQuestMobs(questName)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if questData then
        return {Name = questData.M, Pos = questData.Pos}
    end
    return nil
end

function A.Questsfunctions.GetQuestReward(questName)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if questData then
        return questData.Reward
    end
    return 0
end

function A.Questsfunctions.GetQuestRegion(questName)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if questData then
        return questData.Region
    end
    return "Unknown"
end

function A.Questsfunctions.GetBossQuest(bossName)
    for _, boss in ipairs(A.Quests.Bosses) do
        if boss.Name == bossName then
            return boss
        end
    end
    return nil
end

function A.Questsfunctions.GetBossForLevel(level)
    local sea = GetSeaForLevel(level)
    local bestBoss = nil
    local bestDiff = math.huge
    for _, boss in ipairs(A.Quests.Bosses) do
        if boss.Sea == sea then
            local diff = level - boss.Level
            if diff >= 0 and diff < bestDiff then
                bestDiff = diff
                bestBoss = boss
            end
        end
    end
    if not bestBoss then
        for _, boss in ipairs(A.Quests.Bosses) do
            if boss.Sea == sea and boss.Level <= level then
                bestBoss = boss
            end
        end
    end
    return bestBoss
end

function A.Questsfunctions.GetAllBosses(sea)
    local bosses = {}
    for _, boss in ipairs(A.Quests.Bosses) do
        if boss.Sea == sea then
            table.insert(bosses, boss)
        end
    end
    return bosses
end

function A.Questsfunctions.GetMaterialQuest(materialName)
    for _, mat in ipairs(A.Quests.Materials) do
        if mat.Name == materialName then
            return mat
        end
    end
    return nil
end

function A.Questsfunctions.GetClosestMaterialQuest(pos)
    if not pos then
        return nil
    end
    local closest = nil
    local closestDist = math.huge
    for _, mat in ipairs(A.Quests.Materials) do
        if mat.Pos then
            local dist = (mat.Pos.Position - pos).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = mat
            end
        end
    end
    return closest
end

function A.Questsfunctions.GetQuestLevelRange(questName)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if questData then
        return questData.Level, questData.Level + 50
    end
    return 0, 0
end

function A.Questsfunctions.GetOptimalQuest(level)
    local allQuests = {}
    local sea = GetSeaForLevel(level)
    local quests = GetSeaTable(sea)
    for _, quest in ipairs(quests) do
        if quest.Level <= level and quest.Level >= level - 50 then
            table.insert(allQuests, quest)
        end
    end
    if #allQuests == 0 then
        for _, quest in ipairs(quests) do
            if quest.Level <= level then
                table.insert(allQuests, quest)
            end
        end
    end
    if #allQuests == 0 then
        return nil
    end
    local bestQuest = nil
    local bestXP = 0
    for _, quest in ipairs(allQuests) do
        local xpRate = A.Quests.XPRate[quest.Q] or quest.Reward
        if xpRate > bestXP then
            bestXP = xpRate
            bestQuest = quest
        end
    end
    return bestQuest
end

function A.Questsfunctions.GetNextQuest(level)
    local allQuests = {}
    local sea = GetSeaForLevel(level)
    local quests = GetSeaTable(sea)
    for _, quest in ipairs(quests) do
        if quest.Level > level then
            table.insert(allQuests, quest)
        end
    end
    if #allQuests == 0 then
        local nextSea = sea + 1
        if nextSea <= 3 then
            local nextQuests = GetSeaTable(nextSea)
            if #nextQuests > 0 then
                return nextQuests[1]
            end
        end
        return nil
    end
    table.sort(allQuests, function(a, b)
        return a.Level < b.Level
    end)
    return allQuests[1]
end

function A.Questsfunctions.IsQuestAvailable(questName, level)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if not questData then
        return false
    end
    return level >= questData.Level
end

function A.Questsfunctions.GetQuestProgress(questName)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if not questData then
        return {Current = 0, Required = 0, Complete = false}
    end
    local required = 0
    if questData.Type == "Kill" then
        required = math.ceil((questData.Level / 10) + 3)
    elseif questData.Type == "Boss" then
        required = 1
    elseif questData.Type == "Collect" then
        required = math.ceil((questData.Level / 5) + 5)
    elseif questData.Type == "Delivery" then
        required = math.ceil((questData.Level / 8) + 2)
    else
        required = math.ceil((questData.Level / 10) + 3)
    end
    local current = 0
    if game and game.Players and game.Players.LocalPlayer then
        local leaderstats = game.Players.LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            local questVal = leaderstats:FindFirstChild("Quest" .. questName:gsub("%s+", ""))
            if questVal then
                current = questVal.Value
            end
        end
    end
    return {Current = current, Required = required, Complete = current >= required}
end

A.Questsfunctions = A.Questsfunctions

A.Quests.Sea1Data = {
    ["Starter Island"] = {
        LevelRange = {Min = 1, Max = 14},
        NpcPos = CFrame.new(1060, 18, 1532),
        QuestGiver = "Quest Giver",
        Description = "Starting area for all new players",
        Difficulty = "Beginner",
        RecommendedBeli = 500,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(1060, 18, 1532), Dialog = "Welcome to the sea!"},
        },
        Mobs = {
            {Name = "Bandit", Level = 1, Pos = CFrame.new(1059, 17, 1531), Health = 100, Damage = 5},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(1060, 20, 1540),
    },
    ["Jungle"] = {
        LevelRange = {Min = 14, Max = 20},
        NpcPos = CFrame.new(-1580, 300, -140),
        QuestGiver = "Jungle Quest Giver",
        Description = "Tropical jungle filled with monkeys",
        Difficulty = "Easy",
        RecommendedBeli = 2000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1580, 300, -140), Dialog = "Beware the apes!"},
        },
        Mobs = {
            {Name = "Monkey", Level = 14, Pos = CFrame.new(-1597, 300, -125), Health = 200, Damage = 10},
            {Name = "Gorilla", Level = 20, Pos = CFrame.new(-1230, 60, -485), Health = 350, Damage = 18},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-1580, 302, -130),
    },
    ["Pirate Village"] = {
        LevelRange = {Min = 25, Max = 55},
        NpcPos = CFrame.new(5810, 21, 902),
        QuestGiver = "Pirate Quest Giver",
        Description = "Rough pirate town full of outlaws",
        Difficulty = "Easy",
        RecommendedBeli = 5000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(5810, 21, 902), Dialog = "Yo matey!"},
            {Name = "Sword Dealer", Pos = CFrame.new(5820, 21, 890), Dialog = "Best blades in town!"},
        },
        Mobs = {
            {Name = "Pirate", Level = 25, Pos = CFrame.new(5811, 20, 901), Health = 300, Damage = 12},
            {Name = "Pirate Soldier", Level = 30, Pos = CFrame.new(5285, 35, 1050), Health = 400, Damage = 15},
            {Name = "Brute", Level = 35, Pos = CFrame.new(5350, 30, 1100), Health = 500, Damage = 20},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(5812, 22, 905),
    },
    ["Desert"] = {
        LevelRange = {Min = 45, Max = 60},
        NpcPos = CFrame.new(1007, 16, 4161),
        QuestGiver = "Desert Quest Giver",
        Description = "Scorching desert with bandit camps",
        Difficulty = "Medium",
        RecommendedBeli = 10000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(1007, 16, 4161), Dialog = "The desert is unforgiving..."},
        },
        Mobs = {
            {Name = "Desert Bandit", Level = 45, Pos = CFrame.new(1006, 15, 4160), Health = 600, Damage = 22},
            {Name = "Desert Officer", Level = 50, Pos = CFrame.new(1100, 25, 4260), Health = 750, Damage = 28},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(1008, 18, 4165),
    },
    ["Frozen Village"] = {
        LevelRange = {Min = 55, Max = 225},
        NpcPos = CFrame.new(1338, 101, -1551),
        QuestGiver = "Frozen Village Quest Giver",
        Description = "Icy tundra with powerful snow creatures",
        Difficulty = "Medium",
        RecommendedBeli = 25000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(1338, 101, -1551), Dialog = "Bundle up..."},
            {Name = "Sword Dealer", Pos = CFrame.new(1340, 101, -1548), Dialog = "Frozen blades!"},
        },
        Mobs = {
            {Name = "Snow Bandit", Level = 55, Pos = CFrame.new(1338, 100, -1550), Health = 800, Damage = 25},
            {Name = "Snowman", Level = 60, Pos = CFrame.new(1350, 110, -1500), Health = 900, Damage = 30},
            {Name = "Winter Bandit", Level = 65, Pos = CFrame.new(1400, 100, -1600), Health = 1000, Damage = 35},
            {Name = "Frozen Bandit", Level = 200, Pos = CFrame.new(1200, 100, -1800), Health = 3500, Damage = 80},
            {Name = "Yeti", Level = 225, Pos = CFrame.new(1150, 110, -1900), Health = 5000, Damage = 100},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(1340, 102, -1545),
    },
    ["Sky Island"] = {
        LevelRange = {Min = 75, Max = 100},
        NpcPos = CFrame.new(-4950, 701, -2501),
        QuestGiver = "Sky Quest Giver",
        Description = "Floating islands in the clouds",
        Difficulty = "Hard",
        RecommendedBeli = 50000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-4950, 701, -2501), Dialog = "Look at the sky!"},
            {Name = "Sword Dealer", Pos = CFrame.new(-4945, 701, -2498), Dialog = "Heavenly blades!"},
        },
        Mobs = {
            {Name = "Sky Bandit", Level = 75, Pos = CFrame.new(-4950, 700, -2500), Health = 1200, Damage = 40},
            {Name = "Dark Master", Level = 85, Pos = CFrame.new(-4800, 650, -2400), Health = 1500, Damage = 50},
            {Name = "God's Guard", Level = 600, Pos = CFrame.new(-4750, 700, -2600), Health = 15000, Damage = 200},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = false,
        HasFruitDealer = true,
        SpawnPoint = CFrame.new(-4948, 703, -2495),
    },
    ["Prison"] = {
        LevelRange = {Min = 90, Max = 500},
        NpcPos = CFrame.new(4851, 51, 751),
        QuestGiver = "Prison Quest Giver",
        Description = "Maximum security prison island",
        Difficulty = "Hard",
        RecommendedBeli = 75000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(4851, 51, 751), Dialog = "No escape..."},
        },
        Mobs = {
            {Name = "Prisoner", Level = 90, Pos = CFrame.new(4850, 50, 750), Health = 1800, Damage = 55},
            {Name = "Chief Guard", Level = 95, Pos = CFrame.new(4950, 50, 800), Health = 2000, Damage = 60},
            {Name = "Shanda", Level = 100, Pos = CFrame.new(4200, 50, 900), Health = 3000, Damage = 70},
            {Name = "Warden", Level = 425, Pos = CFrame.new(5100, 50, 680), Health = 8000, Damage = 120},
            {Name = "Chief Warden", Level = 450, Pos = CFrame.new(5150, 55, 720), Health = 10000, Damage = 140},
            {Name = "Swan", Level = 475, Pos = CFrame.new(5200, 60, 760), Health = 15000, Damage = 160},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(4852, 53, 755),
    },
    ["Colosseum"] = {
        LevelRange = {Min = 125, Max = 175},
        NpcPos = CFrame.new(-3900, 121, 5701),
        QuestGiver = "Colosseum Quest Giver",
        Description = "Ancient gladiator arena",
        Difficulty = "Hard",
        RecommendedBeli = 100000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-3900, 121, 5701), Dialog = "Fight for glory!"},
        },
        Mobs = {
            {Name = "Royal Squad", Level = 125, Pos = CFrame.new(-3900, 120, 5700), Health = 3000, Damage = 75},
            {Name = "Royal Soldier", Level = 150, Pos = CFrame.new(-3850, 130, 5750), Health = 4000, Damage = 90},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-3898, 123, 5705),
    },
    ["Marine Fortress"] = {
        LevelRange = {Min = 155, Max = 550},
        NpcPos = CFrame.new(-4200, 31, 4301),
        QuestGiver = "Marine Quest Giver",
        Description = "Heavily fortified marine base",
        Difficulty = "Hard",
        RecommendedBeli = 120000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-4200, 31, 4301), Dialog = "For justice!"},
        },
        Mobs = {
            {Name = "Military Soldier", Level = 155, Pos = CFrame.new(-4200, 30, 4300), Health = 4200, Damage = 95},
            {Name = "Military Spy", Level = 160, Pos = CFrame.new(-4150, 35, 4350), Health = 4500, Damage = 100},
            {Name = "Military Captain", Level = 500, Pos = CFrame.new(-4400, 30, 4200), Health = 12000, Damage = 175},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-4198, 33, 4305),
    },
    ["Underwater City"] = {
        LevelRange = {Min = 175, Max = 600},
        NpcPos = CFrame.new(3696, 11, -1951),
        QuestGiver = "Underwater Quest Giver",
        Description = "Submerged city of fishmen",
        Difficulty = "Extreme",
        RecommendedBeli = 150000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(3696, 11, -1951), Dialog = "Glub glub..."},
        },
        Mobs = {
            {Name = "Fishman Warrior", Level = 175, Pos = CFrame.new(3695, 10, -1950), Health = 5000, Damage = 110},
            {Name = "Fishman Chief", Level = 185, Pos = CFrame.new(3700, 15, -1900), Health = 5500, Damage = 120},
            {Name = "Fishman Raider", Level = 525, Pos = CFrame.new(3800, 10, -1800), Health = 14000, Damage = 200},
            {Name = "Fishman Captain", Level = 550, Pos = CFrame.new(3850, 15, -1750), Health = 16000, Damage = 220},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(3698, 13, -1945),
    },
    ["Magma Village"] = {
        LevelRange = {Min = 250, Max = 300},
        NpcPos = CFrame.new(-2101, 71, -1001),
        QuestGiver = "Magma Quest Giver",
        Description = "Volcanic region with lava pools",
        Difficulty = "Extreme",
        RecommendedBeli = 200000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-2101, 71, -1001), Dialog = "Don't touch the lava!"},
        },
        Mobs = {
            {Name = "Fire Thrower", Level = 250, Pos = CFrame.new(-2100, 70, -1000), Health = 6500, Damage = 130},
            {Name = "Fire Soldier", Level = 260, Pos = CFrame.new(-2050, 75, -1050), Health = 7000, Damage = 140},
            {Name = "Magma Chief", Level = 275, Pos = CFrame.new(-2000, 80, -1100), Health = 10000, Damage = 160},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-2098, 73, -995),
    },
    ["Orange Town"] = {
        LevelRange = {Min = 350, Max = 375},
        NpcPos = CFrame.new(-1151, 31, 1601),
        QuestGiver = "Town Quest Giver",
        Description = "Small peaceful town ruled by Buggy",
        Difficulty = "Very Hard",
        RecommendedBeli = 350000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1151, 31, 1601), Dialog = "Help us!"},
        },
        Mobs = {
            {Name = "Buggy", Level = 350, Pos = CFrame.new(-1150, 30, 1600), Health = 20000, Damage = 200},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-1148, 33, 1605),
    },
    ["Rocky Shore"] = {
        LevelRange = {Min = 375, Max = 450},
        NpcPos = CFrame.new(-1651, 101, -4701),
        QuestGiver = "Shore Quest Giver",
        Description = "Rocky coastline with dangerous enemies",
        Difficulty = "Very Hard",
        RecommendedBeli = 400000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1651, 101, -4701), Dialog = "Watch the waves!"},
        },
        Mobs = {
            {Name = "Giant Island Captain", Level = 375, Pos = CFrame.new(-1650, 100, -4700), Health = 9000, Damage = 110},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-1648, 103, -4695),
    },
    ["Marine Base"] = {
        LevelRange = {Min = 400, Max = 425},
        NpcPos = CFrame.new(-4651, 26, -1951),
        QuestGiver = "Base Quest Giver",
        Description = "Reinforced marine outpost",
        Difficulty = "Very Hard",
        RecommendedBeli = 450000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-4651, 26, -1951), Dialog = "Semper Fi!"},
        },
        Mobs = {
            {Name = "Vice Admiral", Level = 400, Pos = CFrame.new(-4650, 25, -1950), Health = 25000, Damage = 250},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-4648, 28, -1945),
    },
    ["Upper Sky"] = {
        LevelRange = {Min = 575, Max = 600},
        NpcPos = CFrame.new(2301, 401, -5501),
        QuestGiver = "Upper Sky Quest Giver",
        Description = "Highest floating island with thunder god",
        Difficulty = "Insane",
        RecommendedBeli = 800000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(2301, 401, -5501), Dialog = "Thunder..."},
        },
        Mobs = {
            {Name = "Thunder God", Level = 575, Pos = CFrame.new(2300, 400, -5500), Health = 18000, Damage = 240},
        },
        SeaAccess = 1,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(2303, 403, -5495),
    },
    ["Fountain Island"] = {
        LevelRange = {Min = 650, Max = 700},
        NpcPos = CFrame.new(-1451, 16, 4851),
        QuestGiver = "Fountain Quest Giver",
        Description = "Serene island with a magical fountain",
        Difficulty = "Insane",
        RecommendedBeli = 1200000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1451, 16, 4851), Dialog = "The fountain grants wishes..."},
        },
        Mobs = {
            {Name = "Bored Captain", Level = 660, Pos = CFrame.new(-1500, 10, 4800), Health = 18000, Damage = 230},
            {Name = "Shanks", Level = 700, Pos = CFrame.new(-1450, 15, 4850), Health = 50000, Damage = 350},
        },
        SeaAccess = 1,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-1448, 18, 4855),
    },
}

A.Quests.Sea2Data = {
    ["Kingdom of Roses"] = {
        LevelRange = {Min = 700, Max = 1000},
        NpcPos = CFrame.new(-1401, 101, 3501),
        QuestGiver = "Kingdom Quest Giver",
        Description = "Elegant kingdom with rose gardens",
        Difficulty = "Medium",
        RecommendedBeli = 2000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1401, 101, 3501), Dialog = "Welcome to our kingdom!"},
            {Name = "Sword Dealer", Pos = CFrame.new(-1395, 101, 3505), Dialog = "Royal blades!"},
        },
        Mobs = {
            {Name = "Raider", Level = 700, Pos = CFrame.new(-1400, 100, 3500), Health = 20000, Damage = 260},
            {Name = "Mercenary", Level = 725, Pos = CFrame.new(-1350, 110, 3550), Health = 22000, Damage = 280},
            {Name = "Diamond", Level = 750, Pos = CFrame.new(-1300, 115, 3600), Health = 40000, Damage = 350},
        },
        SeaAccess = 2,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = true,
        SpawnPoint = CFrame.new(-1398, 103, 3505),
    },
    ["Forgotten Island"] = {
        LevelRange = {Min = 775, Max = 900},
        NpcPos = CFrame.new(991, 121, 1301),
        QuestGiver = "Forgotten Quest Giver",
        Description = "Mysterious abandoned island",
        Difficulty = "Medium",
        RecommendedBeli = 2500000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(991, 121, 1301), Dialog = "This place was forgotten..."},
        },
        Mobs = {
            {Name = "Swan Pirate", Level = 775, Pos = CFrame.new(990, 120, 1300), Health = 24000, Damage = 290},
            {Name = "Don Swan", Level = 800, Pos = CFrame.new(1050, 125, 1350), Health = 50000, Damage = 400},
            {Name = "Forgotten Soldier", Level = 1200, Pos = CFrame.new(950, 115, 1250), Health = 35000, Damage = 350},
            {Name = "Sunker Pirate", Level = 1250, Pos = CFrame.new(900, 110, 1200), Health = 38000, Damage = 370},
        },
        SeaAccess = 2,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(993, 123, 1305),
    },
    ["Green Zone"] = {
        LevelRange = {Min = 800, Max = 900},
        NpcPos = CFrame.new(-2651, 76, -1051),
        QuestGiver = "Green Zone Quest Giver",
        Description = "Lush green area with factory complex",
        Difficulty = "Hard",
        RecommendedBeli = 3000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-2651, 76, -1051), Dialog = "The factory runs 24/7..."},
        },
        Mobs = {
            {Name = "Factory Staff", Level = 800, Pos = CFrame.new(-2650, 75, -1050), Health = 26000, Damage = 300},
            {Name = "Factory Staff Elite", Level = 825, Pos = CFrame.new(-2600, 80, -1100), Health = 28000, Damage = 320},
        },
        SeaAccess = 2,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-2648, 78, -1045),
    },
    ["Hot and Cold"] = {
        LevelRange = {Min = 850, Max = 1500},
        NpcPos = CFrame.new(-2051, 51, 2501),
        QuestGiver = "Hot Cold Quest Giver",
        Description = "Split island of extreme temperatures",
        Difficulty = "Hard",
        RecommendedBeli = 4000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-2051, 51, 2501), Dialog = "Hot side or cold side?"},
            {Name = "Sword Dealer", Pos = CFrame.new(-2045, 51, 2505), Dialog = "Temperature-proof weapons!"},
        },
        Mobs = {
            {Name = "Marine Lieutenant", Level = 850, Pos = CFrame.new(-2050, 50, 2500), Health = 30000, Damage = 330},
            {Name = "Marine Captain", Level = 875, Pos = CFrame.new(-2000, 55, 2550), Health = 32000, Damage = 350},
            {Name = "Ship Officer", Level = 875, Pos = CFrame.new(-1950, 60, 2600), Health = 33000, Damage = 360},
            {Name = "Island Empress", Level = 900, Pos = CFrame.new(-1900, 65, 2650), Health = 60000, Damage = 450},
            {Name = "Man and His Brother", Level = 1150, Pos = CFrame.new(-2050, 50, 2500), Health = 35000, Damage = 380},
            {Name = "Clueless Pirate", Level = 1300, Pos = CFrame.new(-1950, 60, 2600), Health = 40000, Damage = 400},
            {Name = "Smoke Admiral", Level = 1475, Pos = CFrame.new(-2400, 45, 2000), Health = 80000, Damage = 500},
            {Name = "Awakened Ice Admiral", Level = 1500, Pos = CFrame.new(1550, 115, -2650), Health = 90000, Damage = 520},
            {Name = "Order", Level = 1500, Pos = CFrame.new(-2900, 40, 1400), Health = 100000, Damage = 550},
        },
        SeaAccess = 2,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-2048, 53, 2505),
    },
    ["Frozen Castle"] = {
        LevelRange = {Min = 1000, Max = 1200},
        NpcPos = CFrame.new(1501, 111, -2701),
        QuestGiver = "Castle Quest Giver",
        Description = "Frozen fortress ruled by ice powers",
        Difficulty = "Extreme",
        RecommendedBeli = 5000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(1501, 111, -2701), Dialog = "Enter if you dare..."},
        },
        Mobs = {
            {Name = "Ice Admiral", Level = 1000, Pos = CFrame.new(1500, 110, -2700), Health = 70000, Damage = 450},
            {Name = "Arctic Explorer", Level = 1150, Pos = CFrame.new(1600, 115, -2600), Health = 35000, Damage = 380},
            {Name = "Big Mom", Level = 1175, Pos = CFrame.new(1550, 120, -2650), Health = 95000, Damage = 500},
        },
        SeaAccess = 2,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(1503, 113, -2695),
    },
    ["Magma Lake"] = {
        LevelRange = {Min = 1200, Max = 1300},
        NpcPos = CFrame.new(-1801, 81, -2201),
        QuestGiver = "Lake Quest Giver",
        Description = "Scorching lake of magma",
        Difficulty = "Extreme",
        RecommendedBeli = 6000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1801, 81, -2201), Dialog = "Hot hot hot!"},
        },
        Mobs = {
            {Name = "Magma Admiral", Level = 1200, Pos = CFrame.new(-1800, 80, -2200), Health = 85000, Damage = 480},
        },
        SeaAccess = 2,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-1798, 83, -2195),
    },
    ["Tiki Outpost"] = {
        LevelRange = {Min = 1225, Max = 1350},
        NpcPos = CFrame.new(-1751, 86, -2251),
        QuestGiver = "Tiki Quest Giver",
        Description = "Tropical outpost with island warriors",
        Difficulty = "Extreme",
        RecommendedBeli = 7000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1751, 86, -2251), Dialog = "Aloha!"},
        },
        Mobs = {
            {Name = "Tiki Outpost Pirate", Level = 1225, Pos = CFrame.new(-1750, 85, -2250), Health = 38000, Damage = 390},
            {Name = "Tiki Outpost Soldier", Level = 1250, Pos = CFrame.new(-1700, 90, -2300), Health = 40000, Damage = 410},
            {Name = "Tiki Outpost Elite", Level = 1275, Pos = CFrame.new(-1650, 95, -2350), Health = 42000, Damage = 430},
            {Name = "Oni", Level = 1350, Pos = CFrame.new(5900, 60, -1300), Health = 45000, Damage = 450},
        },
        SeaAccess = 2,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-1748, 88, -2245),
    },
    ["Dragon Dojo"] = {
        LevelRange = {Min = 1300, Max = 1550},
        NpcPos = CFrame.new(5801, 51, -1201),
        QuestGiver = "Dojo Quest Giver",
        Description = "Ancient dragon training ground",
        Difficulty = "Insane",
        RecommendedBeli = 8000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(5801, 51, -1201), Dialog = "Master the dragon arts!"},
        },
        Mobs = {
            {Name = "Dragon Crew Warrior", Level = 1300, Pos = CFrame.new(5800, 50, -1200), Health = 43000, Damage = 440},
            {Name = "Dragon Crew Archer", Level = 1325, Pos = CFrame.new(5850, 55, -1250), Health = 44000, Damage = 450},
        },
        SeaAccess = 2,
        SafeZone = true,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(5803, 53, -1195),
    },
    ["Dark Arena"] = {
        LevelRange = {Min = 1550, Max = 1550},
        NpcPos = CFrame.new(3751, 16, -7001),
        QuestGiver = "Arena Quest Giver",
        Description = "Dark realm where Blackbeard lurks",
        Difficulty = "Insane",
        RecommendedBeli = 10000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(3751, 16, -7001), Dialog = "Darkness awaits..."},
        },
        Mobs = {
            {Name = "Darkbeard", Level = 1550, Pos = CFrame.new(3750, 15, -7000), Health = 120000, Damage = 600},
        },
        SeaAccess = 2,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(3753, 18, -6995),
    },
    ["Rocky Shore"] = {
        LevelRange = {Min = 1450, Max = 1500},
        NpcPos = CFrame.new(-3101, 51, 1201),
        QuestGiver = "Shore Quest Giver Sea2",
        Description = "Dangerous rocky coastline",
        Difficulty = "Insane",
        RecommendedBeli = 9000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-3101, 51, 1201), Dialog = "Watch your step!"},
        },
        Mobs = {
            {Name = "Fajita", Level = 1450, Pos = CFrame.new(-3100, 50, 1200), Health = 85000, Damage = 500},
        },
        SeaAccess = 2,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-3098, 53, 1205),
    },
    ["Deep Sea"] = {
        LevelRange = {Min = 1100, Max = 1400},
        NpcPos = CFrame.new(-1101, 11, -1501),
        QuestGiver = "Deep Sea Quest Giver",
        Description = "Abyssal depths of the ocean",
        Difficulty = "Extreme",
        RecommendedBeli = 5500000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-1101, 11, -1501), Dialog = "The deep calls..."},
        },
        Mobs = {
            {Name = "Fishman Raider", Level = 1100, Pos = CFrame.new(-1100, 10, -1500), Health = 34000, Damage = 360},
            {Name = "Fishman Captain", Level = 1125, Pos = CFrame.new(-1050, 15, -1550), Health = 36000, Damage = 380},
            {Name = "Tide Keeper", Level = 1400, Pos = CFrame.new(-1200, 10, -1400), Health = 80000, Damage = 480},
        },
        SeaAccess = 2,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-1098, 13, -1495),
    },
}

A.Quests.Sea3Data = {
    ["Floating Turtle"] = {
        LevelRange = {Min = 1550, Max = 2550},
        NpcPos = CFrame.new(-5501, 351, 5301),
        QuestGiver = "Turtle Quest Giver",
        Description = "Massive floating turtle island with royal palace",
        Difficulty = "Extreme",
        RecommendedBeli = 15000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-5501, 351, 5301), Dialog = "All hail the king!"},
            {Name = "Sword Dealer", Pos = CFrame.new(-5495, 351, 5305), Dialog = "Royal weapons!"},
            {Name = "Fruit Dealer", Pos = CFrame.new(-5490, 351, 5310), Dialog = "Rare fruits!"},
        },
        Mobs = {
            {Name = "Royal Guard", Level = 1550, Pos = CFrame.new(-5500, 350, 5300), Health = 50000, Damage = 500},
            {Name = "Royal Soldier", Level = 1575, Pos = CFrame.new(-5450, 355, 5350), Health = 52000, Damage = 510},
            {Name = "Pistol Billionaire", Level = 1600, Pos = CFrame.new(-5400, 360, 5400), Health = 54000, Damage = 520},
            {Name = "Helmet Chaos", Level = 1675, Pos = CFrame.new(-5350, 365, 5450), Health = 58000, Damage = 550},
            {Name = "Peaches", Level = 1700, Pos = CFrame.new(-5300, 370, 5500), Health = 60000, Damage = 560},
            {Name = "Royal Squad", Level = 1850, Pos = CFrame.new(-5250, 375, 5550), Health = 68000, Damage = 620},
            {Name = "Kaffed", Level = 1900, Pos = CFrame.new(-5150, 385, 5650), Health = 72000, Damage = 640},
            {Name = "Rip Indra", Level = 2300, Pos = CFrame.new(-5000, 300, 4000), Health = 250000, Damage = 1000},
            {Name = "Great Tree", Level = 2400, Pos = CFrame.new(-4900, 400, 5000), Health = 300000, Damage = 1200},
        },
        SeaAccess = 3,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = true,
        SpawnPoint = CFrame.new(-5498, 353, 5305),
    },
    ["Deep Fortress"] = {
        LevelRange = {Min = 1725, Max = 2400},
        NpcPos = CFrame.new(-4901, 11, 5801),
        QuestGiver = "Fortress Quest Giver",
        Description = "Underwater fortress with reef warriors",
        Difficulty = "Insane",
        RecommendedBeli = 18000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-4901, 11, 5801), Dialog = "Deep below the waves..."},
        },
        Mobs = {
            {Name = "Reef High Guard", Level = 1725, Pos = CFrame.new(-4900, 10, 5800), Health = 62000, Damage = 580},
            {Name = "Seat Kingdom Guard", Level = 1750, Pos = CFrame.new(-4850, 15, 5850), Health = 64000, Damage = 600},
            {Name = "Reef Pirate", Level = 1775, Pos = CFrame.new(-4800, 20, 5900), Health = 66000, Damage = 610},
            {Name = "Stone Guard", Level = 1800, Pos = CFrame.new(-4750, 25, 5950), Health = 68000, Damage = 620},
            {Name = "Stone", Level = 1825, Pos = CFrame.new(-4700, 30, 6000), Health = 120000, Damage = 700},
            {Name = "Body of Water", Level = 2350, Pos = CFrame.new(3200, 5, -6900), Health = 280000, Damage = 1100},
            {Name = "Frozen Flight", Level = 2000, Pos = CFrame.new(3000, 10, -7000), Health = 85000, Damage = 750},
        },
        SeaAccess = 3,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-4898, 13, 5805),
    },
    ["Turtle Mansion"] = {
        LevelRange = {Min = 1925, Max = 2100},
        NpcPos = CFrame.new(4301, 11, -7301),
        QuestGiver = "Mansion Quest Giver",
        Description = "Grand mansion on the turtle's back",
        Difficulty = "Insane",
        RecommendedBeli = 20000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(4301, 11, -7301), Dialog = "Welcome to the mansion!"},
        },
        Mobs = {
            {Name = "Water Warrior", Level = 1925, Pos = CFrame.new(4300, 10, -7300), Health = 75000, Damage = 680},
            {Name = "Water Fighter", Level = 1950, Pos = CFrame.new(4350, 15, -7350), Health = 78000, Damage = 700},
            {Name = "Sea Soldier", Level = 1975, Pos = CFrame.new(4400, 20, -7400), Health = 80000, Damage = 720},
            {Name = "Frozen Warrior", Level = 2000, Pos = CFrame.new(4450, 25, -7450), Health = 82000, Damage = 740},
            {Name = "Island Champion", Level = 2050, Pos = CFrame.new(4500, 30, -7500), Health = 150000, Damage = 850},
        },
        SeaAccess = 3,
        SafeZone = true,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(4303, 13, -7295),
    },
    ["Haunted Castle"] = {
        LevelRange = {Min = 1600, Max = 2500},
        NpcPos = CFrame.new(-5801, 11, -6301),
        QuestGiver = "Castle Quest Giver Sea3",
        Description = "Cursed castle filled with undead",
        Difficulty = "Insane",
        RecommendedBeli = 12000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-5801, 11, -6301), Dialog = "Beware the spirits..."},
            {Name = "Sword Dealer", Pos = CFrame.new(-5795, 11, -6295), Dialog = "Cursed blades!"},
        },
        Mobs = {
            {Name = "Zombie", Level = 1600, Pos = CFrame.new(-5800, 10, -6300), Health = 52000, Damage = 500},
            {Name = "Vampire", Level = 1650, Pos = CFrame.new(-5750, 15, -6350), Health = 56000, Damage = 530},
            {Name = "Demonic Soul", Level = 1700, Pos = CFrame.new(-5700, 20, -6400), Health = 60000, Damage = 560},
            {Name = "Living Zombie", Level = 1750, Pos = CFrame.new(-5650, 25, -6450), Health = 64000, Damage = 580},
            {Name = "Possessed Mummy", Level = 1800, Pos = CFrame.new(-5600, 30, -6500), Health = 68000, Damage = 600},
            {Name = "Cursed Skeleton", Level = 1850, Pos = CFrame.new(-5550, 35, -6550), Health = 72000, Damage = 630},
            {Name = "Ghost", Level = 1900, Pos = CFrame.new(-5500, 40, -6600), Health = 76000, Damage = 660},
            {Name = "Reborn Skeleton", Level = 1950, Pos = CFrame.new(-5450, 45, -6650), Health = 80000, Damage = 690},
            {Name = "Fearful Ghost", Level = 2050, Pos = CFrame.new(-5400, 50, -6700), Health = 150000, Damage = 850},
            {Name = "Chief of Staff", Level = 2100, Pos = CFrame.new(-5350, 55, -6750), Health = 160000, Damage = 880},
            {Name = "Soul Guitar User", Level = 2425, Pos = CFrame.new(4200, 30, -7200), Health = 250000, Damage = 1100},
        },
        SeaAccess = 3,
        SafeZone = false,
        HasShop = true,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-5798, 13, -6295),
    },
    ["Dragon Dojo Sea3"] = {
        LevelRange = {Min = 1625, Max = 2150},
        NpcPos = CFrame.new(5901, 61, -1401),
        QuestGiver = "Dojo Quest Giver Sea3",
        Description = "Master dragon training dojo",
        Difficulty = "Insane",
        RecommendedBeli = 14000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(5901, 61, -1401), Dialog = "Become a dragon master!"},
        },
        Mobs = {
            {Name = "Dragon Crew Recruit", Level = 1625, Pos = CFrame.new(5900, 60, -1400), Health = 55000, Damage = 530},
            {Name = "Dragon Crew Warrior", Level = 1650, Pos = CFrame.new(5950, 65, -1450), Health = 58000, Damage = 550},
            {Name = "Longma", Level = 2100, Pos = CFrame.new(5650, 70, -1450), Health = 200000, Damage = 950},
            {Name = "Red Dragon", Level = 2225, Pos = CFrame.new(6100, 80, -1500), Health = 110000, Damage = 850},
            {Name = "Electric Dragon", Level = 2250, Pos = CFrame.new(6150, 85, -1550), Health = 115000, Damage = 880},
        },
        SeaAccess = 3,
        SafeZone = true,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(5903, 63, -1395),
    },
    ["Magma Lake Sea3"] = {
        LevelRange = {Min = 2150, Max = 2250},
        NpcPos = CFrame.new(-2051, 81, -1201),
        QuestGiver = "Lake Quest Giver Sea3",
        Description = "Volcanic lake with dough powers",
        Difficulty = "Extreme",
        RecommendedBeli = 22000000,
        NPCs = {
            {Name = "Quest Giver", Pos = CFrame.new(-2051, 81, -1201), Dialog = "The dough rises..."},
        },
        Mobs = {
            {Name = "Cake Prince", Level = 2150, Pos = CFrame.new(-2050, 80, -1200), Health = 180000, Damage = 900},
            {Name = "Dough King", Level = 2200, Pos = CFrame.new(-2000, 85, -1250), Health = 300000, Damage = 1100},
        },
        SeaAccess = 3,
        SafeZone = false,
        HasShop = false,
        HasFruitDealer = false,
        SpawnPoint = CFrame.new(-2048, 83, -1195),
    },
}

A.Quests.BossDropsExtended = {
    ["Shanks"] = {
        {Item = "Black Cape", Rarity = "Uncommon", DropRate = 25, Description = "Dark cape worn by Shanks"},
        {Item = "Wanted Poster", Rarity = "Common", DropRate = 100, Description = "Bounty poster"},
        {Item = "Black Leg", Rarity = "Rare", DropRate = 5, Description = "Black Leg martial art"},
    },
    ["Buggy"] = {
        {Item = "Buggy's Cape", Rarity = "Uncommon", DropRate = 30, Description = "Buggy the Clown's cape"},
        {Item = "Chop Fruit", Rarity = "Rare", DropRate = 10, Description = "Chop-Chop Fruit"},
    },
    ["Yeti"] = {
        {Item = "Yeti Fur", Rarity = "Uncommon", DropRate = 35, Description = "Fur from the Yeti"},
        {Item = "Yeti's Sword", Rarity = "Rare", DropRate = 8, Description = "Yeti's frozen blade"},
    },
    ["Magma Chief"] = {
        {Item = "Magma Axe", Rarity = "Uncommon", DropRate = 25, Description = "Fiery axe"},
        {Item = "Magma Ore", Rarity = "Common", DropRate = 100, Description = "Raw magma ore"},
    },
    ["Vice Admiral"] = {
        {Item = "Vice Admiral's Cap", Rarity = "Uncommon", DropRate = 20, Description = "Marine officer cap"},
        {Item = "Cloak", Rarity = "Rare", DropRate = 10, Description = "Mysterious cloak"},
    },
    ["Swan"] = {
        {Item = "Swan's Glasses", Rarity = "Uncommon", DropRate = 25, Description = "Swan's signature glasses"},
        {Item = "Swan's Coat", Rarity = "Rare", DropRate = 12, Description = "Elegant coat"},
    },
    ["Thunder God"] = {
        {Item = "Thunder Gem", Rarity = "Rare", DropRate = 15, Description = "Gem of thunder power"},
        {Item = "Electric Glove", Rarity = "Rare", DropRate = 10, Description = "Electrified glove"},
    },
    ["Wysper"] = {
        {Item = "Wysper's Microphone", Rarity = "Rare", DropRate = 15, Description = "Powerful microphone"},
    },
    ["Diamond"] = {
        {Item = "Diamond's Necklace", Rarity = "Uncommon", DropRate = 25, Description = "Sparkling necklace"},
        {Item = "Gemstone", Rarity = "Rare", DropRate = 12, Description = "Precious gemstone"},
    },
    ["Jeremy"] = {
        {Item = "Jeremy's Blade", Rarity = "Rare", DropRate = 15, Description = "Sharp blade"},
        {Item = "Dark Coin", Rarity = "Uncommon", DropRate = 30, Description = "Dark currency"},
    },
    ["Fajita"] = {
        {Item = "Fajita's Sword", Rarity = "Rare", DropRate = 12, Description = "Gravity sword"},
        {Item = "Gravity Stone", Rarity = "Epic", DropRate = 5, Description = "Stone of gravity power"},
    },
    ["Don Swan"] = {
        {Item = "Swan's Glasses", Rarity = "Uncommon", DropRate = 20, Description = "Signature glasses"},
        {Item = "Swan's Coat", Rarity = "Rare", DropRate = 10, Description = "Designer coat"},
    },
    ["Cyborg"] = {
        {Item = "Cyborg's Arm", Rarity = "Rare", DropRate = 15, Description = "Mechanical arm"},
        {Item = "Core Brain", Rarity = "Epic", DropRate = 8, Description = "Advanced AI core"},
    },
    ["Ice Admiral"] = {
        {Item = "Ice Heart", Rarity = "Rare", DropRate = 12, Description = "Frozen heart crystal"},
        {Item = "Frozen Dark Blade", Rarity = "Epic", DropRate = 5, Description = "Ice-enchanted blade"},
    },
    ["Island Empress"] = {
        {Item = "Empress's Gown", Rarity = "Rare", DropRate = 15, Description = "Royal gown"},
        {Item = "Queen's Charm", Rarity = "Uncommon", DropRate = 25, Description = "Magical charm"},
    },
    ["Kilo Admiral"] = {
        {Item = "Kilo Fruit", Rarity = "Rare", DropRate = 8, Description = "Kilo-Kilo Fruit"},
        {Item = "Admiral's Badge", Rarity = "Uncommon", DropRate = 30, Description = "Marine badge"},
    },
    ["Captain Elephant"] = {
        {Item = "Elephant Armor", Rarity = "Rare", DropRate = 15, Description = "Heavy armor"},
        {Item = "Captain's Hat", Rarity = "Uncommon", DropRate = 25, Description = "Captain hat"},
    },
    ["Beautiful Pirate"] = {
        {Item = "Beautiful Pirate's Sword", Rarity = "Rare", DropRate = 12, Description = "Elegant sword"},
        {Item = "Golden Rose", Rarity = "Uncommon", DropRate = 30, Description = "Golden flower"},
    },
    ["Magma Admiral"] = {
        {Item = "Magma Heart", Rarity = "Rare", DropRate = 10, Description = "Burning heart"},
        {Item = "Admiral's Coat", Rarity = "Uncommon", DropRate = 25, Description = "Marine coat"},
    },
    ["Big Mom"] = {
        {Item = "Soul Fruit", Rarity = "Epic", DropRate = 5, Description = "Soul-Soul Fruit"},
        {Item = "Big Mom's Wig", Rarity = "Uncommon", DropRate = 20, Description = "Signature wig"},
    },
    ["Smoke Admiral"] = {
        {Item = "Smoke Badge", Rarity = "Uncommon", DropRate = 25, Description = "Smoke division badge"},
        {Item = "Admiral's Pipe", Rarity = "Rare", DropRate = 10, Description = "Admiral's pipe"},
    },
    ["Awakened Ice Admiral"] = {
        {Item = "Ice Heart Awakened", Rarity = "Epic", DropRate = 8, Description = "Awakened ice heart"},
        {Item = "Frozen Heart", Rarity = "Rare", DropRate = 15, Description = "Frozen crystal heart"},
    },
    ["Order"] = {
        {Item = "Order's Sword", Rarity = "Epic", DropRate = 6, Description = "Supreme sword"},
        {Item = "Puzzle Key", Rarity = "Rare", DropRate = 12, Description = "Key to puzzles"},
    },
    ["Darkbeard"] = {
        {Item = "Dark Dagger", Rarity = "Legendary", DropRate = 3, Description = "Darkness-imbued dagger"},
        {Item = "Dark Fragment", Rarity = "Epic", DropRate = 8, Description = "Fragment of darkness"},
    },
    ["Core Brain"] = {
        {Item = "Core Brain", Rarity = "Epic", DropRate = 10, Description = "Cyborg neural processor"},
        {Item = "Mechanical Heart", Rarity = "Rare", DropRate = 20, Description = "Mechanical heart core"},
    },
    ["Tide Keeper"] = {
        {Item = "Tide Keeper's Trident", Rarity = "Epic", DropRate = 8, Description = "Trident of the tides"},
        {Item = "Sea Pearl", Rarity = "Rare", DropRate = 15, Description = "Luminous pearl"},
    },
    ["Rip Indra"] = {
        {Item = "Dark Fragment", Rarity = "Epic", DropRate = 25, Description = "Fragment of darkness"},
        {Item = "Valkyrie Helm", Rarity = "Legendary", DropRate = 3, Description = "Divine warrior helm"},
    },
    ["Stone"] = {
        {Item = "Stone's Blade", Rarity = "Rare", DropRate = 12, Description = "Heavy stone blade"},
        {Item = "Rock Heart", Rarity = "Uncommon", DropRate = 30, Description = "Petrified heart"},
    },
    ["Longma"] = {
        {Item = "Longma's Sword", Rarity = "Epic", DropRate = 8, Description = "Dragon blade"},
        {Item = "Dragon Scale", Rarity = "Rare", DropRate = 20, Description = "Scale from a dragon"},
    },
    ["Cake Prince"] = {
        {Item = "Dough Fruit", Rarity = "Legendary", DropRate = 3, Description = "Dough-Dough Fruit"},
        {Item = "Cake Prince's Crown", Rarity = "Epic", DropRate = 8, Description = "Royal cake crown"},
    },
    ["Dough King"] = {
        {Item = "Dough Fruit Awakened", Rarity = "Legendary", DropRate = 2, Description = "Awakened Dough-Dough Fruit"},
        {Item = "King's Crown", Rarity = "Epic", DropRate = 10, Description = "Crown of the Dough King"},
    },
    ["Island Champion"] = {
        {Item = "Champion's Belt", Rarity = "Rare", DropRate = 15, Description = "Championship belt"},
        {Item = "Island Heart", Rarity = "Uncommon", DropRate = 25, Description = "Heart of the island"},
    },
    ["Great Tree"] = {
        {Item = "Kitsune Ribbon", Rarity = "Legendary", DropRate = 2, Description = "Divine fox ribbon"},
        {Item = "Tushita", Rarity = "Legendary", DropRate = 2, Description = "Holy sword Tushita"},
    },
    ["Body of Water"] = {
        {Item = "Water Key", Rarity = "Epic", DropRate = 8, Description = "Key to the deep"},
        {Item = "Sea Essence", Rarity = "Rare", DropRate = 18, Description = "Essence of the sea"},
    },
    ["Soul Guitar User"] = {
        {Item = "Soul Guitar", Rarity = "Legendary", DropRate = 3, Description = "Instrument of souls"},
        {Item = "Soul Essence", Rarity = "Epic", DropRate = 10, Description = "Essence of souls"},
    },
    ["Fearful Ghost"] = {
        {Item = "Ghost Ectoplasm", Rarity = "Rare", DropRate = 20, Description = "Ghostly ectoplasm"},
        {Item = "Spectral Cloak", Rarity = "Rare", DropRate = 12, Description = "Cloak of the spectral"},
    },
}

A.Quests.SeaUnlocks = {
    [1] = {
        Name = "First Sea",
        Description = "The starting seas for all adventurers",
        LevelRange = {Min = 1, Max = 700},
        TotalQuests = #A.Quests.Sea1,
        TotalBosses = 0,
        KeyLocations = {"Starter Island", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Sky Island", "Prison", "Colosseum", "Marine Fortress", "Underwater City", "Magma Village", "Orange Town", "Rocky Shore", "Marine Base", "Upper Sky", "Fountain Island"},
        Requirements = "None",
        Difficulty = "Beginner",
    },
    [2] = {
        Name = "Second Sea",
        Description = "The middle seas with greater challenges",
        LevelRange = {Min = 700, Max = 1550},
        TotalQuests = #A.Quests.Sea2,
        TotalBosses = 0,
        KeyLocations = {"Kingdom of Roses", "Forgotten Island", "Green Zone", "Hot and Cold", "Frozen Castle", "Magma Lake", "Tiki Outpost", "Dragon Dojo", "Dark Arena", "Deep Sea", "Rocky Shore"},
        Requirements = "Complete First Sea (Level 700)",
        Difficulty = "Intermediate",
    },
    [3] = {
        Name = "Third Sea",
        Description = "The final seas for master adventurers",
        LevelRange = {Min = 1550, Max = 2550},
        TotalQuests = #A.Quests.Sea3,
        TotalBosses = 0,
        KeyLocations = {"Floating Turtle", "Deep Fortress", "Turtle Mansion", "Haunted Castle", "Dragon Dojo", "Magma Lake"},
        Requirements = "Complete Second Sea (Level 1550)",
        Difficulty = "Expert",
    },
}

A.Quests.XPRateSea1 = {
    [1] = 50, [14] = 150, [20] = 240, [25] = 350, [30] = 450, [35] = 550,
    [45] = 800, [50] = 1000, [55] = 1200, [60] = 1300, [65] = 1400, [75] = 1800,
    [85] = 2200, [90] = 2400, [95] = 2700, [100] = 3000, [125] = 4000, [150] = 5000,
    [155] = 5200, [160] = 5500, [175] = 6000, [185] = 6400, [200] = 7600, [225] = 9000,
    [250] = 10000, [260] = 10600, [275] = 11600, [350] = 16000, [375] = 18000,
    [400] = 21000, [425] = 24000, [450] = 27000, [475] = 30000, [500] = 34000,
    [525] = 38000, [550] = 42000, [575] = 48000, [580] = 50000, [600] = 54000,
    [650] = 64000, [660] = 66000, [700] = 80000,
}

A.Quests.XPRateSea2 = {
    [700] = 84000, [725] = 88000, [750] = 96000, [775] = 100000, [800] = 110000,
    [825] = 112000, [850] = 116000, [875] = 122000, [900] = 132000, [925] = 140000,
    [950] = 150000, [975] = 160000, [1000] = 180000, [1050] = 185000, [1100] = 190000,
    [1125] = 200000, [1150] = 210000, [1175] = 220000, [1200] = 230000, [1225] = 240000,
    [1250] = 250000, [1275] = 260000, [1300] = 280000, [1325] = 290000, [1350] = 300000,
    [1400] = 320000, [1425] = 320000, [1450] = 330000, [1475] = 340000, [1500] = 350000,
    [1550] = 400000,
}

A.Quests.XPRateSea3 = {
    [1550] = 420000, [1575] = 440000, [1600] = 460000, [1625] = 480000, [1650] = 500000,
    [1675] = 520000, [1700] = 550000, [1725] = 570000, [1750] = 590000, [1775] = 610000,
    [1800] = 640000, [1825] = 670000, [1850] = 690000, [1875] = 710000, [1900] = 740000,
    [1925] = 760000, [1950] = 790000, [1975] = 820000, [2000] = 850000, [2025] = 880000,
    [2050] = 920000, [2075] = 960000, [2100] = 1000000, [2125] = 1030000, [2150] = 1060000,
    [2200] = 1120000, [2225] = 1150000, [2250] = 1180000, [2300] = 1300000, [2350] = 1300000,
    [2400] = 1360000, [2425] = 1400000, [2450] = 1450000, [2500] = 1500000, [2550] = 1600000,
}

A.Quests.DifficultyScaling = {
    [1] = 1.0, [50] = 1.1, [100] = 1.2, [150] = 1.3, [200] = 1.4,
    [250] = 1.5, [300] = 1.6, [350] = 1.7, [400] = 1.8, [450] = 1.9,
    [500] = 2.0, [550] = 2.2, [600] = 2.4, [650] = 2.6, [700] = 3.0,
    [750] = 3.2, [800] = 3.4, [850] = 3.6, [900] = 3.8, [950] = 4.0,
    [1000] = 4.5, [1050] = 5.0, [1100] = 5.5, [1150] = 6.0, [1200] = 6.5,
    [1250] = 7.0, [1300] = 7.5, [1350] = 8.0, [1400] = 8.5, [1450] = 9.0,
    [1500] = 9.5, [1550] = 10.0, [1600] = 11.0, [1650] = 12.0, [1700] = 13.0,
    [1750] = 14.0, [1800] = 15.0, [1850] = 16.0, [1900] = 17.0, [1950] = 18.0,
    [2000] = 20.0, [2050] = 22.0, [2100] = 24.0, [2150] = 26.0, [2200] = 28.0,
    [2250] = 30.0, [2300] = 33.0, [2350] = 36.0, [2400] = 40.0, [2450] = 44.0,
    [2500] = 48.0, [2550] = 55.0,
}

function A.Questsfunctions.GetAllQuests()
    return GetAllQuests()
end

function A.Questsfunctions.GetSeaForLevel(level)
    return GetSeaForLevel(level)
end

function A.Questsfunctions.GetSeaTable(sea)
    return GetSeaTable(sea)
end

function A.Questsfunctions.GetIslandData(islandName, sea)
    local seaDataKey = "Sea" .. sea .. "Data"
    local seaData = A.Quests[seaDataKey]
    if seaData and seaData[islandName] then
        return seaData[islandName]
    end
    return nil
end

function A.Questsfunctions.GetBossDropInfo(bossName)
    return A.Quests.BossDropsExtended[bossName]
end

function A.Questsfunctions.GetXPForLevel(level)
    local sea = GetSeaForLevel(level)
    local xpTable = nil
    if sea == 1 then
        xpTable = A.Quests.XPRateSea1
    elseif sea == 2 then
        xpTable = A.Quests.XPRateSea2
    elseif sea == 3 then
        xpTable = A.Quests.XPRateSea3
    end
    if not xpTable then
        return 0
    end
    local bestXP = 0
    for lvl, xp in pairs(xpTable) do
        if lvl <= level and xp > bestXP then
            bestXP = xp
        end
    end
    return bestXP
end

function A.Questsfunctions.GetDifficultyMultiplier(level)
    local bestMult = 1.0
    for lvl, mult in pairs(A.Quests.DifficultyScaling) do
        if lvl <= level and mult > bestMult then
            bestMult = mult
        end
    end
    return bestMult
end

function A.Questsfunctions.GetSeaInfo(sea)
    return A.Quests.SeaUnlocks[sea]
end

function A.Questsfunctions.GetEstimatedTimeToComplete(questName)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if not questData then
        return 0
    end
    local xpRate = A.Quests.XPRate[questName] or questData.Reward
    local difficulty = A.Quests.DifficultyRating[questName] or 10
    local baseTime = 60 + (difficulty * 10)
    local estimatedSeconds = baseTime / (1 + (difficulty * 0.01))
    return math.floor(estimatedSeconds)
end

function A.Questsfunctions.GetRecommendedGear(level)
    local sea = GetSeaForLevel(level)
    local recommendations = {}
    if sea == 1 then
        if level < 100 then
            table.insert(recommendations, "Basic Sword")
            table.insert(recommendations, "Basic Gun")
        elseif level < 300 then
            table.insert(recommendations, "Iron Mace")
            table.insert(recommendations, "Flintlock")
        elseif level < 500 then
            table.insert(recommendations, "Triple Katana")
            table.insert(recommendations, "Musket")
        else
            table.insert(recommendations, "Shark Saw")
            table.insert(recommendations, "Refined Flintlock")
        end
    elseif sea == 2 then
        if level < 1000 then
            table.insert(recommendations, "Gravity Cane")
            table.insert(recommendations, "Kabucha")
        elseif level < 1300 then
            table.insert(recommendations, "Soul Guitar")
            table.insert(recommendations, "Spikey Trident")
        else
            table.insert(recommendations, "Dark Dagger")
            table.insert(recommendations, "Acidum Rifle")
        end
    elseif sea == 3 then
        if level < 2000 then
            table.insert(recommendations, "Yama")
            table.insert(recommendations, "Soul Guitar")
        else
            table.insert(recommendations, "Tushita")
            table.insert(recommendations, "Canvander")
            table.insert(recommendations, "Soul Guitar")
        end
    end
    return recommendations
end

function A.Questsfunctions.GetQuestChain(questName)
    local questData = A.Questsfunctions.GetQuestData(questName)
    if not questData then
        return {}
    end
    local chain = {}
    local allQuests = GetAllQuests()
    local seaQuests = {}
    for _, q in ipairs(allQuests) do
        if q.Region == questData.Region then
            table.insert(seaQuests, q)
        end
    end
    table.sort(seaQuests, function(a, b)
        return a.Level < b.Level
    end)
    local found = false
    for _, q in ipairs(seaQuests) do
        if q.Q == questName then
            found = true
        end
        if found or q.Level <= questData.Level then
            table.insert(chain, q)
        end
    end
    return chain
end
