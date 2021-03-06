
SynthDef.new(\blip, {
	arg out, fund=300, dens=2, decay=0.2;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund,fund*4).round(fund);
	sig = SinOsc.ar(freq) *0.25;
	trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01,decay),trig);
	sig= Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out,sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;

x = Synth.new(\blip, [\out, 2]);
y = Synth.new(\reverb, [\in, x, \out, 0]);


/*
~reverbBus = Bus.audio(s, 1);
~reverbBus.index;

~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);

x = Synth.new(\blip, [\out, ~reverbBus], ~sourceGrp);
y = Synth.new(\reverb, [\out, ~reverbBus], ~fxGrp);
*/

/*
8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverbBus,
			\fund, exprand(60,300).round(30)
		],
		~sourceGrp
	);
}

~sourceGrp.set(\decay, 0.03);
//~sourceGrp.set(\dens, 0.25);
//~sourceGrp.set(\decay, 1.2);
//sourceGrp.freeAll;
*/

/*
g = Group.new;

x = Synth.new(\blip, [\out, ~reverbBus], s);
y = Synth.new(\reverb, [\out, ~reverbBus], s, \addToTail);
*/
/*
x = Synth.new(\blip, [\out, ~reverbBus], s);
y = Synth.new(\reverb, [\out, ~reverbBus], s, \addAfter);
*/


