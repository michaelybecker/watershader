import {
  PlaneBufferGeometry,
  Scene,
  ShaderMaterial,
  Mesh,
  DirectionalLight,
  Clock,
  Vector3,
  TextureLoader,
  RepeatWrapping,
  MeshBasicMaterial,
  DoubleSide,
} from "three";

const normalMapPath = require("./assets/textures/water/waternormals.jpg");
const escherPath = require("./assets/textures/birdfish.jpg");

const scene = new Scene();
const c = new Clock();

const waterNormals = new TextureLoader().load(normalMapPath);
const escherText = new TextureLoader().load(escherPath);
waterNormals.wrapS = waterNormals.wrapT = RepeatWrapping;

const light = new DirectionalLight(0xffffff, 1);

light.position.x = -1;
light.position.y = 1;

scene.add(light);

const vs_earth = require("./assets/shaders/vs_earth.glsl");
const fs_earth = require("./assets/shaders/fs_earth.glsl");
const earthGeo = new PlaneBufferGeometry(15, 15, 300, 300);
earthGeo.dynamic = true;

const earthMat = new ShaderMaterial({
  vertexShader: vs_earth,
  fragmentShader: fs_earth,
  transparent: true,
  uniforms: {
    color1: { value: new Vector3(0.65, 0.45, 0.25) },
    color1i: { value: 0.5 },
    color2: { value: new Vector3(0.03, 0.23, 0.63) },
    color2i: { value: 0.5 },
    time: { value: 0.0 },
    dirLight: { value: light.position },
    ambientLight: { value: new Vector3(0.4, 0.5, 0.6) },
    ambientLightIntensity: { value: 0.025 },
    normalMap: { value: waterNormals },
    normalMap2: { value: waterNormals },
    refText: { value: escherText },
  },
});

const earth = new Mesh(earthGeo, earthMat);
earth.position.set(0, -2, 0);
earth.rotateOnAxis(new Vector3(-1, 0, 0), 1.5708);

earth.geometry.attributes.position.needsUpdate = true;
earth.Update = () => {
  if (earth.material.uniforms == undefined) return;
  earth.material.uniforms.time.value += 0.0001;
};
scene.add(earth);

export { scene };
