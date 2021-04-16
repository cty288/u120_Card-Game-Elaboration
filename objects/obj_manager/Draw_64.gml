
draw_set_font(font_gui);
draw_set_halign(fa_middle);
draw_set_valign(fa_middle);

if(global.state!=state.menu){
	draw_set_color(c_blue);
	draw_text_transformed(120,190,"Score: "+string(global.opponent_score),0.7,0.7,0);
	draw_set_color(make_color_rgb(157,255,137));
	draw_text_transformed(120,room_height-190,"Score: "+string(global.player_score),0.7,0.7,0);

	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_text_transformed(1255,230,":"+string(ds_list_size(global.opponent_hand))+"/10",0.5,0.5,0);
	draw_text_transformed(1255,762,":"+string(ds_list_size(global.hand))+"/10",0.5,0.5,0);
	
	draw_sprite_ext(spr_card_back,0,1232.702,189.2,0.265,0.235,-33.151,c_white,1);
	draw_sprite_ext(spr_card_back,0,1232.702,721,0.265,0.235,-33.151,c_white,1);
	
	if(global.draw_deck_size_gui){
		draw_set_halign(fa_middle);
		draw_set_valign(fa_middle);
		draw_sprite_ext(spr_deck_size_ui,0,mouse_x,mouse_y,0.7,0.5,0,c_white,1);
		draw_text_ext_transformed(mouse_x,mouse_y-5,"There are "+string(ds_list_size(global.deck))
		+" cards in the deck",50,500,0.42,0.42,0);
	}
	
}else{
	win_alpha=0;
	draw_sprite(spr_title,0,183,12);
}

if(global.state==state.compare_wait){
	if(win_alpha_increase){
		win_alpha+=0.08;
		if(win_alpha>=1){
			win_alpha_increase=false;
		}
	}else{
		win_alpha-=0.08;
	}

	if(is_win_turn){
		draw_sprite_ext(spr_player_turn_win_effect,0,0,0,1,1,0,c_white,win_alpha);
	}else{
		draw_sprite_ext(spr_opponent_turn_win_effect,0,0,0,1,1,0,c_white,win_alpha);
	}
}else{
	win_alpha=0.01;
	win_alpha_increase=true;
}


if(global.state==state.win_deal){
	draw_sprite_ext(spr_card_small,0,646,177,1,1,-30,c_white,1);
	draw_set_color(c_orange);
	draw_text_transformed(666,217,"+"+string(permenant_loser_amount),0.5,0.5,0);
}

if(global.state==state.lose_deal){
	draw_sprite_ext(spr_card_small,0,646,637,1,1,-30,c_white,1);
	draw_set_color(c_orange);
	draw_text_transformed(666,677,"+"+string(permenant_loser_amount),0.5,0.5,0);
}

draw_set_color(c_white);

if(is_player_skipped){
	draw_sprite(spr_skip,0,576,512);
}

if(is_opponent_skipped){
	draw_sprite(spr_skip,0,576,254);
}


if(global.state==state.announce_winner){
	end_alpha+=0.01;
	draw_set_alpha(end_alpha);
	
	draw_rectangle_color(0,0,2000,2000,c_black,c_black,c_black,c_black,false);
	draw_set_halign(fa_middle);
	draw_set_valign(fa_middle);
	
	if(global.winner!=-1){
		if(global.winner==1){
			draw_sprite_ext(player2_profile_pic,0,550,250,4,4,0,c_white,end_alpha);	
		}else if(global.winner==0){
			draw_sprite_ext(player1_profile_pic,0,550,250,4,4,0,c_white,end_alpha);	
		}else{

		}
		draw_sprite_ext(spr_winner,0,600,300,0.3,0.3,0,c_white,end_alpha);	
	}else{
		draw_sprite_ext(player2_profile_pic,0,400,200,4,4,0,c_white,end_alpha);	
		draw_sprite_ext(player1_profile_pic,0,700,200,4,4,0,c_white,end_alpha);	
		draw_text(room_width/2,530, "Tie");
	}
	
	draw_set_color(c_white);
	//show_debug_message("mouse_x:" + string(mouse_x) +"    mouse_y:"+string( mouse_y));
	draw_sprite_ext(spr_ending_restart_button,0,room_width/2-100,800,0.2,0.2,0,c_white,end_alpha);
	draw_text_transformed(room_width/2,600,win_reason,0.7,0.7,0);
}else{
	end_alpha=0;
	draw_set_alpha(1);
}