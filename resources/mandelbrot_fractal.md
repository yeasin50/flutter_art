### initial fragment

```frag
#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec3 col = vec3(0.0);

    col.xy = uv;
    fragColor = vec4(col, 1);
}
```

### Let's create mandelbrot function

```frag
const float MAX_ITER = 128.0;

float mandelbrot(vec2 uv) {
    vec2 c = 1.0 * uv - vec2(.7, 0);
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
```

And we can replace

```frag
 float m = mandelbrot(uv);
 col += m;
```

### adjust the mandelbrot

```frag
vec2 uv = FlutterFragCoord().xy / uSize;
uv.x *= (uSize.x / uSize.y);

float m = mandelbrot(uv);
col += m;
col = pow(col, vec3(.45));
```

### decorate the color

```frag
vec3 randomColor(float m) {
    float r = fract(sin(m * 123.45) * 98765.4321);  // Red channel
    float g = fract(sin(m * 234.56) * 54321.1234);  // Green channel
    float b = fract(sin(m * 345.67) * 13579.2468);  // Blue channel

    // Make the color brighter
    r = 0.5 + 0.5 * r;
    g = 0.5 + 0.5 * g;
    b = 0.5 + 0.5 * b;

    // Adjust gamma for better brightness perception
    r = pow(r, 2.2);
    g = pow(g, 2.2);
    b = pow(b, 2.2);

    return vec3(r, g, b);  // Return the color with enhanced brightness
}


col += randomColor(m);
// col = pow(col, vec3(.45));
fragColor = vec4(col, 1);
```
