/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if(global.state==state.start_deal_opponent || global.state==state.start_deal_player
||global.state==state.sort_player||global.state==state.generate_target_value||
global.state==state.player_turn||global.state==state.deal_opponent||global.state==state.deal_player){
	visible=true;
	active=true;
}else{
	visible=false;
	active=false;

}

if(tutorial_on){
	image_index=1;
}else{
	image_index=0;
}