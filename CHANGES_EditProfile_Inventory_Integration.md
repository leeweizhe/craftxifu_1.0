# Edit Profile - Inventory Integration

## Summary
Modified the Edit Profile feature so members can only equip name tags and avatar frames from their purchased inventory, ensuring proper variant-based filtering.

---

## Changes Made

### 1. EditProfile.aspx.cs - Load Inventory Items with Variant Filter

**File:** `WebAssignment/Wong Zhang Zhe/EditProfile.aspx.cs`

**Changes:**
- Updated `LoadCurrentData()` method to properly filter items by `Variant` column
- Name Tag dropdown now only shows items with `Variant = 'name'` and valid `ImagePath`
- Avatar Frame dropdown now only shows items with `Variant = 'frame'` and valid `FrameImagePath`
- Added duplicate prevention logic to avoid showing the same item multiple times
- Items are ordered by purchase date (most recent first)

**Key Logic:**
```csharp
// Load only name tags (variant = 'name')
if (variant.ToLower() == "name" && !string.IsNullOrEmpty(tagPath))
{
    if (ddlNameTag.Items.FindByValue(tagPath) == null) // Prevent duplicates
        ddlNameTag.Items.Add(new ListItem(itemName, tagPath));
}

// Load only avatar frames (variant = 'frame')
if (variant.ToLower() == "frame" && !string.IsNullOrEmpty(framePath))
{
    if (ddlAvatarFrame.Items.FindByValue(framePath) == null) // Prevent duplicates
        ddlAvatarFrame.Items.Add(new ListItem(itemName, framePath));
}
```

---

### 2. Minigame.aspx.cs - Improved Equipment System

**File:** `WebAssignment/Brayden/Minigame.aspx.cs`

**Changes:**
- Updated `EquipItem()` method to properly handle variant-based equipment
- When equipping an item, it now checks the `Variant` to determine if it's a name tag or avatar frame
- Updates `userTable` with the correct NameTag or AvatarFrame path
- Updates Session variables appropriately based on item type
- Persists equipment choices to the database for consistency across sessions

**Key Logic:**
```csharp
// Check variant and update appropriate fields
if (variant.ToLower() == "name")
{
    nameTagValue = dr["ImagePath"]...;
    Session["nameTag"] = dr["Name"]...;
}
else if (variant.ToLower() == "frame")
{
    avatarFrameValue = dr["FrameImagePath"]...;
    Session["avatarFrame"] = avatarFrameValue;
}

// Update userTable to persist equipped items
UPDATE userTable 
SET NameTag = (SELECT ImagePath WHERE Variant = 'name' AND IsEquipped = 1),
    AvatarFrame = (SELECT FrameImagePath WHERE Variant = 'frame' AND IsEquipped = 1)
WHERE UserId = @uid
```

---

## How It Works Now

### Member Experience:

1. **Purchase Items from Shop**
   - Members buy name tags (variant='name') or avatar frames (variant='frame') from the shop
   - Items are added to `userInventoryTable` with the appropriate `Variant` value

2. **View Inventory**
   - Navigate to the Inventory tab in Minigame & Shop
   - See all purchased items with their variant type
   - Click "EQUIP" button on any item to equip it

3. **Edit Profile Page**
   - Navigate to Edit Profile
   - **Name Tag Dropdown:** Shows ONLY purchased items with `Variant='name'`
   - **Avatar Frame Dropdown:** Shows ONLY purchased items with `Variant='frame'`
   - Select desired items from dropdowns (can only choose from owned items)
   - Click "SAVE CHANGES" to update profile

4. **Automatic Updates**
   - Changes are saved to `userTable` (NameTag and AvatarFrame columns)
   - Session variables are updated for immediate display
   - Profile displays the equipped items across the site

---

## Database Schema Dependencies

Ensure these tables and columns exist:

### userInventoryTable
- `InventoryId` (PK)
- `UserId` (FK → userTable)
- `ItemId` (FK → shopItemTable)
- `Variant` (NVARCHAR) - Values: 'name' or 'frame'
- `IsEquipped` (BIT) - 1 if equipped, 0 otherwise
- `PurchaseDate` (DATETIME)

### userTable
- `UserId` (PK)
- `NameTag` (NVARCHAR) - Stores ImagePath of equipped name tag
- `AvatarFrame` (NVARCHAR) - Stores FrameImagePath of equipped avatar frame

### shopItemTable
- `ItemId` (PK)
- `Name` (NVARCHAR)
- `ImagePath` (NVARCHAR) - For name tags
- `FrameImagePath` (NVARCHAR) - For avatar frames

---

## Testing Checklist

- [ ] Login as a member who has purchased items
- [ ] Navigate to Minigame & Shop → Inventory
- [ ] Verify only purchased items appear
- [ ] Equip a name tag - verify it updates
- [ ] Equip an avatar frame - verify it updates
- [ ] Navigate to Edit Profile
- [ ] Verify Name Tag dropdown shows only name tag items (Variant='name')
- [ ] Verify Avatar Frame dropdown shows only frame items (Variant='frame')
- [ ] Change selections and save
- [ ] Verify profile page displays the new equipped items
- [ ] Verify selections persist after logout/login

---

## Security Features

✅ **Inventory Validation:** Members can only select items they actually own
✅ **Variant Filtering:** Prevents equipping wrong item types
✅ **Database Constraint:** Only loads items from `userInventoryTable` for the logged-in user
✅ **Duplicate Prevention:** Ensures items don't appear multiple times in dropdowns

---

## Notes

- If a member has not purchased any name tags, the Name Tag dropdown will only show "None / Default"
- If a member has not purchased any avatar frames, the Avatar Frame dropdown will only show "None / Default"
- The `Variant` column must be properly populated when items are purchased (done in `BuyItem` method in Minigame.aspx.cs)
- Items are displayed in the dropdowns ordered by purchase date (newest first)

---

## Build Status
✅ **Build Successful** - No compilation errors
