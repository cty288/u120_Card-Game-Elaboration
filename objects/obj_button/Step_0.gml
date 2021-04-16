/// @description Insert description here
// You can write your code in this editor
image_blend =  merge_color(image_blend,target_color,0.1);
if(active){
	if(position_meeting(mouse_x,mouse_y,id)){
		if(mouse_check_button(mb_left)){
			target_color=make_color_rgb(180,180,180);
		}else{
			target_color=make_color_rgb(220,220,220);
		}
		
		if(mouse_check_button_released(mb_left)){
			OnClicked();
			audio_play_sound(click,1,false);
		}
		
	}else{
		target_color=c_white;
	}
}else{
	target_color=c_gray;
}
