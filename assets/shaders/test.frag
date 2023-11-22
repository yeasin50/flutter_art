
#version 460 core

#include <flutter/runtime_effect.glsl>
 
uniform float opacity;

out vec4 oColor;

void main() {  
  vec4 color = vec4(1.0,0.0,1.0, 1.0);
  oColor = color * opacity;
}
