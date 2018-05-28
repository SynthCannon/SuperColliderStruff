(
s = Server.local;
SynthDef(\help_SPE1, { arg i_out=0, freq;
	var out;
	out = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: 2 )),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	// out = [out, DelayN.ar(out, 0.04, 0.04) ];
	4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4) });
	Out.ar( i_out, out );
}).send(s);
)

(
// streams as a sequence of pitches
var stream, dur;
dur = 1/8;
stream = Routine.new({
	loop({
		if (0.5.coin, {
			// run of fifths:
			24.yield;
			31.yield;
			36.yield;
			43.yield;
			48.yield;
			55.yield;
		});
		rrand(2,5).do({
			// varying arpeggio
			60.yield;
			#[63,65].choose.yield;
			67.yield;
			#[70,72,74].choose.yield;
		});
		// random high melody
		rrand(3,9).do({ #[74,75,77,79,81].choose.yield });
	});
});
Routine({
	loop({
		Synth(\help_SPE1, [ \freq, stream.next.midicps ] );
		dur.wait;
		// synonym for yield, used by .play to schedule next occurence
	})
}).play
)