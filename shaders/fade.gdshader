shader_type canvas_item;
render_mode unshaded;

uniform float opacity_loss : hint_range(0.0, 1.0);

void fragment() {
	float alpha = COLOR.a;
	if (alpha > 0.0)
	{
		alpha -= opacity_loss;
		if (alpha < 0.0) 
		{
			alpha = 0.0;
		}
		COLOR.a = alpha;
	}
}
