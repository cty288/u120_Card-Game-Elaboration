/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if(global.player_card_sum==global.target_value && global.state==state.player_turn){
	if(!sound_played){
		sound_played=true;
		audio_play_sound(correct,1,false);
	}
	active=true;
}else{
	sound_played=false;
	active=false;
}
if(active){
	obj_play_button_effect.start=true;
}else{
	obj_play_button_effect.start=false;
}
