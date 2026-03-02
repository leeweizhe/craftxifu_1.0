-- ============================================================
-- DROP AND RECREATE TABLES (run once on fresh setup)
-- ============================================================

-- ============================================================
-- ENCHANTMENT TABLE  (added DetailImage column)
-- ============================================================
IF OBJECT_ID('enchantmentTable','U') IS NOT NULL DROP TABLE enchantmentTable;
CREATE TABLE enchantmentTable (
    EnchantmentId   INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(100)  NOT NULL,
    Category        NVARCHAR(50)   NOT NULL,
    MaxLevel        INT            NOT NULL,
    Description     NVARCHAR(500)  NOT NULL,
    FullContent     NVARCHAR(MAX)  NULL,
    AppliesTo       NVARCHAR(200)  NULL,
    ConflictsWith   NVARCHAR(200)  NULL,
    Thumbnail       NVARCHAR(300)  NULL,
    DetailImage     NVARCHAR(300)  NULL,
    TreasureOnly    BIT            DEFAULT 0
);

-- ============================================================
-- 20 ENCHANTMENTS
-- Thumbnail  → small image shown in the list row
-- DetailImage → large image shown in the detail page
-- Images go in:  /Wong Zhang Zhe/pic/enchant/
-- ============================================================
INSERT INTO enchantmentTable
    (Name,Category,MaxLevel,Description,FullContent,AppliesTo,ConflictsWith,Thumbnail,DetailImage,TreasureOnly)
VALUES

/* ── SWORD ─────────────────────────────────────── */
('Sharpness','Sword',5,
 'Increases melee damage dealt to all mobs and players.',
 '<b>Damage per level (Java):</b> +0.5 attack damage per level. At Sharpness V a diamond sword hits for 8 damage.<br><br><b>How to get:</b> Enchanting table (common), librarian villagers, loot chests.<br><br><b>Best combo:</b> Sharpness V + Looting III + Fire Aspect II + Unbreaking III + Mending is the ideal PvE sword.<br><br><b>Anvil tip:</b> Combine two Sharpness IV books on an anvil to create Sharpness V.',
 'Sword, Axe','Smite, Bane of Arthropods',
 '~/Wong Zhang Zhe/pic/enchant/sharpness_thumb.png','~/Wong Zhang Zhe/pic/enchant/sharpness_detail.png',0),

('Smite','Sword',5,
 'Increases melee damage against all undead mobs by +2.5 per level.',
 '<b>Undead mobs affected:</b> Zombies, Skeletons, Wither Skeletons, Strays, Husks, Drowned, Phantoms, Zoglins, and the Wither boss.<br><br><b>Smite V damage bonus:</b> +12.5 damage per hit – nearly one-shots a skeleton on Normal difficulty.<br><br><b>Best for:</b> Wither skeleton skull farms, skeleton/zombie grinders, killing the Wither boss.<br><br><b>Note:</b> Cannot be combined with Sharpness or Bane of Arthropods.',
 'Sword, Axe','Sharpness, Bane of Arthropods',
 '~/Wong Zhang Zhe/pic/enchant/smite_thumb.png','~/Wong Zhang Zhe/pic/enchant/smite_detail.png',0),

('Bane of Arthropods','Sword',5,
 'Increases damage and inflicts Slowness IV against spiders, cave spiders, silverfish, bees, and endermites.',
 '<b>Damage bonus:</b> +2.5 per level (same scaling as Smite).<br><br><b>Slowness duration:</b> 1 to 1.5 seconds at level I, scaling up to 3.5 seconds at level V.<br><br><b>Best for:</b> Spider/cave spider mob grinders. The Slowness effect is especially useful against fast cave spiders that carry poison.<br><br><b>Tip:</b> Endermites triggered by ender pearls are arthropods – this sword destroys them fast.',
 'Sword, Axe','Sharpness, Smite',
 '~/Wong Zhang Zhe/pic/enchant/baneofarthropods_thumb.png','~/Wong Zhang Zhe/pic/enchant/baneofarthropods_detail.png',0),

('Looting','Sword',3,
 'Increases the quantity and quality of drops from killed mobs.',
 '<b>Per level bonus:</b> Max drop count +1 per level. Rare drops (like Wither Skull, Blaze Rod) have higher chances.<br><br><b>Wither Skull drop rate:</b> Base 2.5% → Looting I 3.5% → Looting II 4.5% → Looting III 5.5%<br><br><b>Applies to:</b> All mob drops including rare ones like Wither Skulls, Nether Stars, Ender Pearls, and Blaze Rods.<br><br><b>Important:</b> You must land the killing blow with the Looting sword for the bonus to apply.',
 'Sword','',
 '~/Wong Zhang Zhe/pic/enchant/looting_thumb.png','~/Wong Zhang Zhe/pic/enchant/looting_detail.png',0),

('Fire Aspect','Sword',2,
 'Sets the target on fire upon hit, dealing bonus fire damage over time.',
 '<b>Level I:</b> 4 seconds on fire → 3 fire damage total.<br><b>Level II:</b> 8 seconds on fire → 7 fire damage total.<br><br><b>Auto-cook bonus:</b> Animals killed while burning drop their cooked version automatically! Cows drop steaks, chickens drop cooked chicken.<br><br><b>Does NOT work on:</b> Blazes, Magma Cubes, Ghasts, Wither Skeletons (fire-immune mobs).<br><br><b>PvP:</b> Fire Aspect can interrupt opponents'' regeneration and force them to waste water buckets.',
 'Sword','',
 '~/Wong Zhang Zhe/pic/enchant/fireaspect_thumb.png','~/Wong Zhang Zhe/pic/enchant/fireaspect_detail.png',0),

