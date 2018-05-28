// placing the following code in the file will cause these modifications to be made
// at startup (see also: ServerOptions)
// Save in Library/Application Support/SuperCollider

(
Server.local.options.numOutputBusChannels = 4;    // change number of input and output channels
Server.local.options.numInputBusChannels = 4;
Server.internal.options.numOutputBusChannels = 4;
Server.internal.options.numInputBusChannels = 4;

//Server.local.options.device = "Built-in Audio";    // use a specific soundcard
Server.local.options.device = "USB Audio Device";   // use the system default soundcard

Server.local.options.blockSize = 128; // increase block size (default is 64)
Server.internal.options.blockSize = 128;

Server.local.options.sampleRate = 96000; // increase sampling rate (if your hardware supports it)
Server.internal.options.sampleRate = 96000;
Server.internal.options.sampleRate = nil;    // use the currently selected samplerate of the soundcard

// change the standard archive path to a custom one:
Archive.archiveDir = "~/scwork".standardizePath;


// hook up jack ports to audio channels
"SC_JACK_DEFAULT_INPUTS".setenv("system");
"SC_JACK_DEFAULT_OUTPUTS".setenv("system");

s.boot;

)

//s.quit;

/* More startup options
(
// Mac OSX:
"/Library/Application Support/SuperCollider/startup.rtf"; // for all users
"~/Library/Application Support/SuperCollider/startup.rtf"; // for the current user only

// Linux:
"~/.sclang.sc"

// Windows:
// The file's name is "startup.sc" and must be in the same directory as PsyCollider



// Here is some of my startup file's content:
// change the appearance of the post window
Document.listener.background = Color(0, 0, 0, 0.95);
Document.listener.stringColor = Color(1, 1, 1, 1);
Document.postColor_(Color(0.2, 0.7, 0.3));
Document.listener.bounds = Rect(0, 245, 290, 635); // left-hand side of the screen

// position and color the servers
Server.local.window.bounds = Rect(0, 120, 290, 100);
Server.internal.window.bounds = Rect(0, 0, 290, 100);
Server.local.window.background = Color(0.4, 0.3, 0.3, 0.9);
Server.internal.window.background = Color(0.4, 0.4, 0.5, 0.9);

// give SC 32x the default memory
Server.internal.options.memSize = 8192 * 32;


// Now this is cool: auto-colorize syntax while you type! (a trick found in the sc-users list, I think it's Josh's):
Document.globalKeyDownAction_({arg doc, char, mod, unicode, keycode;
	var cursor, open, closed;
	var sstart=doc.selectionStart, ssize=doc.selectionSize;
	(doc.name.find("htm").isNil
	and: {doc.name.find("rtf").isNil}
	and: {doc.name.find("rtfd").isNil}
	and: {doc.isListener == false})
	.if({
		(unicode==13 or: {unicode==32 or: {unicode==3 or: {unicode==46}}}).if({
		doc.syntaxColorize;
		});
	});
});
)
*/