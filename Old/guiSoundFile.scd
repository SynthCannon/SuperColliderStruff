SynthDef(\playBufMono, {| out = 0, bufnum = 0, rate = 1, vol = 1, startPos = 0, bus = 0 |
	var scaledRate, player;
	scaledRate = rate * BufRateScale.kr(bufnum);
	player = Splay.ar(PlayBuf.ar(1, bufnum, scaledRate, 1, startPos, doneAction:2));
	// Splay sounds nicer? DoNotMix.ar
	player = 0.3 * player * vol;
	Out.ar(bus,player);
	Out.ar(out, player);
}).add;
//^^^^^^^^^^^IGNOREEEEEEE^^^^^^^^



SynthDef(\playBufStereo, {| out = 0, bufnum = 0, rate = 1, vol = 1, startPos = 0, bus = 0 |
	var scaledRate, player;
	scaledRate = rate * BufRateScale.kr(bufnum);
	player = PlayBuf.ar(2, bufnum, scaledRate, 1, startPos, doneAction:2) ;
	//ScopeOut(player, ~b);
	player = 0.3 * player * vol;
	Out.ar(bus,player);
	Out.ar(out, player);
}).add;



~b = Buffer.read(s, Platform.resourceDir +/+ "sounds/01 Gold Panda - You.flac");
~bus = Bus.audio(Server.default,2);
//= Bus.audio(Server.default,2);


f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "01 Gold Panda - You.flac");
//f.play;
//f.pause;
//f.duration;
//~b = Buffer.alloc(s,  f.duration*s.sampleRate);
//~b = Buffer.read(s,);

//alloc, global ~, soundfile<<<<<, play from position,<<<scratch, play immediately (realtime)?
//somtrain





//Window.closeAll;
w = Window("gui", Rect(650,338,700,400))
.front
.alwaysOnTop_(true)
.onClose_({
	s.freeAll;
});

~exitButton = Button(w, Rect(630, Window.screenBounds.height - 710/*???*/,50,30))
.states_([["QUIT", Color.black, Color.red]])
.font_(Font("Calibri", 18))
.mouseDownAction_({
	s.freeAll;
	w.close;
});
~button = Button(w, Rect(630,20,50,30))
.states_([
	["[ ]", Color.black, Color.gray(0.8)],
	["|>", Color.white, Color(0.2,0.75,0.95)]
])
.font_(Font("Calibri", 18))
.action_({
	arg obj;
	if(
		obj.value == 1,{

			//~b = Buffer.read(s, Platform.resourceDir +/+ "sounds/01 Gold Panda - You.flac");
			//f.play;
			if((~b.numChannels == 1), {
				//"not".postln;
				x = Synth.new(
					\playBufMono, [
						\out, 0,
						\bufnum, ~b.bufnum,
						\rate, ~rateKnob.value.linlin(0,1,0.5,1.5),
						\startPos, ~sndFileView.timeCursorPosition,
						\bus, ~bus
				]).register;
			}, {
					if((~b.numChannels == 2), {
						"this".postln;
						x = Synth.new(
							\playBufStereo, [
								\out, 0,
								\bufnum, ~b.bufnum,
								\rate, ~rateKnob.value.linlin(0,1,0.5,1.5),
								\startPos, ~sndFileView.timeCursorPosition,
								\bus, ~bus
						     ]).register;
					});
			});
			x.map(0,~bus[0]);
			x.map(1,~bus[1]);
			/*f = SoundFile.new;
			f.openRead(Platform.resourceDir +/+ "sounds/01 Gold Panda - You.flac");
			(f.duration%60).postln;
			f.play;
			f.close;*/
			//~numberBox1.value_(b.duration);
		},
		{s.freeAll;}
	);
});

~rateKnob = Knob(w, Rect(330,100,30,30))
.value_(0.5)
.mode_(\vert)
.step_(0.009)
.ctrl_scale_(0.1)
.action_({
	arg obj;
	var rate;
	rate = obj.value.linlin(0,1,0.5,1.5);
	if(
		x.isPlaying,
		{x.set(\rate, rate)}
	);
	~numberBox2.value_(obj.value.linlin(0,1,0.5,1.5));
});