('Sweeping Edge','Sword',3,
 'Increases damage dealt by sweep attacks (Java Edition only).',
 '<b>Sweep damage multiplier:</b> Level I = 50%, Level II = 67%, Level III = 75% of normal sword damage.<br><br><b>How sweep attacks work:</b> When you swing a sword with a full attack cooldown and are on the ground, a sweep attack hits all nearby mobs.<br><br><b>Best use:</b> Mob grinder melee clearing, dealing with multiple zombies/skeletons in a corridor.<br><br><b>Bedrock note:</b> Sweeping Edge does NOT exist in Bedrock Edition.',
 'Sword','',
 '~/Wong Zhang Zhe/pic/enchant/sweepingedge_thumb.png','~/Wong Zhang Zhe/pic/enchant/sweepingedge_detail.png',0),

/* ── ARMOR ──────────────────────────────────────── */
('Protection','Armor',4,
 'Reduces most types of incoming damage including explosions, fire, and projectiles.',
 '<b>EPF per piece per level:</b> 4. Maximum total EPF across all armour is capped at 20, giving 80% damage reduction.<br><br><b>Best set:</b> Full Protection IV netherite is the strongest general-purpose armour in the game.<br><br><b>Stacks with:</b> Resistance status effect (from Beacon) for even more protection.<br><br><b>Note:</b> Cannot be combined with Fire Protection, Blast Protection, or Projectile Protection on the same piece.',
 'Helmet, Chestplate, Leggings, Boots','Fire Protection, Blast Protection, Projectile Protection',
 '~/Wong Zhang Zhe/pic/enchant/protection_thumb.png','~/Wong Zhang Zhe/pic/enchant/protection_detail.png',0),

('Feather Falling','Armor',4,
 'Reduces fall damage taken. Exclusive to boots.',
 '<b>Reduction per level:</b> 12% per level. Feather Falling IV = 48% fall damage reduction.<br><br><b>Combined with Protection IV boots:</b> Up to 80% total fall damage reduction!<br><br><b>Essential for:</b> Building tall structures, mountain exploration, accidental cliff falls.<br><br><b>Tip:</b> Feather Falling IV boots + Slow Falling potion = virtually zero fall damage from any height.',
 'Boots','',
 '~/Wong Zhang Zhe/pic/enchant/featherfalling_thumb.png','~/Wong Zhang Zhe/pic/enchant/featherfalling_detail.png',0),

('Thorns','Armor',3,
 'Reflects damage back to melee attackers when worn.',
 '<b>Proc chance per level:</b> 15% per level (45% at Thorns III). Deals 1–4 damage to the attacker per proc.<br><br><b>Downside:</b> Increases durability consumption on the armour. Combat this with Unbreaking III + Mending.<br><br><b>Best placed on:</b> Chestplate (highest durability) for maximum effectiveness.<br><br><b>PvP:</b> Multiple thorns pieces stack proc chance but durability loss also stacks.',
 'Helmet, Chestplate, Leggings, Boots','',
 '~/Wong Zhang Zhe/pic/enchant/thorns_thumb.png','~/Wong Zhang Zhe/pic/enchant/thorns_detail.png',0),

('Depth Strider','Armor',3,
 'Increases movement speed while submerged in water.',
 '<b>Speed per level:</b> Each level reduces the water movement penalty. Depth Strider III = full land walking speed underwater.<br><br><b>Conflicts with Frost Walker</b> – choose one for your boots.<br><br><b>Best paired with:</b> Respiration III helmet, Water Breathing potion, and Aqua Affinity for a full underwater exploration build.<br><br><b>Ocean Monument tip:</b> With Depth Strider III and Night Vision you can navigate the monument almost as fast as on land.',
 'Boots','Frost Walker',
 '~/Wong Zhang Zhe/pic/enchant/depthstrider_thumb.png','~/Wong Zhang Zhe/pic/enchant/depthstrider_detail.png',0),

/* ── TOOL ───────────────────────────────────────── */
('Fortune','Tool',3,
 'Multiplies block drops from ores, crops, gravel, and other blocks.',
 '<b>Fortune I:</b> Up to 2× drops. <b>Fortune II:</b> Up to 3×. <b>Fortune III:</b> Up to 4× (guaranteed max for diamonds, emeralds, coal, lapis).<br><br><b>Also works on:</b> Gravel (flint), melon, glowstone, nether wart, sea lantern (prismarine crystals), sweet berries, and crops.<br><br><b>Essential rule:</b> ALWAYS mine diamond and emerald ore with Fortune III. Never smelt raw ore when you can get 4× the gems.',
 'Pickaxe, Axe, Shovel, Hoe','Silk Touch',
 '~/Wong Zhang Zhe/pic/enchant/fortune_thumb.png','~/Wong Zhang Zhe/pic/enchant/fortune_detail.png',0),

