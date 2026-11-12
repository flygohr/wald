extends Node
class_name ActionsData

const KEY_NAME: String = "action name"
const KEY_ICON: String = "action icon"

enum {ICON_SANITY, ICON_FOOD, ICON_KARMA, ICON_DAYS, ICON_LOOT, ICON_TRAVEL}

const WALD_ASSETS_DAYS = preload("uid://biy5nhyvlcv0f")
const WALD_ASSETS_FOOD = preload("uid://cygxcsmslwt4")
const WALD_ASSETS_KARMA = preload("uid://tq0ocoi16tmc")
const WALD_ASSETS_LOOT = preload("uid://hqafnsb2a3qe")
const WALD_ASSETS_SANITY = preload("uid://daetffhlfoqab")
const WALD_ASSETS_MAP = preload("uid://crsa6vpoopib0")

const PROMPT_ICONS: Array = [
	WALD_ASSETS_SANITY,
	WALD_ASSETS_FOOD,
	WALD_ASSETS_KARMA,
	WALD_ASSETS_DAYS,
	WALD_ASSETS_LOOT,
	WALD_ASSETS_MAP
]

const KEY_COSTS: String = "action costs"
const KEY_BUTTON_TEXT: String = "button text"
const KEY_RESULT: String = "result"

const KEY_COST_SANITY: String = "sanity cost"
const KEY_COST_FOOD: String = "food cost"
const KEY_COST_KARMA: String = "karma cost"

const KEY_COST_ICON: String = "cost type"
const KEY_COST_VALUE: String = "cost value"

const KEY_RESULT_TYPE: String = "result type"
const KEY_RESULT_PROMPT: String = "prompt"
const KEY_RESULT_SANITY: String = "sanity result"
const KEY_RESULT_FOOD: String = "food result"
const KEY_RESULT_KARMA: String = "karma result"
const KEY_RESULT_TRAVEL: String = "travel result"

const KEY_RESULT_VALUE: String = "result value"

const RABBIT_ICON: Texture2D = preload("res://icon.svg")

const ACTION_TEMPLATE: Dictionary = {
	KEY_NAME: "",
	KEY_ICON: 0,
	KEY_COSTS: [],
	KEY_BUTTON_TEXT: "",
	KEY_RESULT: []
}

const KEY_FEATUREDATA_EMPTY := null

const DEBUG_ACTION: Dictionary = {
	KEY_NAME: "Debug action",
	KEY_ICON: PROMPT_ICONS[ICON_TRAVEL],
	KEY_COSTS: [
		{KEY_COST_ICON: PROMPT_ICONS[ICON_FOOD],
		KEY_COST_VALUE: 10},
		{KEY_COST_ICON: PROMPT_ICONS[ICON_KARMA],
		KEY_COST_VALUE: 10}
	],
	KEY_BUTTON_TEXT: "Debug action",
	KEY_RESULT: [
		{KEY_RESULT_TYPE: KEY_RESULT_TRAVEL,
		KEY_RESULT_VALUE: 0}
	]
}
