shader_type canvas_item;
render_mode unshaded;

uniform float wave_spread : hint_range(0.0, 1.0);
uniform float wave_width : hint_range(0.0, 0.5);
uniform float opacity_loss : hint_range(0.0, 1.0);

void fragment() {
	float max_spread = 0.5;
	vec2 diff_to_mid;
	diff_to_mid.x = abs(UV.x - 0.5);
	diff_to_mid.y = abs(UV.y - 0.5);
	float diff_radius = sqrt(pow(diff_to_mid.x, 2) + pow(diff_to_mid.y, 2));
	
	float diff_to_wave = abs(wave_spread * max_spread - diff_radius);
	if(diff_to_wave <= wave_width){
		COLOR.a = 1.0 - diff_to_wave / wave_width - opacity_loss;
	}
	else{
		COLOR.a = 0.0;
	}
}
