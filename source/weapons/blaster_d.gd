extends Node3D

@export var ammo : int = 30
@export var rof := 720.0 # per minute

var rof_time := 0.0
var current_ammo : int = 0
var rounds_per_second : float = 0.0

@onready var muzzle_flash := $MuzzleFlash
@onready var shot_audio := $ShotSound
@onready var reload_audio := $ReloadSound


func _ready() -> void:
	muzzle_flash.visible = false
	rounds_per_second = 60 / rof
	current_ammo = ammo


func _physics_process(delta: float) -> void:
	rof_time += delta


func use():
	if current_ammo > 0:
		if rounds_per_second <= rof_time:
			shot_animation()
			owner.recoil(Vector2(0.01, 0.01 * sign(randf()*2-1)))
			rof_time = 0.0
			current_ammo -= 1
#			print(current_ammo)


func shot_animation():
	var recoil_animation_time : float = min(rounds_per_second * 0.25, 0.05)
	var recover_animation_time : float = min(rounds_per_second * 0.75, 0.15)
	muzzle_flash.show()
	shot_audio.pitch_scale = randf_range(0.9, 1.1)
	shot_audio.play()
	var tween = create_tween()
	if not ads:
		tween.tween_property( self, "position:z", randf_range(0.035, 0.045), recoil_animation_time ).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property( self, "position:z", 0.0, recoil_animation_time ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( self, "position:y", randf_range(0.005, 0.015), recoil_animation_time ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( self, "position:x", randf_range(-0.005, 0.005), recoil_animation_time ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( self, "rotation:x", deg_to_rad( randf_range(-1.5, -0.5) ), recoil_animation_time ).set_trans(Tween.TRANS_SINE)

	tween.tween_property( self, "position:z", 0.0, recover_animation_time ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( self, "position:y", 0.0, recover_animation_time ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( self, "position:x", 0.0, recover_animation_time ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( self, "rotation:x", 0.0, recover_animation_time ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_callback(muzzle_flash.hide)


func reload():
	reload_audio.play()
	current_ammo = ammo

var ads := false
func set_ads(on_off : bool):
	ads = on_off
