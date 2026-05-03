extends Node2D
class_name GlobalScene

static var lives = 10
static var current_level = 1

static var goodClueActions = [
	'то на него плюют окружающие',
	'то ему запрещено петь песни',
	'то он спит стоя',
	'то с ним нельзя шутить',
	'то он снимается в передаче "Глиб Глоб"'
	]

static var badClueActions = [
	'то он не платит налоги',
	'то ест только камни',
	'то ему кланяются',
	'то с ним соседи оставляют детей',
	'то он шьет  шляпки',
	'то после смерти его труп обведут мелом',
	'то ему запрещено читать газеты',
	'то к нему обращаются "Глап Глап Клап"',
	'то с ним не принято ползать по стенам',
	'то ему нельзя заводить домашних животных'
	]
static var	partClueHead = [
	'Если у марсианина гладкая голова, ',
	'Если у марсианина на голове треугольник, ',
	'Если у марсианина рог единорога, ',
	'Если у марсианина на голове змеи, ',
	'Если у марсианина уши-трубочки, ',
]

static var	partClueEyes = [
	'Если у марсианина нет глаз, ',
	'Если у марсианина один большой глаз, ',
	'Если марсианин носит черные очки, ',
	'Если у марсианина злобный взгляд, ',
	'Если у марсианина фасеточные глаза, ',
]

static var	partClueMouth = [
	'Если у марсианина нет рта, ',
	'Если у марсианина на лице щупальцы, ',
	'Если у марсианина клыки, ',
	'Если у марсианина шикарные красивые усы, ',
	'Если у марсианина рот-трубочка, ',
]

static var	partClueHands = [
	'Если у марсианина нет рук, ',
	'Если у марсианина клешни, ',
	'Если у марсианина накачанные руки, ',
	'Если у марсианина вместо рук щупальца, ',
	'Если марсианин показывает непристойный жест, ',
]

static var	partClueCloth = [
	'Если у марсианина нет одежды, ',
	'Если марсианин носит галстук, ',
	'Если марсианин носит бабочку, ',
	'Если марсианин носит бусы, ',
	'Если марсианин носит повязку с рисунком листа, ',
]

static func getPartHead(index: int) -> Texture2D:
	return load(str("res://assets/pics/blob/parts/head/", index, ".png"))
	
static func getPartEye(index: int) -> Texture2D:
	return load(str("res://assets/pics/blob/parts/eye/", index, ".png"))
static func getPartMouth(index: int) -> Texture2D:
	return load(str("res://assets/pics/blob/parts/mouth/", index, ".png"))
static func getPartHand(index: int) -> Texture2D:
	return load(str("res://assets/pics/blob/parts/hand/", index, ".png"))
static func getPartCloth(index: int) -> Texture2D:
	return load(str("res://assets/pics/blob/parts/cloth/", index, ".png"))


enum ClueType {
	Good,
	Bad,
	Empty
}
	
static var clueTypesArray = [ClueType.Empty, ClueType.Empty, ClueType.Empty, ClueType.Empty]
static var clueTextIndexArray = [0, 0, 0, 0]
static var partCluesArray: Array[String] = []

static var goodClues = [] 
static var badClues = []

static func resetClues():
	goodClues = []
	badClues = []
	clueTypesArray =  [ClueType.Empty, ClueType.Empty, ClueType.Empty, ClueType.Empty]
	clueTextIndexArray = [0, 0, 0, 0]
	partCluesArray = []


static func getClueText(index: int):
	var clueType = clueTypesArray[index]
	var clueWithType 
	if(clueType == ClueType.Empty):
		clueWithType = ''
	var clueTextIndex = clueTextIndexArray[index]
	if(clueType == ClueType.Good):
		clueWithType = goodClueActions[clueTextIndex]
	if(clueType == ClueType.Bad):
		clueWithType = badClueActions[clueTextIndex]
	if(clueWithType == ''):
		return ''
	var partClue = partCluesArray[index]
	return str(partClue, clueWithType)

static func getClueCount() -> int:
	return clueTypesArray.filter(func(value):
		return value != ClueType.Empty
		).size()

static var rng = RandomNumberGenerator.new()

static func getGoodTextId():
	var cluesTextCount = goodClueActions.size()
	var rand = rng.randi_range(0, cluesTextCount-1)
	return rand
static func getBadTextId():
	var cluesTextCount = badClueActions.size()
	var rand = rng.randi_range(0, cluesTextCount-1)
	return rand

