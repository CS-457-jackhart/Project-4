#version 330 compatibility

uniform float uA, uB, uC, uD;

out vec3	vNs;
out vec3	vEs;
out vec3	vMC;

const float PI = 3.14159265;
const float TWO_PI = 2. * PI;

void
main()
{
	vMC = gl_Vertex.xyz;
	vec4 newVertex = gl_Vertex;
	float r = sqrt(pow(vMC.x, 2) + pow(vMC.y, 2));
	newVertex.z = uA * cos(TWO_PI * uB * r + uC) * exp(-uD * r);

	vec4 ECposition = gl_ModelViewMatrix * newVertex;

	float dzdr = uA * (-sin(TWO_PI * uB * r + uC) * TWO_PI * uB * exp(-uD * r) + cos(TWO_PI * r + uC) * -uD * exp(-uD * r));
	float drdx = vMC.x / r;
	float drdy = vMC.y / r;
	float dzdx = dzdr * drdx;
	float dzdy = dzdr * drdy;
	vec3 xtangent = vec3(1., 0., dzdx);
	vec3 ytangent = vec3(0., 1., dzdy);

	vec3 newNormal = normalize(cross(xtangent, ytangent));
	vNs = newNormal;
	vEs = ECposition.xyz - vec3(0., 0., 0.);
	// vector from the eye position to the point

	gl_Position = gl_ModelViewProjectionMatrix * newVertex;
}