('Silk Touch','Tool',1,
 'Mine blocks in their natural form instead of their default drops.',
 '<b>Key uses:</b><br>- Mine ores as ore blocks (for smelting XP or decoration)<br>- Collect glass without breaking it<br>- Pick up ice, packed ice, and blue ice<br>- Harvest grass blocks, mycelium, and podzol<br>- Collect bookshelves intact<br>- Move spawner cages (Java Edition)<br><br><b>Cannot collect:</b> Spawners in Bedrock, cake, or brewing stands.<br><br><b>Mutually exclusive with Fortune</b> on the same tool.',
 'Pickaxe, Axe, Shovel, Shears','Fortune',
 '~/Wong Zhang Zhe/pic/enchant/silktouch_thumb.png','~/Wong Zhang Zhe/pic/enchant/silktouch_detail.png',0),

('Efficiency','Tool',5,
 'Significantly increases the speed of mining, digging, and chopping.',
 '<b>Speed formula:</b> Dig speed = base speed + (level² + 1).<br><br><b>Efficiency V + Haste II beacon:</b> Instant mines stone, cobblestone, netherrack, and most common overworld blocks.<br><br><b>Works on:</b> Pickaxes (stone/ore), Shovels (dirt/sand/gravel), Axes (wood/pumpkin), Shears (wool/leaves).<br><br><b>Tip:</b> Even without a Haste beacon, Efficiency V dramatically reduces time spent mining.',
 'Pickaxe, Axe, Shovel, Shears','',
 '~/Wong Zhang Zhe/pic/enchant/efficiency_thumb.png','~/Wong Zhang Zhe/pic/enchant/efficiency_detail.png',0),

/* ── BOW ────────────────────────────────────────── */
('Power','Bow',5,
 'Increases the damage dealt by arrows shot from the bow.',
 '<b>Damage at full draw:</b> Power V deals ~12.5 damage (6.25 hearts) per arrow.<br><br><b>Critical hit combo:</b> A fully drawn Power V bow shot always deals critical damage, potentially one-shotting unarmoured targets.<br><br><b>Best enchant set for bow:</b> Power V + Infinity + Flame + Punch II + Unbreaking III.<br><br><b>Tip:</b> Power V bows can one-shot skeletons through full Protection IV netherite armour when combined with critical shots.',
 'Bow','',
 '~/Wong Zhang Zhe/pic/enchant/power_thumb.png','~/Wong Zhang Zhe/pic/enchant/power_detail.png',0),

('Flame','Bow',1,
 'Arrows shot are set on fire, dealing 5 bonus fire damage and igniting targets.',
 '<b>Fire damage:</b> 5 fire damage over 5 seconds in addition to normal arrow damage.<br><br><b>Special interactions:</b><br>- Can remotely light TNT<br>- Ignites campfires and fire charges remotely<br>- Can relight Nether Portals<br>- Animals killed by burning arrows drop cooked food<br><br><b>Does NOT affect:</b> Fire-immune mobs (Blazes, Ghasts, Wither Skeletons).',
 'Bow','',
 '~/Wong Zhang Zhe/pic/enchant/flame_thumb.png','~/Wong Zhang Zhe/pic/enchant/flame_detail.png',0),

('Infinity','Bow',1,
 'Shooting does not consume regular arrows as long as you carry at least one.',
 '<b>Requirement:</b> At least 1 normal arrow anywhere in your inventory (not tipped or spectral).<br><br><b>Does NOT work with:</b> Tipped arrows or Spectral arrows – those are still consumed.<br><br><b>Conflicts with Mending.</b> Recommendation: Use Infinity unless you have a strong XP farm, in which case Mending lets the bow last forever.<br><br><b>Treasure enchantment</b> – cannot be found on an enchanting table in Bedrock.',
 'Bow','Mending',
 '~/Wong Zhang Zhe/pic/enchant/infinity_thumb.png','~/Wong Zhang Zhe/pic/enchant/infinity_detail.png',1),

/* ── TRIDENT ────────────────────────────────────── */
('Riptide','Trident',3,
 'Hurls the player forward when throwing the trident while in water or rain.',
 '<b>Transport mechanic:</b> Throw the trident – you are launched in the direction you are facing at high speed.<br><br><b>Distance per level:</b> Riptide III can launch you 30+ blocks through the air.<br><br><b>Cannot use when:</b> Dry land with no rain. Requires you to be in water or standing in rain.<br><br><b>Conflicts with Loyalty and Channeling.</b><br><br><b>Elytra synergy:</b> Riptide is the best way to launch yourself for Elytra flight without firework rockets in rainy weather.',
 'Trident','Loyalty, Channeling',
 '~/Wong Zhang Zhe/pic/enchant/riptide_thumb.png','~/Wong Zhang Zhe/pic/enchant/riptide_detail.png',0),

('Channeling','Trident',1,
 'Summons a lightning bolt on hit during a thunderstorm.',
 '<b>Requirements:</b> Active thunderstorm + target has direct sky access (no solid blocks above them).<br><br><b>Special conversions triggered by lightning:</b><br>- Villager → Witch<br>- Pig → Zombie Piglin<br>- Mooshroom red ↔ brown<br>- Creeper → Charged Creeper (drops mob heads!)<br><br><b>Conflicts with Riptide.</b><br><br><b>Tip:</b> Use Channeling to create charged creepers near other mobs to farm their heads.',
 'Trident','Riptide',
 '~/Wong Zhang Zhe/pic/enchant/channeling_thumb.png','~/Wong Zhang Zhe/pic/enchant/channeling_detail.png',0),

