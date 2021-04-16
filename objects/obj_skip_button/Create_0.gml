/// @description Insert description here
// You can write your code in this editor
active=false;
image_blend=c_gray;
target_color=c_gray;

function OnClicked(){
	global.state=state.play_cards;
	obj_manager.is_player_skipped=true;
}