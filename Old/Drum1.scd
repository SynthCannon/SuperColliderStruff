(
SynthDef("Drum1", {
	arg out=0,atk=0.003, rel=0.3;
	var env, sig;

	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-10]),doneAction:2);
	sig = env * SinOsc.ar(
            LFClipNoise.ar(100, 200, 800),
            0, 0.4) * WhiteNoise.ar;

	Out.ar(out, 0.7*sig);
}).play;
)