/* ── SPECIAL / TREASURE ─────────────────────────── */
('Mending','Other',1,
 'Repairs the item using XP orbs collected, restoring 2 durability per XP point.',
 '<b>How it works:</b> When you collect XP orbs, instead of going to your level bar, the XP repairs a randomly selected Mending item you are holding or wearing.<br><br><b>Priority:</b> Main hand → Off hand → Random armour slot.<br><br><b>Game changer:</b> With a simple XP farm (mob grinder, smelting, or trading), all your Mending gear lasts indefinitely.<br><br><b>How to get:</b> Fishing, village chests, raids, or trading with librarian villagers (find one with Mending trades).<br><br><b>Treasure enchantment only</b> – cannot be obtained from an enchanting table.',
 'All equipment','Infinity',
 '~/Wong Zhang Zhe/pic/enchant/mending_thumb.png','~/Wong Zhang Zhe/pic/enchant/mending_detail.png',1),

('Swift Sneak','Other',3,
 'Allows the player to move faster while sneaking, up to nearly full walk speed at level III.',
 '<b>Sneak speed per level:</b> Level I = 15%, Level II = 30%, Level III = 45% of walk speed.<br><br><b>Why it matters:</b> Normal sneak speed is 30% of walk speed. Swift Sneak III brings it close to normal walking.<br><br><b>How to obtain:</b> ONLY from Ancient City chests deep in the Deep Dark biome. Cannot be enchanted, traded, or found elsewhere.<br><br><b>Best use:</b> Sneaking past Wardens without triggering them, stealth playstyles, and PvP ambushes.',
 'Leggings','',
 '~/Wong Zhang Zhe/pic/enchant/swiftsneak_thumb.png','~/Wong Zhang Zhe/pic/enchant/swiftsneak_detail.png',1);


-- ============================================================
-- POTION TABLE  (added DetailImage + IngredientImage columns)
-- ============================================================
IF OBJECT_ID('potionTable','U') IS NOT NULL DROP TABLE potionTable;
CREATE TABLE potionTable (
    PotionId        INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(100)  NOT NULL,
    Category        NVARCHAR(50)   NOT NULL,
    PotionType      NVARCHAR(50)   NOT NULL,
    Duration        NVARCHAR(50)   NULL,
    Effect          NVARCHAR(300)  NOT NULL,
    BrewingBase     NVARCHAR(200)  NULL,
    Ingredient      NVARCHAR(200)  NULL,
    Description     NVARCHAR(500)  NOT NULL,
    FullContent     NVARCHAR(MAX)  NULL,
    Thumbnail       NVARCHAR(300)  NULL,
    DetailImage     NVARCHAR(300)  NULL,
    IngredientImage NVARCHAR(300)  NULL
);

-- ============================================================
-- 20 POTIONS
-- Thumbnail       → small image on list card
-- DetailImage     → large potion bottle image on detail page
-- IngredientImage → image showing the brewing ingredients
-- Images go in:  /Wong Zhang Zhe/pic/potion/
-- ============================================================
INSERT INTO potionTable
    (Name,Category,PotionType,Duration,Effect,BrewingBase,Ingredient,Description,FullContent,Thumbnail,DetailImage,IngredientImage)
VALUES

/* ── POSITIVE ─────────────────────────────────── */
('Healing','Positive','Brewed','Instant',
 'Instantly restores 4 HP (2 hearts) at level I, 8 HP (4 hearts) at level II.',
 'Awkward Potion','Glistering Melon Slice',
 'The most essential emergency potion. Instant effect makes it perfect for mid-combat burst healing.',
 '<b>Brewing chain:</b><br>Water Bottle → +Nether Wart → Awkward Potion → +Glistering Melon Slice → Healing I<br>Healing I → +Glowstone Dust → Healing II<br>Healing I → +Gunpowder → Splash Potion of Healing<br><br><b>Glistering Melon craft:</b> 1 Melon Slice + 8 Gold Nuggets in a crafting grid.<br><br><b>Reverse mechanic:</b> Healing damages undead mobs! Throw Splash Healing at zombies for 4 area damage.',
 '~/Wong Zhang Zhe/pic/potion/healing_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/healing_detail.png',
 '~/Wong Zhang Zhe/pic/potion/healing_ingredient.png'),

('Regeneration','Positive','Brewed','0:45 (I) / 0:22 (II)',
 'Regenerates 1 HP every 2.5s at level I, or 1 HP every 1.2s at level II.',
 'Awkward Potion','Ghast Tear',
 'Heals over time – excellent for boss fights. Extended Regen (2:00) provides enormous total healing.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Ghast Tear → Regen I (0:45)<br>Regen I → +Redstone → Regen I Extended (2:00)<br>Regen I → +Glowstone Dust → Regen II (0:22)<br><br><b>Ghast Tear farming:</b> Shoot Ghasts with a bow in the Nether. Only melee/projectile kills drop tears – fire damage does NOT drop tears.<br><br><b>Total healing:</b> Regen I Extended heals ~48 HP over 2 minutes – more than 2 full health bars!',
 '~/Wong Zhang Zhe/pic/potion/regeneration_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/regeneration_detail.png',
 '~/Wong Zhang Zhe/pic/potion/regeneration_ingredient.png'),

