// We can't determine things like NORTHEAST vs NORTH *and* EAST without making our own flags :(
#define BLOCK_DIR_NORTH			(1<<0)
#define BLOCK_DIR_NORTHEAST		(1<<1)
#define BLOCK_DIR_NORTHWEST		(1<<2)
#define BLOCK_DIR_WEST			(1<<3)
#define BLOCK_DIR_EAST			(1<<4)
#define BLOCK_DIR_SOUTH			(1<<5)
#define BLOCK_DIR_SOUTHEAST		(1<<6)
#define BLOCK_DIR_SOUTHWEST		(1<<7)
#define BLOCK_DIR_ONTOP			(1<<8)

GLOBAL_LIST_INIT(dir2blockdir, list(
	"[NORTH]" = "[BLOCK_DIR_NORTH]",
	"[NORTHEAST]" = "[BLOCK_DIR_NORTHEAST]",
	"[NORTHWEST]" = "[BLOCK_DIR_NORTHWEST]",
	"[WEST]" = "[BLOCK_DIR_WEST]",
	"[EAST]" = "[BLOCK_DIR_EAST]",
	"[SOUTH]" = "[BLOCK_DIR_SOUTH]",
	"[SOUTHEAST]" = "[BLOCK_DIR_SOUTHEAST]",
	"[SOUTHWEST]" = "[BLOCK_DIR_SOUTHWEST]",
	"[NONE]" = "[BLOCK_DIR_ONTOP]",
	))

#define DIR2BLOCKDIR(d)			(GLOB.dir2blockdir["[d]"])

/// ""types"" of parry "items"
#define UNARMED_PARRY		"unarmed"
#define MARTIAL_PARRY		"martial"
#define ITEM_PARRY			"item"

/// Parry phase we're in
#define PARRY_WINDUP		"windup"
#define PARRY_ACTIVE		"main"
#define PARRY_SPINDOWN		"spindown"
