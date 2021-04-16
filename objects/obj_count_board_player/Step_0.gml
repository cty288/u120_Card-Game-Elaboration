sum=string(global.player_card_sum);
//show_debug_message(sum);

if(string_length(sum)==1){
	first_digit=0;
	second_digit=int64(sum);
}else{
	first_digit=int64(string_char_at(sum,1));
	second_digit=int64(string_char_at(sum,2));
	//show_debug_message(string_char_at(sum,1));
}