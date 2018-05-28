/*
Tutorial
https://www.youtube.com/watch?v=W2D_PzOVfT0

Docs to look up
?> Introduction to GUI
?> ControlSpec -- exp fit replacement
?> Decorators -->> FlowLayout -->> CompositeView

Other important GUI objects
?> SoundFileView       ***
?> LevelIndicator      **
?> PopUpMenu           *
?> RangeSlider         *
?> Textfield/TextView  *
?> Slider2D            **
?> MultiSliderView     **


Further questions
??> Reason to lag? NO POPPING?

*/


SynthDef.new(\simplebpf, {
	arg freq=440, freq2=440;
	var sig;
	sig = SinOsc.ar(freq*SawOsc.ar() + SinOsc.ar(freq2);


	Out.ar(0, sig!2);
}).add;


Window.closeAll;

w = Window("gui", Rect(750,50,600,200))
.front
.alwaysOnTop_(true)
.onClose_({
	if(
	x.isPlaying,
		{x.free;}
	);
});

~exitButton = Button(w, Rect(530, /*Window.screenBounds.height - 690*//*???*/ 60,50,30))
.states_([["QUIT", Color.black, Color.red]])
.font_(Font("Calibri", 18))
.mouseDownAction_({
	if(
		x.isPlaying,
		{x.free;}
	);
	w.close;
});

~button = Button(w, Rect(530,20,50,30))
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
				\simplebpf,
				[
					\freq, ~slider1.value.linexp(0,1,100,4000),
					\freq2, ~slider2.value.linexp(0,1,100,4000)
				]
			).register; /*Node watch*/
		},
		{x.free}
	);
});

~slider1 = Slider(w, Rect(20,20,150,30))
.thumbSize_(15)
.background_(Color(0.2,0.75,0.95))
.action_({
	arg obj;
	var cf;
	cf = obj.value.linexp(0,1,100,4000);
	if(              /*Node watch*/
		x.isPlaying,
		{x.set(\freq, cf)}
	);
	~numberBox1.value_(obj.value.linexp(0,1,100,4000));
});

~numberBox1 = NumberBox(w, Rect(180,20,80,30))
.value_(100)
.clipLo_(100)
.clipHi_(4000)
.font_(Font("Calibri", 16))
.decimals_(2)
.action_({
	arg obj;
	~slider.valueAction_(obj.value.explin(100,4000,0,1))
});

~freqLabel1 = StaticText(w, Rect(180,50,80,20))
.string_("freq")
.font_(Font("Calibri",16))
.align_(\center)
.background_(Color.grey(0.85))
.stringColor_(Color.blue);

~slider2 = Slider(w, Rect(270,20,150,30))
.value_(0.440)
.thumbSize_(15)
.background_(Color(0.2,0.75,0.95))
.action_({
	arg obj;
	var cf;
	cf = obj.value.linexp(0,1,100,4000);
	if(              /*Node watch*/
		x.isPlaying,
		{x.set(\freq, cf)}
	);
	~numberBox2.value_(obj.value.linexp(0,1,100,4000));
});

~numberBox2 = NumberBox(w, Rect(430,20,80,30))
.value_(4400)
.clipLo_(100)
.clipHi_(4000)
.font_(Font("Calibri", 16))
.decimals_(2)
.action_({
	arg obj;
	~slider2.valueAction_(obj.value.explin(100,4000,0,1));
});

~freqLabel1 = StaticText(w, Rect(430,50,80,20))
.string_("qual")
.font_(Font("Calibri",16))
.align_(\center)
.background_(Color.grey(0.85))
.stringColor_(Color.blue);


//~button.value_(0); //instantiate? or edit