/// @description Insert description here
// You can write your code in this editor

if(face_index==card_face.wild && ds_list_find_index(global.hand,id)>=0){
	if(!selected){
		if(global.target_value-global.player_card_sum>=5){
			wild_card_value=5;
		}else if(global.target_value-global.player_card_sum<=0){
			wild_card_value=1;
		}else{
			wild_card_value = global.target_value-global.player_card_sum;
		}
	}	
}


if(face_index==card_face.wild && ds_list_find_index(global.opponent_hand,id)>=0){
	if(global.target_value-global.opponent_card_sum>=5){
		wild_card_value=5;
	}else if(global.target_value-global.opponent_card_sum<=0){
		wild_card_value=1;
	}else{
		wild_card_value = global.target_value-global.opponent_card_sum;
	}
	
}

if(face_index==card_face.wild && face_up){
	if(selected || hovered || ds_list_find_index(global.opponent_played_cards,id)>=0){
		image_index=wild_card_value;
	}else if(!selected && ds_list_find_index(global.hand,id) && !hovered){
		image_index=0;
	}
}

if(position_meeting(mouse_x,mouse_y,id)){
	if(ds_list_find_index(global.hand,id)>=0){
		if(global.state==state.player_turn){
			if(!hovered && !selected){
				hovered=true;
				target_y=room_height-220-20;
				audio_play_sound(hover,1,false);
			}	
		}
		global.hovered_card=id;
	}
}else if(global.hovered_card==id){
	global.hovered_card=noone;
}else{
	if(hovered){
		hovered=false;
		target_y=room_height-220;
	}
}

if(selected){
	target_y=room_height-220-60;
	hovered=false;
}else{
	if(ds_list_find_index(global.hand,id)>=0 && global.state!=state.player_turn){
		target_y =room_height-220;
	}
}

if(x!=target_x){
	x=lerp(x,target_x,lerp_value);
}

if(y!=target_y){
	y=lerp(y,target_y,lerp_value);
}