('Strength','Positive','Brewed','3:00 (I) / 1:30 (II)',
 'Adds +3 melee damage at level I, +6 at level II.',
 'Awkward Potion','Blaze Powder',
 'The most powerful combat potion. Doubles effective DPS when combined with a strong sword.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Blaze Powder → Strength I (3:00)<br>Strength I → +Redstone → Strength I Extended (8:00)<br>Strength I → +Glowstone Dust → Strength II (1:30)<br><br><b>Blaze Powder source:</b> Blaze Rods from Blaze in Nether Fortresses. 1 Blaze Rod = 2 Blaze Powder.<br><br><b>Combat math:</b> Strength II + Sharpness V diamond sword = ~14 damage per swing. One-shots most non-boss mobs.',
 '~/Wong Zhang Zhe/pic/potion/strength_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/strength_detail.png',
 '~/Wong Zhang Zhe/pic/potion/strength_ingredient.png'),

('Speed','Positive','Brewed','3:00 (I) / 1:30 (II)',
 'Increases movement speed by 20% at level I, 40% at level II.',
 'Awkward Potion','Sugar',
 'Move faster across any terrain. Essential for evasion, exploration, and combat kiting.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Sugar → Speed I (3:00)<br>Speed I → +Redstone → Speed I Extended (8:00)<br>Speed I → +Glowstone Dust → Speed II (1:30)<br><br><b>Sugar source:</b> Craft from Sugar Cane. One of the cheapest potions to mass-produce.<br><br><b>Speed II fact:</b> At Speed II you outrun all hostile mobs in the game including zombies, skeletons, and even some spiders in narrow spaces.',
 '~/Wong Zhang Zhe/pic/potion/speed_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/speed_detail.png',
 '~/Wong Zhang Zhe/pic/potion/speed_ingredient.png'),

('Fire Resistance','Positive','Brewed','3:00',
 'Grants 100% immunity to fire, lava, magma blocks, and fire-based attacks.',
 'Awkward Potion','Magma Cream',
 'The single most important potion for Nether exploration. Makes lava swimming completely safe.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Magma Cream → Fire Resistance (3:00)<br>Fire Resistance → +Redstone → Fire Resistance Extended (8:00)<br>Cannot be leveled up – only one tier exists.<br><br><b>Magma Cream sources:</b> Killed Magma Cubes (Nether) OR craft: Slimeball + Blaze Powder.<br><br><b>Always carry this</b> before entering the Nether. Piglin trade gold for Fire Resistance potions (rare but possible).',
 '~/Wong Zhang Zhe/pic/potion/fireresistance_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/fireresistance_detail.png',
 '~/Wong Zhang Zhe/pic/potion/fireresistance_ingredient.png'),

('Night Vision','Positive','Brewed','3:00',
 'Renders the entire world at maximum brightness, eliminating all darkness.',
 'Awkward Potion','Golden Carrot',
 'See perfectly in caves, the ocean floor, and the Nether without any light sources.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Golden Carrot → Night Vision (3:00)<br>Night Vision → +Redstone → Night Vision Extended (8:00)<br>Night Vision → +Fermented Spider Eye → Invisibility (corruption path)<br><br><b>Golden Carrot craft:</b> 1 Carrot + 8 Gold Nuggets.<br><br><b>Best combo:</b> Night Vision + Water Breathing for ocean monument raids. Coral reefs also become breathtaking with this active.',
 '~/Wong Zhang Zhe/pic/potion/nightvision_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/nightvision_detail.png',
 '~/Wong Zhang Zhe/pic/potion/nightvision_ingredient.png'),

('Water Breathing','Positive','Brewed','3:00',
 'Stops the air bubble bar from depleting, granting unlimited time underwater.',
 'Awkward Potion','Pufferfish',
 'Mandatory for ocean monument raids, treasure hunting, and underwater base construction.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Pufferfish → Water Breathing (3:00)<br>Water Breathing → +Redstone → Water Breathing Extended (8:00)<br>Cannot be leveled up.<br><br><b>Pufferfish source:</b> Fishing in any water body (uncommon), or found swimming in warm ocean biomes.<br><br><b>Full underwater build:</b> Water Breathing + Night Vision + Depth Strider III boots + Aqua Affinity helmet = complete underwater explorer.',
 '~/Wong Zhang Zhe/pic/potion/waterbreathing_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/waterbreathing_detail.png',
 '~/Wong Zhang Zhe/pic/potion/waterbreathing_ingredient.png'),

('Invisibility','Positive','Brewed','3:00',
 'Makes the player invisible to all mobs, unless any piece of armor is worn.',
 'Night Vision Potion','Fermented Spider Eye',
 'Sneak past any mob undetected. Remove all armor for true invisibility – even one piece betrays you.',
 '<b>Brewing chain:</b><br>First brew Night Vision (Awkward + Golden Carrot)<br>Night Vision → +Fermented Spider Eye → Invisibility (3:00)<br>Invisibility → +Redstone → Invisibility Extended (8:00)<br><br><b>Armor warning:</b> If ANY armor is visible on your body, mobs can detect you within 8–16 blocks.<br><br><b>Fermented Spider Eye craft:</b> Spider Eye + Brown Mushroom + Sugar.<br><br><b>Stealth tip:</b> Combine with Sneaking to avoid making sound near Wardens.',
 '~/Wong Zhang Zhe/pic/potion/invisibility_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/invisibility_detail.png',
 '~/Wong Zhang Zhe/pic/potion/invisibility_ingredient.png'),

