        uniform float time;
        uniform vec3 color;
        uniform vec3 dirLight;
        varying vec2 v_uv;
        varying vec3 vNormal;
        varying vec3 modPosition;
        uniform sampler2D normalMap;
        uniform sampler2D normalMap2;

        float random(vec2 p)
        {    
            float x = dot(p,vec2(4371.321,-9137.327));    
            return 2.0 * fract(sin(x)*17381.94472) - 1.0;
        }
        float noise( in vec2 p )
        {
            vec2 id = floor( p );
            vec2 f = fract( p );
            
            vec2 u = f*f*(3.0-2.0*f);

            return mix(mix(random(id + vec2(0.0,0.0)), 
                        random(id + vec2(1.0,0.0)), u.x),
                    mix(random(id + vec2(0.0,1.0)), 
                        random(id + vec2(1.0,1.0)), u.x), 
                    u.y);
        }
        float fbm( vec2 p )
        {
            float f = 0.0;
            float gat = 0.0;
            
            for (float octave = 0.; octave < 5.; ++octave)
            {
                float la = pow(2.0, octave);
                float ga = pow(0.5, octave + 1.);
                f += ga*noise( la * p ); 
                gat += ga;
            }
            
            f = f/gat;
            
            return f;
        }

vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}

        void main()	{
            v_uv = uv;
            vec4 noiseTex = texture2D( normalMap, rotate(v_uv+time/2.,23.14));
            vec4 noiseTex2 = texture2D( normalMap2, v_uv-time/6.);
            modPosition= position+normal*noiseTex.rgb*2.*noiseTex2.rgb*.5+vec3(0,0,position.z+fbm(position.xy-time*30.)/3.);
            // modPosition= position+normal*noiseTex.rgb*2.*noiseTex2.rgb*1.5;

            // modPosition= vec3(position.x,position.y,position.z+fbm(position.xy+time/30.)/2.);
            vNormal = normal*noiseTex.xyz*noiseTex2.xyz;

            // gl_Position = projectionMatrix * modelViewMatrix * vec4(modPosition, 1.0);
            gl_Position = projectionMatrix * modelViewMatrix * vec4(modPosition, 1.0);
        }