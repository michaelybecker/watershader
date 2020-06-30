import { WebGLRenderer } from "three";

const Renderer = new WebGLRenderer({ antialias: true, alpha: true });
Renderer.setPixelRatio(window.devicePixelRatio);
Renderer.setSize(window.innerWidth, window.innerHeight);
Renderer.setClearColor(0x111111, 1.0);
Renderer.sortObjects = false;
Renderer.physicallyCorrectLights = true;
Renderer.xr.enabled = true;

export default Renderer;
