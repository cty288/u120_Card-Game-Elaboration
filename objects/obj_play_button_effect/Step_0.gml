/// @description Insert description here
// You can write your code in this editor
if(start){


if(image_alpha>=0.69){
	target_alpha=0;
}

if(image_alpha<=0.01){
	target_alpha=0.7;
}
}else{
	target_alpha=0;
}
image_alpha =  lerp(image_alpha,target_alpha,0.1);