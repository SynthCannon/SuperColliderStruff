(
b = Buffer.alloc(s, 44100 * 4.0, 1); // a four second 1 channel Buffer
)

(
SynthDef("help-RecordBuf",{ arg out=0,bufnum=0;
	var formant;
	// XLine will free the Synth when done
	formant = Formant.ar(XLine.kr(400,1000, 4, doneAction: 2), 2000, 800, 0.125);
	RecordBuf.ar(formant, bufnum);
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)

// play it back
(
SynthDef("help-RecordBuf play",{ arg out=0,bufnum=0;
	var playbuf;
	playbuf = PlayBuf.ar(1,bufnum);
	FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
	Out.ar(out, playbuf);
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)

// overdub
(
SynthDef("help-RecordBuf overdub",{ arg out=0,bufnum=0;
	var formant;
	// XLine will free the Synth when done
	formant = Formant.ar(XLine.kr(200, 1000, 4, doneAction: 2), 2000, 800, 0.125);
	RecordBuf.ar(formant, bufnum, 0, 0.5, 0.5); // mixes equally with existing data
}).play(s,[\out, 0, \bufnum, b.bufnum]);
)

// play back the overdubbed version
(
Synth.new("help-RecordBuf play", [\out, 0, \bufnum, b.bufnum], s);
)

// write the contents of the buffer to a file
(
b.write(thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff", sampleFormat: 'int16');
)

(
b.write(sampleFormat: 'int16');
thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff"; // generated path
)

// cleanup
b.close;
b.free; // cleanup

s.meter;
