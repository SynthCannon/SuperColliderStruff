SynthDef.new(\iter, {
	arg freq=40;
	var temp, sum, env;
	sum = 0;
	env = EnvGen.kr(
		Env.perc(0.01, 10, 1, -2),
		doneAction:2
	);
	10.do{
		temp = VarSaw.ar(
			40 * {Rand(0.99,1.02)}!2,
			{Rand(0.0, 1.0)}!2,// vary starting phase!!!
			0.05
		);
		sum = sum + temp;
	};
	sum = sum * 0.05; // scale down as outputting accumulated synths
	Out.ar(0, sum);
}).add;

SynthDef.new(\iter2, {
	arg freq=200, dev=1.02;
	var temp, sum;
	sum = 0;
	10.do{ //Cannot change num, which produces [0,1,...,9]
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(0.98,dev)
		);
		temp = temp * LFNoise1.kr({Rand(0.5,8)}!2).exprange(0.01,1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(1, sum);
}).add;


x = Synth.new(\iter, [\freq, 8.midicps]);
y = Synth.new(\iter2);
y.set(\freq, 100);