('Slow Falling','Positive','Brewed','1:30',
 'Reduces fall speed dramatically and negates ALL fall damage completely.',
 'Awkward Potion','Phantom Membrane',
 'Jump from any height with zero damage. Perfect for landing from elytra flight and mountain exploration.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Phantom Membrane → Slow Falling (1:30)<br>Slow Falling → +Redstone → Slow Falling Extended (4:00)<br>Cannot be leveled up.<br><br><b>Phantom Membrane source:</b> Kill Phantoms. They spawn when a player has not slept for 3+ in-game days.<br><br><b>Elytra tip:</b> Drink Slow Falling just before you stop gliding. You will float down gently instead of crashing.',
 '~/Wong Zhang Zhe/pic/potion/slowfalling_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/slowfalling_detail.png',
 '~/Wong Zhang Zhe/pic/potion/slowfalling_ingredient.png'),

('Leaping','Positive','Brewed','3:00 (I) / 1:30 (II)',
 'Increases jump height by half a block (I) or a full block (II), and slightly reduces fall damage.',
 'Awkward Potion','Rabbit''s Foot',
 'Jump over 2-block walls at level II. Great for parkour, mountaineering, and escaping enemies.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Rabbit''s Foot → Leaping I (3:00)<br>Leaping I → +Redstone → Leaping I Extended (8:00)<br>Leaping I → +Glowstone Dust → Leaping II (1:30)<br>Leaping (any) → +Fermented Spider Eye → Slowness<br><br><b>Rabbit''s Foot source:</b> Dropped by Rabbits (10% base chance, +3% per Looting level).<br><br><b>Leaping II jump height:</b> Just over 1.25 blocks, enough to clear 2-block-high obstacles.',
 '~/Wong Zhang Zhe/pic/potion/leaping_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/leaping_detail.png',
 '~/Wong Zhang Zhe/pic/potion/leaping_ingredient.png'),

/* ── NEGATIVE ──────────────────────────────────── */
('Poison','Negative','Splash','0:45 (I) / 0:22 (II)',
 'Deals damage over time (1 HP every 1.25s) but cannot reduce HP below 1.',
 'Awkward Potion','Spider Eye',
 'Weakens enemies without killing them. Convert to Splash for offensive use in mob farms or PvP.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Spider Eye → Poison I (0:45)<br>Poison I → +Redstone → Poison I Extended (1:30)<br>Poison I → +Glowstone Dust → Poison II (0:22)<br>Any Poison → +Gunpowder → Splash Potion<br><br><b>Spider Eye source:</b> Spiders and Cave Spiders (50% drop rate).<br><br><b>Important:</b> Poison does NOT affect undead mobs. Use Harming for zombies and skeletons instead.',
 '~/Wong Zhang Zhe/pic/potion/poison_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/poison_detail.png',
 '~/Wong Zhang Zhe/pic/potion/poison_ingredient.png'),

('Harming','Negative','Splash','Instant',
 'Deals 6 instant damage (level I) or 12 instant damage (level II) in an area.',
 'Healing II OR Poison Potion','Fermented Spider Eye',
 'Corrupted from Healing or Poison. Devastating area-of-effect splash weapon in PvP and mob fighting.',
 '<b>Brewing chain:</b><br>Potion of Healing II → +Fermented Spider Eye → Harming I<br>Potion of Poison → +Fermented Spider Eye → Harming I<br>Harming I → +Glowstone Dust → Harming II (12 instant damage!)<br>Any Harming → +Gunpowder → Splash Potion<br><br><b>Reverse mechanic:</b> Harming HEALS undead mobs. Avoid using on zombies/skeletons.<br><br><b>PvP damage:</b> Harming II splash = 12 damage in a radius. Bypasses armour reduction unlike melee.',
 '~/Wong Zhang Zhe/pic/potion/harming_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/harming_detail.png',
 '~/Wong Zhang Zhe/pic/potion/harming_ingredient.png'),

('Weakness','Negative','Splash','1:30',
 'Reduces melee attack damage of affected targets by 4.',
 'Water Bottle (no Nether Wart needed)','Fermented Spider Eye',
 'CRITICAL for curing Zombie Villagers. Unique – brewed directly from a Water Bottle, no Awkward Potion needed.',
 '<b>Brewing chain (unique!):</b><br>Water Bottle → +Fermented Spider Eye → Weakness (1:30)<br>Weakness → +Redstone → Weakness Extended (4:00)<br>Weakness → +Gunpowder → Splash Potion of Weakness ← Required for curing!<br><br><b>Zombie Villager cure process:</b><br>1. Trap the Zombie Villager safely<br>2. Throw Splash Weakness on it<br>3. Right-click it with a Golden Apple<br>4. Wait 2–5 minutes → fully cured Villager!<br><br><b>Cured villagers give permanently discounted trades.</b> This is the most important economic mechanic in the game.',
 '~/Wong Zhang Zhe/pic/potion/weakness_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/weakness_detail.png',
 '~/Wong Zhang Zhe/pic/potion/weakness_ingredient.png'),

