
SynthDef.new(\simpleFM, {
	arg freq1=440, freq2=0,rq1=0.2,rq2=0.2,amp=0.5;
	var sig1,sig2;
	sig1 = SinOsc.ar(freq1);
	sig1 = BPF.ar(
		sig1,
		freq1.lag(0.5),
		rq1.lag(0.5),
		1/rq1.sqrt.lag(0.5)
	);
	sig2 = SinOsc.ar(freq2*sig1)!2;
	sig2 = BPF.ar(
		sig2,
		freq2.lag(0.5),
		rq2.lag(0.5),
		1/rq2.sqrt.lag(0.5)
	);
	sig2 = 0.5*amp * sig2;
	//sig2 = Splay.ar(sig2, 0.8, amp, 0);
	Out.ar(0, sig2);
}).add;


b = Buffer.alloc(s,s.sampleRate*8.0,2);


Window.closeAll;

w = Window("gui", Rect(750,50,620,580))
.front
.alwaysOnTop_(true)
.onClose_({
	if(
	x.isPlaying,
		{x.free;b.free;}
	);
});

~exitButton = Button(w, Rect(560,60,50,30))
.states_([["QUIT", Color.black, Color.red]])
.font_(Font("Calibri", 18))
.mouseDownAction_({
	if(
		x.isPlaying,
		{x.free;b.free;}
	);
	w.close;
});

~button = Button(w, Rect(560,20,50,30))
.states_([
	["OFF", Color.black, Color.gray(0.8)],
	["ON", Color.white, Color(0.2,0.75,0.95)]
])
.font_(Font("Calibri", 18))
.action_({
	arg obj;
	if(
		obj.value == 1,{
			x = Synth.new(
				\simpleFM,
				[
					\freq1, ~slider1.value.linexp(0,1,1,10000),
					\rq1, ~knob1.value.linexp(0,1,1,100).reciprocal,
					\freq2, ~slider2.value.linexp(0,1,1,10000),
					\rq2, ~knob2.value.linexp(0,1,1,100).reciprocal,
					\amp, ~volKnob.value
				]
			).register; /*Node watch*/
			x.play;
		},
		{x.free}
	);
});

~volKnob = Knob(w, Rect(560,100,30,30))
.mode_(\vert)
.step_(0.009)
.ctrl_scale_(0.1)
.value_(0.05)
.action_({
	arg obj;
	var amp;
	amp = obj.value;
	if(
		x.isPlaying,
		{x.set(\amp, amp)}
	);
});

~freqLabel1 = StaticText(w, Rect(520,105,36,20))
.string_("gain:")
.font_(Font("Calibri",16))
//.align_(\center)
.background_(Color.grey(0.85))
.stringColor_(Color.blue);

~slider1 = Slider(w, Rect(20,20,150,30))
.thumbSize_(15)
.background_(Color(0.2,0.75,0.95))
.action_({
	arg obj;
	var cf;
	cf = obj.value.linexp(0,1,100,10000);
	if(              /*Node watch*/
		x.isPlaying,
		{x.set(\freq1, cf)}
	);
	~numberBox1.value_(obj.value.linexp(0,1,1,10000));
});

~numberBox1 = NumberBox(w, Rect(180,20,80,30))
.value_(1)
.clipLo_(1)
.clipHi_(10000)
.font_(Font("Calibri", 16))
.decimals_(2)
.action_({
	arg obj;
	~slider1.valueAction_(obj.value.explin(1,10000,0,1))
});

~freqLabel1 = StaticText(w, Rect(180,50,80,20))
.string_("freq1")
.font_(Font("Calibri",16))
.align_(\center)
.background_(Color.grey(0.85))
.stringColor_(Color.blue);

~slider2 = Slider(w, Rect(270,20,150,30))
.thumbSize_(15)
.background_(Color(0.2,0.75,0.95))
.action_({
	arg obj;
	var cf;
	cf = obj.value.linexp(0,1,1,10000);
	if(
		x.isPlaying,
		{x.set(\freq2, cf)}
	);
	~numberBox2.value_(obj.value.linexp(0,1,1,10000));
});

~numberBox2 = NumberBox(w, Rect(440,20,80,30))
.value_(1)
.clipLo_(1)
.clipHi_(10000)
.font_(Font("Calibri", 16))
.decimals_(2)
.action_({
	arg obj;
	~slider2.valueAction_(obj.value.explin(1,10000,0,1))
});

~freqLabel1 = StaticText(w, Rect(440,50,80,20))
.string_("freq2")
.font_(Font("Calibri",16))
.align_(\center)
.background_(Color.grey(0.85))
.stringColor_(Color.blue);

~knob1 = Knob(w, Rect(20,90,30,30))
.mode_(\vert)
.step_(0.009)
.ctrl_scale_(0.1)
.action_({
	arg obj;
	var qual;
	qual = obj.value.linexp(0,1,1,100).reciprocal;
	if(
		x.isPlaying,
		{x.set(\rq1, qual)}
	);
	~numberBox3.value_(obj.value.linexp(0,1,1,100));
});

~numberBox3 = NumberBox(w, Rect(70,90,80,30))
.value_(1)
.clipLo_(1)
.clipHi_(100)
.font_(Font("Calibri", 16))
.decimals_(2)
.action_({
	arg obj;
	~slider.valueAction_(obj.value.explin(1,100,0,1))
});

~freqLabel1 = StaticText(w, Rect(70,120,80,20))
.string_("qual1")
.font_(Font("Calibri",16))
.align_(\center)
.background_(Color.grey(0.85))
.stringColor_(Color.blue);

~knob2 = Knob(w, Rect(170,90,30,30))
.mode_(\vert)
.step_(0.009)
.ctrl_scale_(0.1)
.action_({
	arg obj;
	var qual;
	qual = obj.value.linexp(0,1,1,100).reciprocal;
	if(
		x.isPlaying,
		{x.set(\rq2, qual)}
	);
	~numberBox4.value_(obj.value.linexp(0,1,1,100));
});

~numberBox4 = NumberBox(w, Rect(220,90,80,30))
.value_(1)
.clipLo_(1)
.clipHi_(100)
.font_(Font("Calibri", 16))
.decimals_(2)
.action_({
	arg obj;
	~slider.valueAction_(obj.value.explin(1,100,0,1))
});

~freqLabel1 = StaticText(w, Rect(220,120,80,20))
.string_("qual2")
.font_(Font("Calibri",16))
.align_(\center)
.background_(Color.grey(0.85))
.stringColor_(Color.blue);


~freqViewer = FreqScopeView(w, Rect(20,150,511,300))
.active_(true);

~soundViewer = SoundFileView(w, Rect(20,460,511,100))
.drawsWaveForm_(true); //needs routine to update
//.data_(x);

~update = Button(w, Rect(541,460,70,30))
.states_([["UPDATE", Color.black, Color.red]])
.font_(Font("Calibri", 18))
.mouseDownAction_({
	if(
	x.isPlaying,
		{}
	);
});



// soundfileview updater? Put update button for now?
g = Routine({arg inval;

});


// .readFile(,0,1000,doneAction:2)