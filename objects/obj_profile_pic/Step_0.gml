/// @description Insert description here
// You can write your code in this editor

/*if(global.state!=state.announce_winner){
	target_x=original_x;
	target_y=original_y;
}else{
	if(global.winner==0 && player_id==global.winner){
		target_x=win_x;
		target_y=win_y
		target_x_scale=4;
		target_y_scale=4;
	}else if(global.winner==1 && player_id==global.winner){
		target_x=win_x;
		target_y=win_y
		target_x_scale=4;
		target_y_scale=4;
	}else if(global.winner==-1){
		target_x=tie_x;
		target_y=tie_y;
		target_x_scale=4;
		target_y_scale=4;
	}
}


x=lerp(x,target_x,0.02);
y=lerp(y,target_y,0.02);

image_xscale=lerp(image_xscale,target_x_scale,0.05);
image_yscale=lerp(image_yscale,target_y_scale,0.05);

