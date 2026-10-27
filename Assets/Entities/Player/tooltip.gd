extends PanelContainer

@export var buildings: Array[BuildingData]

@onready var heading: RichTextLabel = $Heading
@onready var content: RichTextLabel = $Content
@onready var player = $"../../.."
@onready var anim: AnimationPlayer = $AnimationPlayer

var lookup := {}
var last_target := "<none>"   # not "", so the first frame still runs

func _ready() -> void:
	visible = false
	for b in buildings:
		lookup[b.id] = b

func _process(_delta: float) -> void:
	var target: String = player._check_look_target() #string
	if target == last_target:
		return
	last_target = target

	# looking at nothing -> hide
	if target == "":
		if visible:
			anim.play("exit")
		return

	visible = true
	var data: BuildingData = lookup.get(target)
	if data == null:
		heading.text = "[b]%s[/b]" % target
		content.text = "[color=red]No description found in the database.[/color]\nAdd a BuildingData with id = \"%s\"" % target
	else:
		heading.text = "[b]%s[/b]" % data.display_name
		content.text = data.description if data.description != "" else "[color=orange]Entry exists but description is empty.[/color]"

	visible = true
	anim.play("entry") 
	
	#anim.play("exit")
	
	
func _refresh_size() -> void:
	await get_tree().process_frame
	reset_size()
