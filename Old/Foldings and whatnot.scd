// examples of unary operations
{[ LFSaw.ar(200), LFSaw.ar(200).abs]*0.8}.plot; // rectify waveform
{ (LeakDC.ar(LFTri.ar(800),SinOsc.kr(50))*8)!2}.scope;
// convert triangular to rectified sinusoid
{BrownNoise.ar(20).distort(0)}.plot;
// next height integer
{[ SinOsc.ar(200), SinOsc.ar(200,mul:2).floor * 0.5 ]*0.8}.scope;
// the same on an amplified sine wave
{[SinOsc.ar(200),SinOsc.ar(200).sign]*0.8}.scope;
// convert a sine into a rectangular wave
{[SinOsc.ar(),LeakDC.ar(SinOsc.ar(add:1).reciprocal)]}.scope;
/* reciprocal of a sine wave, dc-bias is needed to avoid infinities
when the input crosses zero */

{(LeakDC.ar( SinOsc.ar(mul:4,add:2) << WhiteNoise.ar(2,2)) >> 3) *0.2}.stethoscope;