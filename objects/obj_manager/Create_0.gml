enum state{
	menu,
	start_deal_opponent,
	start_deal_player,
	sort_player,
	generate_target_value,
	player_turn,
	play_cards,
	wait_opponent,
	opponent_turn,
	compare,
	compare_wait,
	tie,
	win_shuffle,
	win_deal,
	lose_shuffle,
	lose_deal,
	end_of_turn,
	deal_opponent,
	deal_player,
	end_of_game,
	announce_winner
}
/*parts=part_system_create();
spark = part_type_create();
part_type_shape(spark,pt_shape_snow);
part_type_size(spark,0,0.5,0.1,0);
part_type_speed(spark,5,10,-0.10,0);
part_type_direction(spark,0,359,0,0);
part_type_color3(spark,c_white,c_yellow,c_red);
part_type_life(spark,15,30);*/


global.player_card_sum=0;
global.opponent_card_sum=0;

randomize();
deck_x= 64;
deck_y= room_height/4+130;

card_height=1.5;

hand_x=250;
hand_y=room_height-220;

opponent_hand_x=250;
opponent_hand_y=20;

discard_x=room_width-150;
discard_y=room_height/2-100;

opponent_played_card_x=410;
opponent_played_card_y=room_height/4;

player_played_card_x=410;
player_played_card_y=room_height/4+200;

shuffle_time=0;

hand_size=8;
card_interval=110;

sort_time=0;

is_player_skipped=false;
is_opponent_skipped=false;

wait_sign = instance_create_layer(250,184,"Instances",obj_wait);
wait_sign.visible=false;

deal_time=0;

global.num_cards=80;
global.state=state.menu;

global.deck=ds_list_create();
global.hand=ds_list_create();
global.opponent_hand=ds_list_create();
global.discard=ds_list_create();
global.selected_card=ds_list_create();
global.player_played_cards=ds_list_create();
global.opponent_played_cards=ds_list_create();

global.hovered_card=noone;



global.AI_processing=false;

global.opponent_score=0;
global.player_score=0;

global.loser_get_num=0;

global.target_value=0;

global.winner=-1;
is_win_turn=false;
permenant_loser_amount=0;
wait_timer=0;
deal_timer=0;
deck_holder= instance_create_layer(deck_x,deck_y,"Instances",obj_placeholder);
discard_holder = instance_create_layer(discard_x,discard_y,"Instances",obj_placeholder);

deck_holder.depth=299;
discard_holder.depth=299;
win_alpha=0;
win_alpha_increase=true;
winning_celebration_card_x=room_width/2;
winning_celebration_card_y=room_height/2;
winning_celebration_index=0;
end_alpha=0;
win_reason="";
for(var i=0; i<global.num_cards-6; i++){
	var new_card=instance_create_layer(deck_x,deck_y,"Instances",obj_card);
	new_card.face_up=false;
	if(0<=i && i<round(global.num_cards*0.28)){ //28% distribution
		new_card.face_index=card_face.one;
	}else if(round(global.num_cards*0.28)<=i && i<round(global.num_cards*0.56)){ //28% distribution
		new_card.face_index=card_face.two;
	}else if(round(global.num_cards*0.56)<=i && i<round(global.num_cards*0.78)){ //23% distribution
		new_card.face_index=card_face.three;
	}else if(round(global.num_cards*0.78)<=i && i<round(global.num_cards*0.93)){//15% distribution
		new_card.face_index=card_face.four;
	}else{ //7% distribution
		new_card.face_index=card_face.five;
	}

	ds_list_add(global.deck,new_card);
}

for(var i=0; i<4; i++){ //wild card *4
	var new_card=instance_create_layer(deck_x,deck_y,"Instances",obj_card);
	new_card.face_up=false;
	new_card.face_index=card_face.wild;
	ds_list_add(global.deck,new_card);
}

for(var i=0; i<2; i++){ //10-value card *2
	var new_card=instance_create_layer(deck_x,deck_y,"Instances",obj_card);
	new_card.face_up=false;
	new_card.face_index=card_face.ten;
	ds_list_add(global.deck,new_card);
}

ds_list_shuffle(global.deck);


for(var i=0; i<global.num_cards; i++){
	global.deck[|i].target_x=deck_x;
	global.deck[|i].target_y=deck_y-card_height*i;
	global.deck[|i].x=deck_x;
	global.deck[|i].y=deck_y-card_height*i;
	global.deck[|i].depth=global.num_cards-i;
}