('Slowness','Negative','Splash','1:30 (I)',
 'Reduces movement speed by 15% per level. Level IV makes targets walk at 40% normal speed.',
 'Speed OR Leaping Potion','Fermented Spider Eye',
 'Area-denial tool. Combine with Lingering Potion for a ground zone that slows anyone walking through it.',
 '<b>Brewing chain:</b><br>Speed Potion → +Fermented Spider Eye → Slowness I (1:30)<br>Leaping Potion → +Fermented Spider Eye → Slowness I (1:30)<br>Slowness I → +Glowstone Dust → Slowness IV (0:20)<br>Any Slowness → +Gunpowder → Splash → +Dragon''s Breath → Lingering<br><br><b>Lingering use:</b> Place a Lingering Potion of Slowness IV on a chokepoint. Enemies walking through receive Slowness IV and cannot escape.',
 '~/Wong Zhang Zhe/pic/potion/slowness_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/slowness_detail.png',
 '~/Wong Zhang Zhe/pic/potion/slowness_ingredient.png'),

('Decay (Bedrock)','Negative','Splash','0:40',
 'Applies Wither effect, dealing 1 HP per second and turning the health bar black.',
 'Awkward Potion (Bedrock only)','Fermented Spider Eye + Wither Rose',
 'Bedrock Edition exclusive. The Wither effect bypasses armour and can kill. Cannot be obtained in Java.',
 '<b>Bedrock brewing:</b> Awkward Potion + Wither Rose → Potion of Decay<br><br><b>Wither effect details:</b><br>- Deals 1 HP damage per second<br>- Turns hearts black (making it hard to see real HP)<br>- Bypasses armour entirely (only Wither Resistance from the boss fight reduces it)<br>- Milk bucket cures it instantly<br><br><b>Java equivalent:</b> Wither II is applied by Wither Skeletons on melee hit. No potion equivalent in Java Edition.',
 '~/Wong Zhang Zhe/pic/potion/decay_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/decay_detail.png',
 '~/Wong Zhang Zhe/pic/potion/decay_ingredient.png'),

/* ── NEUTRAL ───────────────────────────────────── */
('Turtle Master','Neutral','Brewed','0:20 (I)',
 'Grants Resistance III and Slowness IV simultaneously. Nearly invincible but extremely slow.',
 'Awkward Potion','Turtle Shell',
 'A double-edged potion for tank builds. Use in boss arenas where mobility is sacrificed for survival.',
 '<b>Brewing chain:</b><br>Awkward Potion → +Turtle Shell → Turtle Master I (Resistance III + Slowness IV, 0:20)<br>Turtle Master I → +Redstone → Extended (0:40)<br>Turtle Master I → +Glowstone Dust → Turtle Master II (Resistance IV + Slowness VI, 0:10)<br><br><b>Turtle Shell craft:</b> 5 Scutes in a helmet pattern. Baby sea turtles drop 1 Scute when they grow up.<br><br><b>Resistance IV = 80% damage reduction.</b> Turtle Master II makes you nearly unkillable but you can barely move.',
 '~/Wong Zhang Zhe/pic/potion/turtlemaster_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/turtlemaster_detail.png',
 '~/Wong Zhang Zhe/pic/potion/turtlemaster_ingredient.png'),

('Infestation (1.21+)','Neutral','Brewed','0:45',
 'New in 1.21 Tricky Trials. Affected entities spawn silverfish when they take damage.',
 'Awkward Potion','Infested Stone (new)',
 'Deals indirect crowd control by spawning silverfish from hit targets, turning the battlefield chaotic.',
 '<b>Effect details (1.21):</b> When a mob affected by Infestation takes damage, there is a chance a Silverfish spawns at the hit location. This creates a growing swarm of nuisance mobs mid-fight.<br><br><b>Tactical use:</b> Splash onto a large mob (like a Ravager) before attacking it. Each hit spawns silverfish that then attack enemies.<br><br><b>Note:</b> Part of the new 1.21 potion set. Check the Minecraft Wiki for updated crafting mechanics.',
 '~/Wong Zhang Zhe/pic/potion/infestation_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/infestation_detail.png',
 '~/Wong Zhang Zhe/pic/potion/infestation_ingredient.png'),

('Oozing (1.21+)','Neutral','Brewed','0:45',
 'New in 1.21 Tricky Trials. Affected entities spawn small slimes upon death.',
 'Awkward Potion','Slime Block (new)',
 'Turns killed mobs into slime factories. Useful for slimeball farming or chaos in combat arenas.',
 '<b>Effect details (1.21):</b> When a mob or player affected by Oozing dies, 2 Small Slimes spawn at the death location.<br><br><b>Strategic use:</b> Apply to a powerful mob before killing it. The resulting slimes create distraction targets for other enemies, or can be farmed for slimeballs.<br><br><b>Note:</b> This is a new potion in the 1.21 Tricky Trials update. Always verify current brewing recipes on the official Minecraft Wiki as they may be updated.',
 '~/Wong Zhang Zhe/pic/potion/oozing_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/oozing_detail.png',
 '~/Wong Zhang Zhe/pic/potion/oozing_ingredient.png'),

