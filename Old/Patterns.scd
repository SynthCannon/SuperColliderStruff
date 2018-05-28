
SynthDef.new(\sine, {
	arg freq=440, atk=0.005, rel=0.3, amp=1, pan=0;
	var sig, env;
	sig = LFSaw.ar(1000);
	//sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
	sig = Pan2.ar(sig, pan, amp);// shift sound to center? pan=1 -> change speaker... no way to focus on initial side?
	sig = sig * env;

	Out.ar(0, 0.3*sig);
}).add;


SynthDef.new(\LFatmpt, {

}).add;


//x = Synth.new(\sine);


p = Pbind(
	\instrument, \sine,
	//\dur, Pwhite(0.05, 0.5, inf),
	\dur, Pseq([0.6, 0.15, 0.15], 4),
	\freq, Pexprand(50, 4410, inf),//.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf),
).play;


//p.stop;

