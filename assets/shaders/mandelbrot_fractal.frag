
#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uColorize;

out vec4 fragColor;

const float MAX_ITER = 1500;

float mandelbrot(vec2 uv) {
    vec2 c = 4.0 * uv - vec2(.5, .5);
    vec2 z = vec2(0.0);

    float iter = 0.0;
    for(float i = 0.0; i < MAX_ITER; i++) {
        z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;

        if(dot(z, z) > 4.0) {
            return iter / MAX_ITER;
        }
        iter++;
    }
    return 0.0;
}

vec3 randomColor(float m) {
    float r = fract(sin(m * 123.45) * 98765.4321);  // Red channel
    float g = fract(sin(m * 234.56) * 54321.1234);  // Green channel
    float b = fract(sin(m * 345.67) * 13579.2468);  // Blue channel

    r = 0.5 + 0.5 * r;  // Make the color brighter
    g = 0.5 + 0.5 * g;
    b = 0.5 + 0.5 * b;

    r = pow(r, 2.2);  // Adjust gamma for better brightness perception
    g = pow(g, 2.2);
    b = pow(b, 2.2);

    return vec3(r, g, b);  // Return the color with enhanced brightness
}
void main() {
    vec2 uv = (FlutterFragCoord().xy / uSize) * 2 - 1;
    uv.x *= (uSize.x / uSize.y);

    vec3 col = vec3(0.0);
    float m = mandelbrot(uv);
    col += m;
    if(uColorize > 0.0) {
        col += randomColor(m);
    } else {
        col = pow(col, vec3(.45));
    }

    fragColor = vec4(col, 1);
}
