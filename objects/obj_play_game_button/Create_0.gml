active=true;
image_blend=c_gray;
target_color=c_gray;
image_angle=0;
animation_speed=0.08*room_speed;

alarm[0]=0.1*room_speed;
function OnClicked(){
	global.state=state.start_deal_opponent;
}