
/*emitter=part_emitter_create(parts);
part_emitter_region(parts,emitter,50,60,150,160,ps_shape_ellipse,ps_distr_gaussian);
part_emitter_stream(parts,emitter,spark,1);*/

//part_particles_create(parts,200,150,spark,5);
if(global.state==state.menu){
	if(!audio_is_playing(Cuteambient_Main_Menu_B)){
		audio_play_sound(Cuteambient_Main_Menu_B,1,true);
	}
	audio_stop_sound(Cuteambient_Gameplay_B);
	audio_stop_sound(Cuteambient_Game_Over_B);
}else if(global.state==state.announce_winner || global.state==state.end_of_game){
	if(!audio_is_playing(Cuteambient_Game_Over_B)){
		audio_play_sound(Cuteambient_Game_Over_B,1,true);
	}
	audio_stop_sound(Cuteambient_Gameplay_B);
	audio_stop_sound(Cuteambient_Main_Menu_B);
}else{
	if(!audio_is_playing(Cuteambient_Gameplay_B)){
		audio_play_sound(Cuteambient_Gameplay_B,1,true);
	}
	audio_stop_sound(Cuteambient_Game_Over_B);
	audio_stop_sound(Cuteambient_Main_Menu_B);
}



switch(global.state){
	case state.start_deal_opponent:		
		var cards_in_hand=ds_list_size(global.opponent_hand);
		if(cards_in_hand<hand_size && wait_timer>0.2*room_speed){
			var dealt_card=global.deck[| ds_list_size(global.deck)-1];
			dealt_card.target_x=opponent_hand_x+cards_in_hand*card_interval;
			dealt_card.target_y=opponent_hand_y;
			ds_list_add(global.opponent_hand,dealt_card);
			ds_list_delete(global.deck,ds_list_size(global.deck)-1);

			//dealt_card.face_up=true;
			audio_play_sound(play_card,1,false);
			wait_timer=0;
		}else if(cards_in_hand==hand_size && wait_timer>0.2*room_speed){
			global.state=state.start_deal_player;
			wait_timer=0;
		}
		wait_timer++;
	break;
	case state.start_deal_player:
		var cards_in_hand=ds_list_size(global.hand);
		if(cards_in_hand<hand_size && wait_timer>0.2*room_speed){
			var dealt_card=global.deck[| ds_list_size(global.deck)-1];
			dealt_card.target_x=hand_x+cards_in_hand*card_interval;
			dealt_card.target_y=hand_y;
			ds_list_add(global.hand,dealt_card);
			ds_list_delete(global.deck,ds_list_size(global.deck)-1);

			audio_play_sound(play_card,1,false);
			wait_timer=0;
		}else if(cards_in_hand==hand_size && wait_timer>0.5*room_speed){
			for(var i=0; i<ds_list_size(global.hand);i++){
				global.hand[|i].face_up=true;
			}
			audio_play_sound(flip,1,false);
			ds_list_sort(global.hand,true);
			ds_list_sort(global.opponent_hand,true);
			//Sleep(2000);
			global.state=state.sort_player;
			wait_timer=0;
			
			
		}
		wait_timer++;
	break;
	case state.sort_player:
		if(wait_timer>0.4*room_speed){
			deal_timer++;
			if(sort_time < 10 && deal_timer>0.05*room_speed){
				deal_timer=0;
				//wait_timer=0;
				if(ds_list_size(global.hand)>=sort_time+1){
					global.hand[|sort_time].target_x=hand_x+sort_time*card_interval;
					audio_play_sound(play_card,1,false);
				}
				if(ds_list_size(global.opponent_hand)>=sort_time+1){
					global.opponent_hand[|sort_time].target_x=opponent_hand_x+sort_time*card_interval;
				}
				
				sort_time++;
			}else if(sort_time>=10 && wait_timer>0.6*room_speed){
				
				global.state=state.generate_target_value;
				wait_timer=0;
				deal_timer=0;
				sort_time=0;
			}
		}

		wait_timer++;
	break;
	case state.generate_target_value:
		show_debug_message("dwada");
		if(wait_timer>1*room_speed){
			
			//70% to generate a value from 1-12; 30% to generate a larger value from 12-20
			var temp = irandom_range(1,10);
			if(ds_list_size(global.hand)<=5 || ds_list_size(global.opponent_hand)<=5){
				global.target_value=irandom_range(1,10);
			}else{
				if(temp<=7){
					global.target_value=irandom_range(1,15);
				}else{
					global.target_value=irandom_range(15,20);
				}
			}

			
			global.state=state.player_turn;
		}else{
			if(!audio_is_playing(beep)){
				audio_play_sound(beep,1,false);}
			
		}
		wait_timer++;
	break;
	case state.player_turn:
		var cards_in_hand=ds_list_size(global.hand);
		if(mouse_check_button_pressed(mb_left)){
			if(global.hovered_card!=noone){
				wait_timer=0;
				
				if(!global.hovered_card.selected){
					if(ds_list_size(global.selected_card)<5){
						ds_list_add(global.selected_card,global.hovered_card);
						global.hovered_card.selected=true;
						global.player_card_sum+=global.hovered_card.get_value();
						//TODO: play a sound here
						audio_play_sound(select,1,false);
					}else{
						//TODO: play a sound here
					}
					
				}else{
					var idx= ds_list_find_index(global.selected_card,global.hovered_card);
					ds_list_delete(global.selected_card,idx);
					global.hovered_card.selected=false;
					global.player_card_sum-=global.hovered_card.get_value();
				}
				/*var idx=ds_list_find_index(global.hand,global.selected_card);
				ds_list_delete(global.hand,idx);
				audio_play_sound(play_card,1,false);
				global.state=state.compare*/
			}
		}
		
	break;
	case state.play_cards:	
		if(!is_player_skipped){
			//TODO: play a sound here
			ds_list_sort(global.selected_card,true);
			
			for(var i=0; i<ds_list_size(global.selected_card); i++){
				global.selected_card[|i].selected=false;
				ds_list_add(global.player_played_cards,global.selected_card[|i]);
				var inx=ds_list_find_index(global.hand,global.selected_card[|i]);
				ds_list_delete(global.hand,inx);
			}
			
			ds_list_clear(global.selected_card);
		}else{
			
		}
		
		global.state=state.wait_opponent;
		
	break;
	case state.wait_opponent:
		wait_timer++;
		if(!audio_is_playing(clock)){
			audio_play_sound(clock,1,false);
		}
		
		if(wait_timer<=random_range(1.5*room_speed,2.5*room_speed)){
			wait_sign.visible=true;
		}else{
			wait_sign.visible=false;
			if(!is_player_skipped){
			
			for(var i=0; i<ds_list_size(global.player_played_cards);i++){
				global.player_played_cards[|i].target_x = player_played_card_x+card_interval*i;
				global.player_played_cards[|i].target_y=player_played_card_y;
			}
		}else{
			for(var i=0; i<ds_list_size(global.selected_card); i++){
				global.selected_card[|i].selected=false;
				show_debug_message("dd");
			}
			ds_list_clear(global.selected_card);
			}
			
			wait_timer=0;
			audio_stop_sound(clock);
			global.state=state.opponent_turn;
		}
		
	
	break;
	case state.opponent_turn:
		wait_timer++;
		global.AI_processing=true;
		var sum=0;
		var succeed=false;
		var temp_selected=ds_list_create();
		//Opponent play cards
		if(ds_list_size(global.opponent_hand)>=5){
			for(var i=0; i<ds_list_size(global.opponent_hand)-4;i++){
				ds_list_add(temp_selected,global.opponent_hand[|i]);
				sum+=global.opponent_hand[|i].get_value();
				succeed=sum==global.target_value;	
				
				if(succeed){
					break;
				}else{
					for(var j=i+1; j<ds_list_size(global.opponent_hand)-3;j++){
						ds_list_add(temp_selected,global.opponent_hand[|j]);
						sum+=global.opponent_hand[|j].get_value();
						succeed=sum==global.target_value;	
				
						if(succeed){
							break;
						}else{
							for(var k=j+1; k<ds_list_size(global.opponent_hand)-2;k++){
								ds_list_add(temp_selected,global.opponent_hand[|k]);
								sum+=global.opponent_hand[|k].get_value();
								succeed=sum==global.target_value;	
				
								if(succeed){
									break;
								}else{
									for(var l=k+1; l<ds_list_size(global.opponent_hand)-1;l++){
										ds_list_add(temp_selected,global.opponent_hand[|l]);
										sum+=global.opponent_hand[|l].get_value();
										succeed=sum==global.target_value;	
				
										if(succeed){
											break;
										}else{
											for(var m=l+1; m<ds_list_size(global.opponent_hand);m++){
												ds_list_add(temp_selected,global.opponent_hand[|m]);
										
												sum+=global.opponent_hand[|m].get_value();
												succeed=sum==global.target_value;	
				
												if(succeed){
													break;
												}else{
													ds_list_delete(temp_selected, 4);
													sum-=global.opponent_hand[|m].get_value();
												}
											}										
										}

								
										if(succeed){
											break;
										}else{
											ds_list_delete(temp_selected, 3);
											sum-=global.opponent_hand[|l].get_value();
										}
									}
								}


						
								if(succeed){
									break;
								}else{
									ds_list_delete(temp_selected, 2);
									sum-=global.opponent_hand[|k].get_value();
								}						
							}	
						}

		
						if(succeed){
							break;
						}else{
							ds_list_delete(temp_selected, 1);
							sum-=global.opponent_hand[|j].get_value();
						}
					}
				}
				

			
				if(succeed){
					break;
				}else{
					ds_list_delete(temp_selected, 0);
					sum-=global.opponent_hand[|i].get_value();
				}
			}
		}else{
			for(var i=0; i<ds_list_size(global.opponent_hand);i++){
				sum+=global.opponent_hand[|i].get_value();
				ds_list_add(temp_selected,global.opponent_hand[|i]);
				if(sum==global.target_value){
					succeed=true;
					break;
				}
			}
		}

		global.AI_processing=false;
		
		if(succeed){
			is_opponent_skipped=false;
			
			ds_list_sort(temp_selected,true);
			for(var i=0; i<ds_list_size(temp_selected); i++){
				temp_selected[|i].face_up=true;
				
				ds_list_add(global.opponent_played_cards,temp_selected[|i]);
				
				var inx=ds_list_find_index(global.opponent_hand,temp_selected[|i]);
				ds_list_delete(global.opponent_hand,inx);
			}
			
			ds_list_clear(temp_selected);
			
			for(var i=0; i<ds_list_size(global.opponent_played_cards);i++){
				global.opponent_played_cards[|i].target_x = opponent_played_card_x+card_interval*i;
				global.opponent_played_cards[|i].target_y=opponent_played_card_y;
			}
			
		}else{
			is_opponent_skipped=true;
		}
		
		
		//rearrange both player's hands
		Sleep(800);
		//TODO: play a sound

		for(var i=0; i<ds_list_size(global.hand); i++){
			global.hand[|i].target_x=hand_x+i*card_interval;
		}
		
		for(var i=0; i<ds_list_size(global.opponent_hand); i++){
			global.opponent_hand[|i].target_x=opponent_hand_x+i*card_interval;
		}
		
		global.state=state.compare;
		wait_timer=0;
		if(!is_opponent_skipped || !is_player_skipped){
			audio_play_sound(play_card_2,1,false);
		}else if(is_opponent_skipped && is_player_skipped){
			audio_play_sound(click,1,false);
		}
		
	
	break;
	case state.compare:
		wait_timer++;
		var opponent_played_cards_size=ds_list_size(global.opponent_played_cards);
		var player_played_cards_size=ds_list_size(global.player_played_cards);
		
		if(wait_timer>1*room_speed){
			wait_timer=0;
			if(ds_list_size(global.hand)==0 || ds_list_size(global.opponent_hand)==0){
				audio_play_sound(game_end,1,false);
				//Game ends
				if(ds_list_size(global.hand)==0){
					global.winner=1;
					win_reason="Played all cards in hand";
				}else if(ds_list_size(global.opponent_hand)==0){
					global.winner=0;
					win_reason="Played all cards in hand";
				}else{
					global.winner=-1 //tie
					win_reason="Both played all cards in hand";
				}
				winning_celebration_index=ds_list_size(global.discard)-1;
				global.state=state.end_of_game
				
			}else if(opponent_played_cards_size==player_played_cards_size){
				global.state=state.tie;
			}else if(opponent_played_cards_size>player_played_cards_size){
				audio_play_sound(lose,1,false);
				ds_list_shuffle(global.opponent_played_cards);
				global.loser_get_num=opponent_played_cards_size-player_played_cards_size;
				global.opponent_score+=global.loser_get_num;
				permenant_loser_amount=global.loser_get_num;
				global.state=state.compare_wait;
				is_win_turn=false;

			}else{
				audio_play_sound(win,1,false);
				global.loser_get_num=player_played_cards_size-opponent_played_cards_size;
				permenant_loser_amount=global.loser_get_num;
				global.player_score+=global.loser_get_num;
				ds_list_shuffle(global.player_played_cards);
				global.state=state.compare_wait;
				is_win_turn=true;

			}
		}
		



	break;
	case state.compare_wait:
		wait_timer++;
		if(wait_timer>=1.2*room_speed){
			audio_play_sound(flip,1,false);
			wait_timer=0;
			if(is_win_turn){
				for(var i=0; i<ds_list_size(global.player_played_cards); i++){
					global.player_played_cards[|i].face_up=false;
				}
				global.state=state.win_shuffle;
			}else{
				for(var i=0; i<ds_list_size(global.opponent_played_cards); i++){
					global.opponent_played_cards[|i].face_up=false;
				}
				global.state=state.lose_shuffle;
			}
		}
		
	break;
	case state.tie:
		var opponent_played_cards_size=ds_list_size(global.opponent_played_cards);
		var player_played_cards_size=ds_list_size(global.player_played_cards);
		wait_timer++;
		
		if(wait_timer>0.3*room_speed){
			if(opponent_played_cards_size>0){
				var discarded_card=global.opponent_played_cards[|0];
				discarded_card.face_up=true;
				ds_list_add(global.discard,discarded_card);
				ds_list_delete(global.opponent_played_cards,0);
			
				discarded_card.target_x=discard_x
				discarded_card.target_y=discard_y;
				discard_y-=card_height;
				audio_play_sound(play_card,1,false);
				discarded_card.depth=global.num_cards-ds_list_size(global.discard);
				wait_timer=0;
			}else if(player_played_cards_size>0){
				var discarded_card=global.player_played_cards[|0];
				discarded_card.face_up=true;
				ds_list_add(global.discard,discarded_card);
				ds_list_delete(global.player_played_cards,0);
			
				discarded_card.target_x=discard_x
				discarded_card.target_y=discard_y;
				discard_y-=card_height;
				audio_play_sound(play_card,1,false);
				discarded_card.depth=global.num_cards-ds_list_size(global.discard);
				wait_timer=0;			
			}else{
				is_opponent_skipped=false;
				is_player_skipped=false;
				global.state=state.end_of_turn;
			}
		}
	break;
	case state.lose_shuffle:
		for(var i=0; i<ds_list_size(global.opponent_played_cards);i++){
			global.opponent_played_cards[|i].target_x = opponent_played_card_x+card_interval*i;
		}
		global.state=state.lose_deal;
	break;
	
	case state.lose_deal:
		var opponent_played_cards_size=ds_list_size(global.opponent_played_cards);
		var player_played_cards_size=ds_list_size(global.player_played_cards);
		wait_timer++;
		if(wait_timer>1*room_speed){
			if(wait_timer>1.3*room_speed){
				if(player_played_cards_size>0){
					var discarded_card=global.player_played_cards[|0];
					discarded_card.face_up=true;
					ds_list_add(global.discard,discarded_card);
					ds_list_delete(global.player_played_cards,0);
			
					discarded_card.target_x=discard_x
					discarded_card.target_y=discard_y;
					discard_y-=card_height;
					audio_play_sound(play_card,1,false);
					discarded_card.depth=global.num_cards-ds_list_size(global.discard);
					wait_timer=1*room_speed;			
				}else if(opponent_played_cards_size>0){
					if(ds_list_size(global.hand)<10 && global.loser_get_num>0){
						global.loser_get_num--;
						wait_timer=1*room_speed;			
						var dealt_card=global.opponent_played_cards[|0];
						dealt_card.face_up=true;
						dealt_card.target_x= hand_x+ds_list_size(global.hand)*card_interval;
						dealt_card.target_y= hand_y;
						ds_list_add(global.hand,dealt_card);

						audio_play_sound(play_card,1,false);

						ds_list_delete(global.opponent_played_cards,0);
					}else{
						var discarded_card=global.opponent_played_cards[|0];
						ds_list_add(global.discard,discarded_card);
						ds_list_delete(global.opponent_played_cards,0);
						discarded_card.face_up=true;
						discarded_card.target_x=discard_x
						discarded_card.target_y=discard_y;
						discard_y-=card_height;
						audio_play_sound(play_card,1,false);
						discarded_card.depth=global.num_cards-ds_list_size(global.discard);
						wait_timer=1*room_speed;			
					}
				}else{
					is_opponent_skipped=false;
					is_player_skipped=false;
					global.state=state.end_of_turn;
				}
			}
		}

		
	break;
	
	case state.win_shuffle:
		for(var i=0; i<ds_list_size(global.player_played_cards);i++){
			global.player_played_cards[|i].target_x = player_played_card_x+card_interval*i;
		}
		global.state=state.win_deal;
	break;
	
	case state.win_deal:
		var opponent_played_cards_size=ds_list_size(global.opponent_played_cards);
		var player_played_cards_size=ds_list_size(global.player_played_cards);
		

		wait_timer++;
		if(wait_timer>1*room_speed){
			if(wait_timer>1.3*room_speed){
				if(opponent_played_cards_size>0){
					var discarded_card=global.opponent_played_cards[|0];
					discarded_card.face_up=true;
					ds_list_add(global.discard,discarded_card);
					ds_list_delete(global.opponent_played_cards,0);
			
					discarded_card.target_x=discard_x
					discarded_card.target_y=discard_y;
					discard_y-=card_height;
					audio_play_sound(play_card,1,false);
					discarded_card.depth=global.num_cards-ds_list_size(global.discard);
					wait_timer=1*room_speed;			
				}else if(player_played_cards_size>0){
					if(ds_list_size(global.opponent_hand)<10 && global.loser_get_num>0){
						global.loser_get_num--;
						wait_timer=1*room_speed;
						var dealt_card=global.player_played_cards[|0];
						dealt_card.face_up=false;
						dealt_card.target_x= opponent_hand_x+ds_list_size(global.opponent_hand)*card_interval;
						dealt_card.target_y= opponent_hand_y;
						ds_list_add(global.opponent_hand,dealt_card);

						audio_play_sound(play_card,1,false);

						ds_list_delete(global.player_played_cards,0);
					}else{
						var discarded_card=global.player_played_cards[|0];
						ds_list_add(global.discard,discarded_card);
						ds_list_delete(global.player_played_cards,0);
						discarded_card.face_up=true;
						discarded_card.target_x=discard_x
						discarded_card.target_y=discard_y;
						discard_y-=card_height;
						audio_play_sound(play_card,1,false);
						discarded_card.depth=global.num_cards-ds_list_size(global.discard);
						wait_timer=1*room_speed;
					}
				}else{
					is_opponent_skipped=false;
					is_player_skipped=false;
					global.state=state.end_of_turn;
				}
			}		
		}
		
		
	break;
	
	case state.end_of_turn:
		if(ds_list_size(global.deck)==0){
			if(global.player_score>global.opponent_score){
				global.winner=1;
				win_reason="Earns more points when all cards are drawn";
			}else if(global.opponent_score>global.player_score){
				global.winner=0;
				win_reason="Earns more points when all cards are drawn";
			}else{
				global.winner=-1;
				win_reason="Earns same points when all cards are drawn";
			}
			audio_play_sound(game_end,1,false);
			
			Sleep(800);
			global.state=state.end_of_game;
			winning_celebration_index=ds_list_size(global.discard)-1;
		}else{
			global.state=state.deal_opponent;
			//Sleep(800);
		}
	break;
	case state.deal_opponent:
		var cards_in_hand=ds_list_size(global.opponent_hand);
		if(cards_in_hand<10 && wait_timer>0.2*room_speed && ds_list_size(global.deck)>0 && deal_time<2){
			var dealt_card=global.deck[| ds_list_size(global.deck)-1];
			deal_time++;
			dealt_card.target_x=opponent_hand_x+cards_in_hand*card_interval;
			dealt_card.target_y=opponent_hand_y;
			ds_list_add(global.opponent_hand,dealt_card);
			ds_list_delete(global.deck,ds_list_size(global.deck)-1);
			audio_play_sound(play_card,1,false);
			wait_timer=0;
		}else if((deal_time>=2 || cards_in_hand>=10 || ds_list_size(global.deck) ==0) && wait_timer>0.2*room_speed){
			global.state=state.deal_player;
			deal_time=0;
			wait_timer=0;
		}
		wait_timer++;
	break;
	case state.deal_player:
		var cards_in_hand=ds_list_size(global.hand);
		if(cards_in_hand<10 && wait_timer>0.2*room_speed && ds_list_size(global.deck)>0 && deal_time<2){
			var dealt_card=global.deck[| ds_list_size(global.deck)-1];
			deal_time++;
			dealt_card.target_x=hand_x+cards_in_hand*card_interval;
			dealt_card.target_y=hand_y;
			dealt_card.face_up=true;
			ds_list_add(global.hand,dealt_card);
			ds_list_delete(global.deck,ds_list_size(global.deck)-1);
			audio_play_sound(play_card,1,false);
			wait_timer=0;
		}else if((deal_time>=2 || cards_in_hand>=10 || ds_list_size(global.deck) ==0) && wait_timer>0.5*room_speed){
			ds_list_sort(global.hand,true);
			ds_list_sort(global.opponent_hand,true);
			sort_time=0;
			global.state=state.sort_player;
			global.opponent_card_sum=0;
			global.player_card_sum=0;
			ds_list_clear(global.opponent_played_cards);
			ds_list_clear(global.player_played_cards);
			deal_time=0;
			wait_timer=0;
		}
		wait_timer++;
	break;
	case state.end_of_game:
		
		wait_timer++;
		if(wait_timer>=0.1*room_speed && ds_list_size(global.player_played_cards)>0){
			wait_timer=0;
			var discarded_card=global.player_played_cards[|0];
			discarded_card.face_up=true;
			ds_list_add(global.discard,discarded_card);
			ds_list_delete(global.player_played_cards,0);
			
			discarded_card.target_x=discard_x
			discarded_card.target_y=discard_y;
			discard_y-=card_height;
			audio_play_sound(play_card,1,false);
			discarded_card.depth=global.num_cards-ds_list_size(global.discard);	
		}else if(wait_timer>=0.1*room_speed && ds_list_size(global.opponent_played_cards)>0){
			wait_timer=0;
			var discarded_card=global.opponent_played_cards[|0];
			discarded_card.face_up=true;
			ds_list_add(global.discard,discarded_card);
			ds_list_delete(global.opponent_played_cards,0);
			
			discarded_card.target_x=discard_x
			discarded_card.target_y=discard_y;
			discard_y-=card_height;
			audio_play_sound(play_card,1,false);
			discarded_card.depth=global.num_cards-ds_list_size(global.discard);	
		}else if(wait_timer>=0.1*room_speed && ds_list_size(global.deck)>0){
			wait_timer=0;
			var discarded_card=global.deck[|ds_list_size(global.deck)-1];
			discarded_card.face_up=true;
			ds_list_add(global.discard,discarded_card);
			ds_list_delete(global.deck,ds_list_size(global.deck)-1);
			
			discarded_card.target_x=discard_x
			discarded_card.target_y=discard_y;
			discard_y-=card_height;
			audio_play_sound(play_card,1,false);
			discarded_card.depth=global.num_cards-ds_list_size(global.discard);	
		}else if(wait_timer>=0.1*room_speed && ds_list_size(global.opponent_hand)>0){
			wait_timer=0;
			var discarded_card=global.opponent_hand[|0];
			discarded_card.face_up=true;
			ds_list_add(global.discard,discarded_card);
			ds_list_delete(global.opponent_hand,0);
			
			discarded_card.target_x=discard_x
			discarded_card.target_y=discard_y;
			discard_y-=card_height;
			audio_play_sound(play_card,1,false);
			discarded_card.depth=global.num_cards-ds_list_size(global.discard);		
		}else if(wait_timer>=0.1*room_speed && ds_list_size(global.hand)>0){
			wait_timer=0;
			var discarded_card=global.hand[|0];
			discarded_card.face_up=true;
			ds_list_add(global.discard,discarded_card);
			ds_list_delete(global.hand,0);
			
			discarded_card.target_x=discard_x
			discarded_card.target_y=discard_y;
			discard_y-=card_height;
			audio_play_sound(play_card,1,false);
			discarded_card.depth=global.num_cards-ds_list_size(global.discard);
			winning_celebration_index=ds_list_size(global.discard)-1;
		
		}else if(wait_timer>=0.5*room_speed){
			if(wait_timer>=0.55*room_speed && ds_list_size(global.discard)>0){
				wait_timer=0.5*room_speed;
				audio_play_sound(play_card,1,false);
				winning_celebration_card_x=room_width/2 + random_range(-600,600);
				winning_celebration_card_y=room_height/2 + random_range(-450,450);
				
				var discarded_card=global.discard[|ds_list_size(global.discard)-1];
				
				discarded_card.target_x=winning_celebration_card_x;
				discarded_card.target_y=winning_celebration_card_y;
				
				ds_list_delete(global.discard,ds_list_size(global.discard)-1);
				
				winning_celebration_index--;	
			}else if(ds_list_size(global.discard)<=0 && wait_timer>=1.2*room_speed){
				wait_timer=0;
				global.state=state.announce_winner;
			}

		}
		
	break;
	case state.announce_winner:
		if(mouse_x>=598 && mouse_x<=768){
			if(mouse_y>=816 && mouse_y<=874){
				if(mouse_check_button_released(mb_left)){
					audio_play_sound(click,1,false);
					room_restart();
				}
			}
		}
	break;

}