('Weaving (1.21+)','Neutral','Brewed','0:45',
 'New in 1.21 Tricky Trials. Affected entities leave cobwebs behind when they move.',
 'Awkward Potion','String (new mechanic)',
 'Lays cobweb traps wherever the affected mob walks. Turns retreating enemies into trapped targets.',
 '<b>Effect details (1.21):</b> While affected, the entity periodically places Cobweb blocks as it moves. These cobwebs slow any other entity that walks into them.<br><br><b>Offensive use:</b> Splash onto a fast mob (like a spider or husk). It will lay cobwebs in its wake, slowing your own pursuit but also blocking others.<br><br><b>Defensive use:</b> Splash yourself and run through a corridor to create a cobweb wall between you and pursuing mobs.<br><br><b>Note:</b> Part of the 1.21 new potion family. Verify on the Minecraft Wiki for current recipe details.',
 '~/Wong Zhang Zhe/pic/potion/weaving_thumb.png',
 '~/Wong Zhang Zhe/pic/potion/weaving_detail.png',
 '~/Wong Zhang Zhe/pic/potion/weaving_ingredient.png');


-- ============================================================
-- SHOP, INVENTORY, SCORES (unchanged from before)
-- ============================================================
IF OBJECT_ID('shopItemTable','U')       IS NOT NULL DROP TABLE shopItemTable;
IF OBJECT_ID('userInventoryTable','U')  IS NOT NULL DROP TABLE userInventoryTable;
IF OBJECT_ID('minigameScoreTable','U')  IS NOT NULL DROP TABLE minigameScoreTable;

CREATE TABLE shopItemTable (
    ItemId          INT IDENTITY(1,1) PRIMARY KEY,
    Name            NVARCHAR(100)  NOT NULL,
    Description     NVARCHAR(300)  NOT NULL,
    Price           INT            NOT NULL,
    Rarity          NVARCHAR(50)   NOT NULL,
    ImagePath       NVARCHAR(300)  NULL,
    FrameImagePath  NVARCHAR(300)  NULL,
    IsAvailable     BIT            DEFAULT 1
);
INSERT INTO shopItemTable (Name,Description,Price,Rarity,ImagePath,FrameImagePath) VALUES
('Dirt Digger',         'The humblest of titles. Every legend starts somewhere.',           50,   'Common',    '~/Wong Zhang Zhe/pic/shop/tag_dirt.png',      '~/Wong Zhang Zhe/pic/shop/frame_dirt.png'),
('Stone Miner',         'You have learned the basics. Watch out for gravel!',              100,  'Common',    '~/Wong Zhang Zhe/pic/shop/tag_stone.png',     '~/Wong Zhang Zhe/pic/shop/frame_stone.png'),
('Iron Pioneer',        'Iron is life. You understand the importance of infrastructure.',  200,  'Uncommon',  '~/Wong Zhang Zhe/pic/shop/tag_iron.png',      '~/Wong Zhang Zhe/pic/shop/frame_iron.png'),
('Gold Seeker',         'Shiny and somewhat useless in the Overworld. Still prestigious.', 350,  'Uncommon',  '~/Wong Zhang Zhe/pic/shop/tag_gold.png',      '~/Wong Zhang Zhe/pic/shop/frame_gold.png'),
('Diamond Knight',      'Full diamond armor is no joke. You have ascended.',               500,  'Rare',      '~/Wong Zhang Zhe/pic/shop/tag_diamond.png',   '~/Wong Zhang Zhe/pic/shop/frame_diamond.png'),
('Redstone Wizard',     'Your contraptions defy logic. Pure engineering genius.',          750,  'Rare',      '~/Wong Zhang Zhe/pic/shop/tag_redstone.png',  '~/Wong Zhang Zhe/pic/shop/frame_redstone.png'),
('Ender Dragon Slayer', 'You defeated the Ender Dragon. The End is just the beginning.',   1000, 'Epic',      '~/Wong Zhang Zhe/pic/shop/tag_ender.png',     '~/Wong Zhang Zhe/pic/shop/frame_ender.png'),
('Wither Destroyer',    'The hardest boss in the Overworld bows before you.',              1500, 'Epic',      '~/Wong Zhang Zhe/pic/shop/tag_wither.png',    '~/Wong Zhang Zhe/pic/shop/frame_wither.png'),
('Netherite Legend',    'Ancient debris forged your legend. You are unstoppable.',         2500, 'Legendary', '~/Wong Zhang Zhe/pic/shop/tag_netherite.png', '~/Wong Zhang Zhe/pic/shop/frame_netherite.png'),
('Steve Supreme',       'You ARE Minecraft. The ultimate title for the ultimate player.',   5000, 'Legendary', '~/Wong Zhang Zhe/pic/shop/tag_supreme.png',   '~/Wong Zhang Zhe/pic/shop/frame_supreme.png');

CREATE TABLE userInventoryTable (
    InventoryId     INT IDENTITY(1,1) PRIMARY KEY,
    UserId          INT      NOT NULL,
    ItemId          INT      NOT NULL,
    PurchaseDate    DATETIME DEFAULT GETDATE(),
    IsEquipped      BIT      DEFAULT 0
);

CREATE TABLE minigameScoreTable (
    ScoreId         INT IDENTITY(1,1) PRIMARY KEY,
    UserId          INT          NOT NULL,
    GameName        NVARCHAR(100) NOT NULL,
    PointsEarned    INT          NOT NULL,
    PlayedAt        DATETIME     DEFAULT GETDATE()
);
