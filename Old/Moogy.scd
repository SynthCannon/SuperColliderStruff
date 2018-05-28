
SynthDef("Moog",{

arg oscType =0, oscType2 = 1, pan = 0, level = 0.5, cutoff = 500, gain = 3.3, attack = 0.1, decay = 0.1, sust = 0.7, rel = 0.2, attackf = 0.1, decayf = 0.1, sustf = 0.9, relf = 0.2, gate = 1, freq =440;

var oscArray = [Saw.ar(freq ), SinOsc.ar(freq), Pulse.ar(freq)];
var oscArray2 = [Saw.ar(freq), SinOsc.ar(freq), Pulse.ar(freq)];
var ampEnv = EnvGen.ar(Env.adsr(attack, decay, sust, rel), gate, doneAction:2);
var filterEnv = EnvGen.ar(Env.adsr(attackf, decayf, sustf, relf), gate, doneAction:2);
var osc1 = Select.ar(oscType, oscArray);
var osc2 = Select.ar(oscType2, oscArray2);
var fade = XFade2.ar(osc1, osc2, pan , level * ampEnv);
var filter = MoogFF.ar(fade, cutoff * filterEnv, gain);

Out.ar(0, Pan2.ar(filter, 0.5, 1))
}).store;



Pbind(
\instrument, "Moog",
\freq, Pseq([440, 550, 660, 770, 660, 330, 880], inf),
\dur, Pseq([0.2, 0.4, 0.1, 0.2, 0.2], inf),
\oscType, Pseq([0,0,0,0,0], inf),
\oscType2, Pseq([0,0,2,2,1], inf),
\cutoff, Pseq([100,599,1000,20,800], inf),
\pan, Pseq([1], inf)

).play;