~slider = Slider(w, Rect(20,100,150,30))
.thumbSize_(15)
.background_(Color(0.2,0.75,0.95))
.action_({
	arg obj;
	var cf;
	cf = obj.value.linlin(0,1,0,1);
	/*if(              /*Node watch*/
		x.isPlaying,
		{x.set(\freq, cf)}
	);*/
	~numberBox1.value_(obj.value);
});

~numberBox1 = NumberBox(w, Rect(180,100,80,30))
.value_(0)
//.clipLo_(100)
//.clipHi_(4000)
.font_(Font("Calibri", 16))
.decimals_(2)
.mouseDownAction_({
	//arg obj;
	//~slider.valueAction_(obj.value.explin(0,1,0,1))
});

~numberBox2 = NumberBox(w, Rect(370,100,80,30))
.value_(1)
//.clipLo_(100)
//.clipHi_(4000)
.font_(Font("Calibri", 16))
.decimals_(2)
.mouseDownAction_({
	//arg obj;
	//~slider.valueAction_(obj.value.explin(0,1,0,1))
});

~numberBox3 = NumberBox(w, Rect(460,100,80,30))
.value_(1)
//.clipLo_(100)
//.clipHi_(4000)
.font_(Font("Calibri", 16))
.decimals_(2)
.mouseDownAction_({
	//arg obj;
	//~slider.valueAction_(obj.value.explin(0,1,0,1))
});


~sndFileView = SoundFileView(w, Rect(20,20,600,70))
.readFileWithTask(f, 0, f.numFrames)
.drawsWaveForm_(true)
.waveColors_([Color.red,Color.yellow])
.gridOn_(true)
.gridResolution_(10.2)
.timeCursorOn_(true)
.timeCursorColor_(Color.yellow)
.elasticMode_(true)
.action_({
	arg obj;
	~numberBox1.valueAction_(obj.timeCursorPosition /f.numFrames*f.duration );
	if(              /*Node watch*/
		x.isPlaying,
			{
			// method - rewrite (poss not as responsive, works well enough)
			//x.set(\startPos, obj.timeCursorPosition*f.numFrames/600);
			x.free;
			x = Synth.new(
				\playBufStereo, [
					\out, 0,
					\bufnum, ~b.bufnum,
					\rate, ~rateKnob.value.linlin(0,1,0.5,1.5),
					\startPos, ~sndFileView.timeCursorPosition
				]).register;
		}
	);
})
.mouseMoveAction_({
	arg obj, xPos;
	obj.timeCursorPosition = (xPos/600)*f.numFrames;
	/*if(
		(xPos > -1 && xPos < 600), { // needs fixing..
			xPos.postln;
			(obj.timeCursorPosition/600 * f.numFrames).postln;
			/*f.duration.postln;
			~b.numFrames.postln;
			(xPos/600)*f.duration.postln;*/
			obj.timeCursorPosition = (xPos/600)*f.numFrames;
			~numberBox1.valueAction_(obj.timeCursorPosition/f.numFrames*f.duration);
	});*/
});
/*
.soundfile_(f)
.elasticMode_(true)
.timeCursorPosition = 20500
.gridColor_(Color.red);
*/

~scope = FreqScopeView(w, Rect(10,140,250,150))
.inBus_(~bus)
.active_(true)
.background_(Color.magenta)
.waveColors_([Color.yellow,Color.red]);
//.dbRange_(120) // set amplitude range (in decibels)
//.inBus_(~bus); // select Bus to scope

~scopes = Array.fill(8,{arg i;
 ScopeView(w,Rect(260,140,640,480))
 .bufnum_(~b.bufnum!8) // associate with the right Buffer
 .backColor_(Color(0.6,0.8,0.9,1/4)) // notice the alpha channel
 .waveColors_([Color.green,Color.yellow]);
});
/* modulate horizontal zoom factor on all views with respect to their
index */
fork{loop{
 ~scopes.do{arg item,index;
 {item.xZoom_( 4 + (3*(sin((Main.elapsedTime / 2) +
 (index*0.02)))));}.defer;
 };
 0.1.wait; // change factor every 0.1 seconds
}};




/*~waveScope = ScopeView(w, Rect(10,140,250,150))
.bufnum_(~b.bufnum)
.style_(1) // overlay channels
.waveColors_([Color.red,Color.yellow])
.background_(Color.magenta(0.4))
.xZoom_(107).yZoom_(102); // scaling factors*/