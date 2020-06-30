precision highp float;
varying vec2 v_uv;
uniform vec3 color1;
uniform vec3 color2;
uniform float color1i;
uniform float color2i;
uniform float time;
uniform vec3 dirLight;
uniform vec3 ambientLight;
uniform float ambientLightIntensity;
varying vec3 vNormal;
varying vec3 modPosition;
uniform sampler2D normalMap;
uniform sampler2D normalMap2;
uniform sampler2D refText;
float shininess = 8.0;


vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}

void main(){
	// phong
	vec3 viewDir = normalize(modPosition - cameraPosition);
	vec3 halfDir = normalize(dirLight + viewDir);
	float specAngle = max(dot(halfDir, vNormal), 0.0);
    float specular = pow(specAngle, shininess);

	vec4 noiseTex = texture2D( normalMap, rotate(v_uv+time/2.,23.14));
	vec4 noiseTex2 = texture2D( normalMap2, v_uv-time/6.);
	vec2 rUV = v_uv+refract(vNormal,viewDir,1./1.33).xy;
	vec4 eschText = texture2D( refText, v_uv); // water IoR
	vec3 litf =color1*color1i*max(dot(noiseTex.rgb,halfDir),0.)+color2*color2i*max(dot(noiseTex2.rgb,halfDir),0.);
	vec3 litf2 =color1*color1i*pow(max(dot(noiseTex.rgb,halfDir),0.),shininess)+color2*color2i*max(dot(noiseTex2.rgb,halfDir),0.)+specular;
	vec3 litf3 =color1*color1i*max(dot(vNormal,halfDir),0.)+color2*color2i*max(dot(vNormal,halfDir),0.);
	
	litf+=ambientLight*ambientLightIntensity;
	litf2+=ambientLight*ambientLightIntensity;
	// vec3 result = mix(litf,litf2,sin(time*100.));
	vec3 result = mix(litf2,eschText.rgb,.15);
	gl_FragColor=vec4(result,1.);
}