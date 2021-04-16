timer++;
rolling=global.state==state.generate_target_value;

if(rolling){
	if(timer>=time_interval){
	//TODO: play a sound
	timer=0;
	first_digit=irandom_range(0,9);
	second_digit=irandom_range(0,9);
	}
}else{
	
	sum=string(global.target_value);

	if(string_length(sum)==1){
		first_digit=0;
		second_digit=int64(sum);
	}else{
		first_digit=int64(string_char_at(sum,1));
		second_digit=int64(string_char_at(sum,2));
	}
}


