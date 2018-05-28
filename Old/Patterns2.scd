(Pbind(\freq,438).play;)

(
Pbind(
	\note, Pseq([0,2,3,5,6,8,11,12],4),
	\dur, Pwhite(0.15,0.5);
).play;
)

(
Pbind(
	\freq, Pwhite(100,500),
	\dur, Prand([0.15,0.25,0.3],4*4),
	\amp, 0.2,
	\legato, Pwhite(1,5)
).trace.play;
)

(
Pbind(
	\note, Pshuf([0,2,3,5,6,7,11,12],6),
	\dur, 0.15;
).trace.play;
)

(
Pbind(
	\note, Pslide([0,2,3,5,7,8,11,12],10,3,1),
	\dur, 0.15;
).trace.play;
)

(
Pbind(
	\note, Pseq([0,2,3,5,7,8,11,12],inf),
	\dur, Pgeom(0.1,1.1,25);
).trace.play;
)

(
Pbind(
	\note, Pseq([0, Pn(2,3), 3, Pn(5,3), 7, Pn(8,3),11,12],2),
	\dur, 0.15;
).trace.play;
)

(
Pbind(
	\note, Pseq([[0,3,7], [2,5,8], [3,7,10], [5,8,12]], 3),
	\dur, 0.15,
	//\strum, 0.1;
).play;
)

(
Pbind(
	\note, Pseq([[-7,3,7,10],[0,3,5,8]], 2),
	\dur, 1,
	\legato, 0.4,
	\strum, 0.1;
).trace.play;
)

(100.0.rand.round(0.01).dup(4);)
(dup(100.0.rand.round(0.01),4);)
(100.0.rand.round(0.01)!(4);)
(Scale.directory)