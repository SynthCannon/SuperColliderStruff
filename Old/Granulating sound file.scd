(
SynthDef(\help_playbuf, { | out=0, bufnum = 0, rate = 1, startPos = 0, amp = 0.1, sustain = 1, pan = 0, loop = 1|
    var audio;
    rate = rate * BufRateScale.kr(bufnum);
    startPos = startPos * BufFrames.kr(bufnum);

    audio = BufRd.ar(1, bufnum, Phasor.ar(0, rate, startPos, BufFrames.ir(bufnum)), 1, 1);
    audio = EnvGen.ar(Env.sine, 1, timeScale: sustain, doneAction: 2) * audio;
    audio = Pan2.ar(audio, pan, amp);
    OffsetOut.ar(out, audio);
}).add;

a = Pproto({
    ~newgroup = (type: \group).yield;
    ~sf1 = SoundFile(Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff").asEvent.yield;
//    (type: \on).yield
},
    Pbind(*[
        instrument:    \help_playbuf,
        dur:        Pseg([0,0,0.25,0.5, 0.75, 1],10).linexp(0,1,0.01,2),
        legato:        4,
        startPos:    Pn(Pseg([0,1], 20), inf),
        rate:        Pwhite(3, 5).midiratio,
        loop:        0,
        group:        Pkey(\newgroup),
        bufnum:        Pkey(\sf1)
    ])
);
a.play;
)