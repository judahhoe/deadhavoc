shader_type canvas_item;

uniform float radius = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 center = vec2(0.5, 0.5);
	vec2 local_coords = (UV - center);
	float distance = length(local_coords);
	
	float circleRadius = radius / float(2);
	
	if(distance > circleRadius) {
		discard;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
