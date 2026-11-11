extends Node
class_name ActionsData

const KEY_NAME: String = "action name"
const KEY_ICON: String = "action icon"
const KEY_COSTS: String = "action costs"
const KEY_BUTTON_TEXT: String = "button text"
const KEY_RESULT: String = "result"

const KEY_COST_SANITY: String = "sanity cost"
const KEY_COST_FOOD: String = "food cost"
const KEY_COST_KARMA: String = "karma cost"

const KEY_RESULT_PROMPT: String = "prompt"
const KEY_RESULT_SANITY: String = "sanity result"
const KEY_RESULT_FOOD: String = "food result"
const KEY_RESULT_KARMA: String = "karma result"

const RABBIT_ICON: Texture2D = preload("res://icon.svg")

const ACTION_TEMPLATE: Dictionary = {
	KEY_NAME: "",
	KEY_ICON: 0,
	KEY_COSTS: [],
	KEY_BUTTON_TEXT: "",
	KEY_RESULT: []
}

const KEY_FEATUREDATA_EMPTY := null
