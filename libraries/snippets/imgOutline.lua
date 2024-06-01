return love.graphics.newShader([[
extern vec2 size;

vec2 clamp_pos(vec2 pos) {
    float x = pos.x;
    float y = pos.y;
    if (x < 0.0) x = 0.0;
    if (y < 0.0) y = 0.0;
    if (x > 1.0) x = 1.0;
    if (y > 1.0) y = 1.0;
    return vec2(x, y);
}

vec4 effect (vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float distance = 1.0;
    float num = 0.0;
    vec4 averagecolor = vec4(0.0, 0.0, 0.0, 0.0);
    for (float x = -6.0; x <= 6.0; x++)
    for (float y = -6.0; y <= 6.0; y++) {
        vec4 color = Texel(texture, clamp_pos(vec2(texture_coords.x + x / size.x, texture_coords.y + y / size.y)));
        if (color.a > 0.0) {
            num += 1.0;
            averagecolor.r += color.r;
            averagecolor.g += color.g;
            averagecolor.b += color.b;
            averagecolor.a += color.a;
            float x1 = x / size.x;
            float y1 = y / size.y;
            float dist = sqrt(x1 * x1 + y1 * y1) * 100.0;
            if (dist < distance) {
                distance = dist;
            }
        }
    }
    if (num > 0.0) {
        averagecolor /= num;
        averagecolor.a -= distance;
    }
    return averagecolor;
}
]])
