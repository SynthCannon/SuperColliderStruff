var beat=[0,1,0,1,1,2,3];
// var beat=[0,1,0,1];

SynthDef(\kik, {|d=0.2, basefreq=80|
    var e = EnvGen.kr(Env.perc(0.01, d), doneAction:2);
    var s = SinOsc.ar(basefreq+(60*e), mul: e);
    Out.ar(0, Pan2.ar(s, 0.5, 0.2));
}).add;

SynthDef(\sna, {|amp=1|
    var e = EnvGen.kr(Env.perc(0.01, 0.12), doneAction:2);
    var s = PinkNoise.ar(mul: e * amp);
    Out.ar(0, Pan2.ar(s, 0.5, 0.2));
}).add;

SynthDef(\hat, {|amp=1|
    var e = EnvGen.kr(Env.perc(0.01, 0.1), doneAction:2);
    var s = HPF.ar(PinkNoise.ar(mul: e *amp), 6000);
    Out.ar(0, Pan2.ar(s, 0.5, 0.2));
}).add;

SynthDef(\bas, {|freq, amp=1|
    var s = SinOsc.ar(Lag.kr(freq, 0.2), mul: amp);
    Out.ar(0, Pan2.ar(s, 0.5, 0.2));
}).add;

Ppar([
    Pbind(
        \instrument, \kik,
        \dur, Prand([0.2, 0.4], inf),
        \d, Pwrand([0.2, 1, 7.6], [0.9, 0.1, 0.01], inf),
        \freq, Pif(Pxrand(beat, inf).coin, 1, \rest)),
    Pbind(
        \instrument, \hat,
        \amp, Pseq([0.6, 0.4], inf),
        \dur, 0.1,
        \freq, Pif(Pseq(beat, inf, 1).coin, 1, \rest)),
    Pbind(
        \instrument, \sna,
        \amp, 1,
        \dur, 0.4,
        \freq, Pif(Pseq(beat, inf).coin, 1, \rest)),
    Pbind(
        \instrument, \sna,
        \dur, Prand([0.2, 0.3, 0.6],inf),
        \amp, Prand((0.2,0.3..0.7), inf),
        \freq, Pif(Pseq(beat, inf).coin, 1, \rest)),
    Pbind(
        \dur, Prand((1, 2..5), inf),
        \amp, 0.003,
        \root, -12,
        \degree, Prand((1, 2..12), inf)+(1, 3..7)),
    Pmono(
        \bas,
        \dur, Pwrand([0.2, 0.8, 1, 2], [0.15, 0.7, 0.1, 0.05], inf),
        \amp, 0.2,
        \root, -24,
        \degree, Prand([0, 2, 4, 5, 7], inf))
]).play;