// In Qt GUI:
// To zoom in/out: Shift + right-click + mouse-up/down
// To scroll: right-click + mouse-left/right
(
w = Window.new("soundfile test", Rect(200, 300, 740, 100))
.front
.alwaysOnTop_(true);

f = SoundFile.new;
f.openRead(Platform.resourceDir +/+ "sounds/01 Gold Panda - You.flac");
//f.inspect;

a = SoundFileView.new(w, Rect(20,20, 700, 60));

a.soundfile = f;
a.read(0, f.numFrames);
a.elasticMode = true;
// for longer files, you can use:
a.readWithTask(0, f.numFrames);


a.timeCursorOn = true;
a.timeCursorColor = Color.red;
a.timeCursorPosition = 20500;
a.drawsWaveForm = true;
a.gridOn = true;
a.gridResolution = 0.2;

//f.play;
)