global.deck_hovering=false;
enum card_face{
	one,
	two,
	three,
	four,
	five,
	wild,
	ten
}
image_xscale=0.8;
image_yscale=0.8;
face_sprites[0]=spr_card_1;
face_sprites[1]=spr_card_2;
face_sprites[2]=spr_card_3;
face_sprites[3]=spr_card_4;
face_sprites[4]=spr_card_5;
face_sprites[5]=spr_card_wild_default;
face_sprites[6]=spr_card_10;



face_up=false;
face_index=card_face.one;

lerp_value=0.15;
target_x=0;
target_y=0;

hovered=false;
selected=false;

wild_card_value=0;

function get_value(){
	if(face_index==card_face.ten){
		return 10;
	}else if(face_index==card_face.wild){
		return wild_card_value;
	}
	return face_index+1;
}