static func generateNextClue():
	var isGood = rng.randi_range(1, 2) == 1
	var count = getClueCount()
	if(count == 4):
		return
	var repeated: bool = false
	var clueId: int = 0
	if(isGood):
		clueTypesArray[count] = ClueType.Good
		clueId = getGoodTextId()
		repeated = goodClues.find(clueId) != -1
		while(!repeated):
			clueId = getGoodTextId()
			repeated = goodClues.find(clueId) != -1
		goodClues.push_back(clueId)
	if(!isGood):
		clueTypesArray[count] = ClueType.Bad
		clueId = getGoodTextId()
		repeated = goodClues.find(clueId) != -1
		while(!repeated):
			clueId = getGoodTextId()
			repeated = goodClues.find(clueId) != -1	
		badClues.push_back(clueId)
	clueTextIndexArray.push_back(clueId)
	var filteredTrueState = true_blob_state.filter(func(value):
		return value != null)
	var partClueArray: Array[String]
	var randStateIndex = rng.randi_range(0, filteredTrueState.size()-1)
	match randStateIndex:
		0:
			partClueArray = partClueHead
		1:
			partClueArray = partClueEyes
		2:
			partClueArray = partClueMouth
		3:
			partClueArray = partClueHands
		4:
			partClueArray = partClueCloth
	var randStateValue =  partClueArray[randStateIndex]
	partCluesArray.push_back(randStateValue)

# Тут показывается элемент массива до которого мы имеем доступ в части
# если -1 то часть недоступна
# бля, ставим от 0 до 4 или null, -- это доступные индексы
const MAX_FOR_MAX_PARTS = 4
static var max_parts = [MAX_FOR_MAX_PARTS, MAX_FOR_MAX_PARTS, MAX_FOR_MAX_PARTS , null , null]

static var current_blob_state = [0, 0, 0, null, null]
static var true_blob_state = [1, 1, 1, null, null]

static func resetBlobState():
	for i in range(len(current_blob_state)):
		if current_blob_state[i] == null:
			continue
		current_blob_state[i] = 0

static func shuffleTrueBlobState(lvl):
	for i in range(len(max_parts)):
		max_parts[i] = MAX_FOR_MAX_PARTS
	if lvl == 1:
		max_parts[-1] = null
		max_parts[-2] = null
	elif lvl == 2:
		max_parts[-1] = null
	for i in range(len(true_blob_state)):
		if max_parts[i] == null:
			true_blob_state[i] = null
			continue
		true_blob_state[i] = rng.randi_range(0, max_parts[i])
	print("Current TRUE BLOB STATE: ",true_blob_state)
	

static func checkWinPercent():
	var filteredTrueState = true_blob_state.filter(func(value):
		return value != null)
	var size = filteredTrueState.size()
	
	var index = 0
	var successCount = current_blob_state.filter(func(value):
		var success = value == true_blob_state[index]
		index = index +1
		return success).size()
	return snapped(float(successCount) / size, 0.01) * 100



# тут прост для удобство адреса всех пикч
#static var PARTS = {
	#'EYE_1': "res://assets/pics/blob/parts/eye/1.png",
	#'EYE_2': "res://assets/pics/blob/parts/eye/2.png"
#}

static var clue = [0, 1]

# здесь показываются части, которые доступны будут при максимальной прокачке
#static var PARTS_1: Array[String] = [PARTS['EYE_1'], PARTS['EYE_2']]

static var PARTS_PER_ROW = 5

static func set_true_blob_state(newState: Array) -> void:
	true_blob_state = newState

static func set_current_blob_state_part(value: int, part_index: int) -> void:
	current_blob_state[part_index] =  value
	
	
static func set_current_blob_state(newState: Array) -> void:
	true_blob_state = newState

func reset_current_blob_state(lvl) -> void:
	for i in range(len(current_blob_state)):
		current_blob_state[i] = 0
	if lvl == 1:
		current_blob_state[-1] = null
		current_blob_state[-2] = null
	elif lvl == 2:
		current_blob_state[-1] = null
	

static func reset_game() -> void:
	lives = 10
	current_level = 1
	shuffleTrueBlobState(current_level)


func next_level(just_reset=false) -> void:
	var next = current_level + 1
	if just_reset:
		next = current_level
	shuffleTrueBlobState(next)
	reset_current_blob_state(next)
	lives = 10

	var root = get_tree().root
	var camera_view = root.get_node_or_null("PlayerScene/CameraView")
	print("CameraView: ", camera_view)
	if camera_view:
		var level_node = camera_view.get_node_or_null("Level")
		print("Level node: ", level_node)
		if level_node:
			level_node.change_lvl(next)
	var attempt_node = root.get_node_or_null("PlayerScene/CameraView/Attempt")
	if attempt_node:
		attempt_node.change_lives(lives)
	var progress_node = root.get_node_or_null("PlayerScene/CameraView/ProgressBar")
	if progress_node:
		progress_node.set_percent(0)
	var editor_node = root.get_node_or_null("PlayerScene/CanvasLayerEditor/Editor")
	if editor_node:
		editor_node.updateTextureParts()
	var next_level_node = root.get_node_or_null("PlayerScene/CameraView/NextLevel")
	if next_level_node:
		next_level_node.hide_button()

	if current_level == 3:
		var win_node = root.get_node_or_null("PlayerScene/Win")
		if win_node:
			win_node.toggle_curtain()
	else:
		var load_level_node = root.get_node_or_null("PlayerScene/LoadLevel")
		if load_level_node:
			load_level_node.flash_curtain()

	current_level = next
