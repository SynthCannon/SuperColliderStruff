/*{
(({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.98), LPF.ar(BrownNoise.ar, 14)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.995), LPF.ar(BrownNoise.ar, 20)
* 800 + 1000, 0.03, 0.005)}!2)
* 4.2) * 10
}.play;

*/
/*
{ GrayNoise.ar(mul: 1, add: -0.8) }.play;
*/

(
a={
(({RHPF.ar(OnePole.ar(GrayNoise.ar(mul: 1, add: -0.8), 0.99), LPF.ar(GrayNoise.ar(mul: 1, add: -0.7), 14,1,0)
* 400 + 500, 0.03, 0.003)}!2)
+ ({RHPF.ar(OnePole.ar(GrayNoise.ar(mul: 1, add: -0.8), 1), LPF.ar(GrayNoise.ar(mul: 1, add: -0.7), 20,0,0)
* 800 + 1000, 0.03, 0.005)}!2)//note !2 for spreading across channels
	* 4) * 4}.play;
)


a.free;