//shockwave shader

shader_type canvas_item;
uniform vec2 center; //center is 0.5,0.5 in the inspector tab for distortion center
uniform float force; //change force in the inspector tab for distortion
uniform float size;
uniform float thickness; //it doesnt work

void fragment(){
	float ratio = SCREEN_PIXEL_SIZE.x/ SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV =( SCREEN_UV- vec2(0.5,0.0)) / vec2(ratio,1.0) * vec2(0.5,0.0);
	float mask = (1.0- smoothstep (size-0.1,size ,length(scaledUV - center))) * smoothstep (size-thickness-0.1,size-thickness ,length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * force * mask;
	//COLOR = vec4(SCREEN_UV - disp,0.0,1.0);
	COLOR = texture(SCREEN_TEXTURE,SCREEN_UV - disp);
	COLOR.rgb = vec3(mask);
}