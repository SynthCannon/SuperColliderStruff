(
w = {   |period=0|
        var change, rate, sig, carrierFreq, cfRamp, carrierLvl, clRamp,
        modulatorRatio, mrRamp, modulatorIndex, miRamp, outputAmplitude, oaRamp;

        period = period * 600 + 100;

        // Calculation of a recursive working metronome (Impulse.kr) that generates its
        // changing frequency out of its own impulses.
        change = Impulse.kr(LocalIn.kr(1,10));
        rate = CoinGate.kr(1/3, change);
        rate = (TChoose.kr(rate, period/((0..1) + 1))/1000).reciprocal;
        LocalOut.kr(rate);

        # carrierFreq, cfRamp = TIRand.kr(0, [1000, 1], change);
        carrierFreq = Ramp.kr( carrierFreq / 1000, (cfRamp * period) / 1000 ) * 0.6;

        # carrierLvl, clRamp = TIRand.kr(0, [9000, 1], CoinGate.kr(1/3, change));
        carrierLvl = Ramp.kr( carrierLvl, (clRamp * period) / 1000) + 100;

        # modulatorRatio, mrRamp = TIRand.kr([800,1], CoinGate.kr(1/4, change));
        modulatorRatio = Ramp.kr(modulatorRatio, (mrRamp * period) / 1000) + 20;

        # modulatorIndex, miRamp = TIRand.kr(0, [100, 1], CoinGate.kr(1/4, change));
        modulatorIndex = Ramp.kr(modulatorIndex / 200, (miRamp * period) / 1000) + 0.2;

        # outputAmplitude, oaRamp = TIRand.kr(0!2, 1!2, CoinGate.kr(1/2, change));
        outputAmplitude = Ramp.kr(outputAmplitude, (oaRamp * period + 3) / 1000);

        // jointed FM Synthesizer
        sig = LFSaw.ar(carrierFreq, 1, 0.5, 0.5) * carrierLvl;
        sig = sig + SinOsc.ar(carrierFreq * modulatorRatio) * modulatorIndex;
        sig = cos(sig * 2pi) * outputAmplitude;

        // One pole filters:
        sig = OnePole.ar(sig, exp(-2pi * (10000 * SampleDur.ir)));
        sig = OnePole.ar(sig, exp(-2pi * (10000 * SampleDur.ir)));
        sig = (sig - OnePole.ar(sig, exp(-2pi * (100 * SampleDur.ir))));
        sig = (sig - OnePole.ar(sig, exp(-2pi * (100 * SampleDur.ir))));
        sig = sig!2 * 0.06;
}.play;
)

// period controls the talk-speed. range: 0-1. 0 matches to fast, 1 to slow:
w.set(\period, 1);
w.set(\period, 0);
w.set(\period, 0.5);
w.set(\period, 0.7);
w.set(\period, 0.3);

// To stop:
w.free;



//*********************************************
// Fig 57.2: FM synthesiser for computer noises

(
SynthDef(\fmSynth, { |carrierFreq=100, carrierLvl=0.5, modulatorRatio=5, modulatorIndex=1.5, outputAmp=0.2, sig, out=0|

        // the simple FM core
        sig = LFSaw.ar(carrierFreq, 1, 0.5, 0.5) * carrierLvl;
        sig = sig + SinOsc.ar(carrierFreq * modulatorRatio) * modulatorIndex;
        sig = cos( sig * 2pi) * outputAmp * 0.06;
        Out.ar(out, sig);
},1!5).add;
)

// At first start the synth:
g = Synth(\fmSynth);

// Play with the parameters:
g.set(\carrierFreq, 800);
g.set(\carrierFreq, 50);
g.set(\carrierFreq, 100, \modulatorRatio, 5, \modulatorIndex, 0.5);
g.set(\carrierFreq, 40, \modulatorRatio, 7, \modulatorIndex, 1.5);
g.set(\carrierFreq, 955, \carrierLvl, 0.4, \modulatorRatio, 3, \modulatorIndex, 4);
// ... etc.

// To stop:
g.free;