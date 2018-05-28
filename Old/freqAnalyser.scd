( // a custom Frequency Analyzer

	// create the parent window
	var window = Window("Frequency Analyzer", 640@480).front
	.onClose_({ // on close
		sound.free; // stop sound
		scope.kill; // kill the analyzer
	});
	// the bus to scope
	var bus = Bus.audio(Server.default,2);
	// a stereo signal
	var sound = {
		var signal = Resonz.ar(
			[ ClipNoise.ar(1.7), ClipNoise.ar(8) ],
			SinOsc.ar(1000).range(100,500)); // a stereo signal
		Out.ar(bus,signal); // update bus for scoping
		Out.ar(0,signal); // write to output
	}.play;

	// the frequency scope
	var scope = FreqScopeView(window,640@480).active_(true);
	// activate it
scope.background_(Color.red).waveColors_([Color.yellow,Color.blue]);
	// set colors
	scope.dbRange_(120); // set amplitude range (in decibels)
	scope.inBus_(bus); // select Bus to scope

)
