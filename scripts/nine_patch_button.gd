class_name NinePatchButton

extends Button

@onready var nine_patch_rect: NinePatchRect = $NinePatchRect

#define position from the gui texture the 9-patch will take from depnding on condition
@export var idle_position: Vector2 = Vector2(77,0)
@export var hover_position: Vector2 = Vector2(86,0)
@export var press_position: Vector2 = Vector2(104,0)


func _ready() -> void:
    mouse_entered.connect(_mouse_entered)
    mouse_exited.connect(_mouse_exited)
    button_down.connect(_button_down)
    button_up.connect(_button_up)


func _mouse_entered() -> void:
    nine_patch_rect.region_rect.position = hover_position
    

func _mouse_exited() -> void:
    nine_patch_rect.region_rect.position = idle_position


func _button_down() -> void:
    nine_patch_rect.region_rect.position = press_position


func _button_up() -> void:
    nine_patch_rect.region_rect.position = hover_position

    
