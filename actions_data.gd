extends Node
class_name ActionsData

const KEY_NAME: String = "action name"
const KEY_ICON: String = "action icon"

enum {ICON_SANITY, ICON_FOOD, ICON_KARMA, ICON_DAYS, ICON_LOOT, ICON_TRAVEL, ICON_RUINS}

const WALD_ASSETS_DAYS = preload("uid://biy5nhyvlcv0f")
const WALD_ASSETS_FOOD = preload("uid://cygxcsmslwt4")
const WALD_ASSETS_KARMA = preload("uid://tq0ocoi16tmc")
const WALD_ASSETS_LOOT = preload("uid://hqafnsb2a3qe")
const WALD_ASSETS_SANITY = preload("uid://daetffhlfoqab")
const WALD_ASSETS_MAP = preload("uid://crsa6vpoopib0")
const WALD_ASSETS_RUINS = preload("uid://dy1fxx704oh5m") # TODO: need low res actions

const PROMPT_ICONS: Array = [
	WALD_ASSETS_SANITY,
	WALD_ASSETS_FOOD,
	WALD_ASSETS_KARMA,
	WALD_ASSETS_DAYS,
	WALD_ASSETS_LOOT,
	WALD_ASSETS_MAP,
	WALD_ASSETS_RUINS
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
const KEY_RESULT_LOOT: String = "loot result"
const KEY_RESULT_DAYS: String = "days result"
const KEY_RESULT_CHARACTER: String = "character result"
const KEY_RABBIT: String = "rabbit"
const KEY_RAVEN: String = "raven"
const KEY_SQUIRREL: String = "squirrel"
const KEY_FOX: String = "fox"

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

const RUINS_ACTION: Dictionary = {
	KEY_NAME: "Ominous ruins",
	KEY_ICON: PROMPT_ICONS[ICON_RUINS],
	KEY_COSTS: [
		{KEY_COST_ICON: PROMPT_ICONS[ICON_FOOD],
		KEY_COST_VALUE: 10},
		{KEY_COST_ICON: PROMPT_ICONS[ICON_KARMA],
		KEY_COST_VALUE: 10}
	],
	KEY_BUTTON_TEXT: "Explore",
	KEY_RESULT: [
		{KEY_RESULT_TYPE: KEY_RESULT_PROMPT,
		KEY_RESULT_VALUE: "Exploration text"},
		{KEY_RESULT_TYPE: KEY_RESULT_LOOT,
		KEY_RESULT_VALUE: 50}
	]
}

const KEY_IS_NEUTRAL: String = "neutral"
const KEY_TIMES_USED: String = "times used"
const KEY_USAGE_LIMIT: String = "usage limit"
const KEY_TEXT_SLIDES: String = "text slides"
const KEY_TEXT_NEGATIVE: String = "negative option text"
const KEY_TEXT_POSITIVE: String = "positive option text"
const KEY_TEXT_NEUTRAL: String = "neutral option text"
const KEY_NEGATIVE_RESULTS: String = "negative results"
const KEY_POSITIVE_RESULTS: String = "positive results"
const KEY_NEUTRAL_RESULTS: String = "neutral results"

const PROMPT_TEMPLATE: Dictionary = {
	KEY_IS_NEUTRAL: false,
	KEY_TIMES_USED: 0,
	KEY_USAGE_LIMIT: 1,
	KEY_TEXT_SLIDES: [
		"Slide 1",
		"Slide 2",
		"Slide 3"
	],
	KEY_TEXT_NEGATIVE: "Negative result",
	KEY_TEXT_POSITIVE: "Positive result",
	KEY_TEXT_NEUTRAL: "Neutral result",
	KEY_NEGATIVE_RESULTS: [],
	KEY_POSITIVE_RESULTS: [],
	KEY_NEUTRAL_RESULTS: []
}

const TEMP_NEUTRAL_PROMPT: Dictionary = {
	KEY_IS_NEUTRAL: true,
	KEY_TIMES_USED: 0,
	KEY_USAGE_LIMIT: 0, # if 0, unlimited usages
	KEY_TEXT_SLIDES: [
		"I was walking the last stretch to this clearing, when I stumbled into something hidden in the tall ferns.",
		"Nothing alive, and that's a good thing.\n\nIt was just a bag, with some hard bread that refused to rot."
	],
	KEY_TEXT_NEGATIVE: "Negative result",
	KEY_TEXT_POSITIVE: "Positive result",
	KEY_TEXT_NEUTRAL: "Continue",
	KEY_NEGATIVE_RESULTS: null,
	KEY_POSITIVE_RESULTS: null,
	KEY_NEUTRAL_RESULTS: [
		{KEY_RESULT_TYPE: KEY_RESULT_FOOD,
		KEY_RESULT_VALUE: 10}
	]
}

const RABBIT_NEGATIVE_OUTCOME: Dictionary = {
	KEY_IS_NEUTRAL: true,
	KEY_TEXT_SLIDES: [
		"The Rabbit jumps away with scorn."],
	KEY_TEXT_NEUTRAL: "Continue",
	KEY_NEUTRAL_RESULTS: [
		{KEY_RESULT_TYPE: KEY_RESULT_KARMA,
		KEY_RESULT_VALUE: -30}
	]
}

const RABBIT_POSITIVE_OUTCOME: Dictionary = {
	KEY_IS_NEUTRAL: true,
	KEY_TEXT_SLIDES: [
		"The rabbit joins my party. I can travel longer distances now."],
	KEY_TEXT_NEUTRAL: "Continue",
	KEY_NEUTRAL_RESULTS: [
		{KEY_RESULT_TYPE: KEY_RESULT_KARMA,
		KEY_RESULT_VALUE: 30},
		{KEY_RESULT_TYPE: KEY_RESULT_CHARACTER,
		KEY_RESULT_VALUE: KEY_RABBIT}]
}

const RABBIT_ENCOUNTER_PROMPT: Dictionary = {
	KEY_IS_NEUTRAL: false,
	KEY_TEXT_SLIDES: [
		"I was walking the last stretch to this clearing, when I stumbled into something hidden in the tall ferns.",
		"Nothing alive, and that's a good thing.\n\nIt was just a bag, with some hard bread that refused to rot."
	],
	KEY_TEXT_NEGATIVE: "Put off the Rabbit",
	KEY_TEXT_POSITIVE: "Invite the Rabbit",
	KEY_NEGATIVE_RESULTS: [
		{KEY_RESULT_TYPE: KEY_RESULT_PROMPT,
		KEY_RESULT_VALUE: RABBIT_NEGATIVE_OUTCOME}
	],
	KEY_POSITIVE_RESULTS: [
		{KEY_RESULT_TYPE: KEY_RESULT_PROMPT,
		KEY_RESULT_VALUE: RABBIT_POSITIVE_OUTCOME}
	]
}

const RABBIT_ACTION: Dictionary = {
	KEY_NAME: "A Rabbit Stray",
	KEY_ICON: PROMPT_ICONS[ICON_RUINS],
	KEY_COSTS: [],
	KEY_BUTTON_TEXT: "Meet",
	KEY_RESULT: [
		{KEY_RESULT_TYPE: KEY_RESULT_PROMPT,
		KEY_RESULT_VALUE: RABBIT_ENCOUNTER_PROMPT}
	]
}

# TODO: basically, I need to make actions generate prompts. prompts can be standalone, but this means I need to edit the ruins prompt and the parser, not enough brain rn

# Basically, during map gen, I assign prompts to the various nodes
# Depending on node depth and degree, I pick from a different difficulty category
# Each prompt has a max number of usages to not become repetitive, and most are unique
# Some prompts are neutral, meaning they just tell a story and have one outcome, but some present a choice
# Negative and positive are just generalized labels, some choices can have nuance and be both good or bad
# The picked prompt gets stored in the main map data under each node, in the GameData.KEY_MAPNODE_PROMPT or smth

const EASY_PROMPTS: Array = [
	PROMPT_TEMPLATE,
	PROMPT_TEMPLATE
]

const INTERMEDIATE_PROMPTS: Array = [
	PROMPT_TEMPLATE,
	PROMPT_TEMPLATE
]

const HARD_PROMPTS: Array = [
	PROMPT_TEMPLATE,
	PROMPT_TEMPLATE
]
