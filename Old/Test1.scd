counter: 0, // counter for animation
animatePoints: Array.newClear(numBranches),
// intermediate points for animation
animate: { arg self, speed = 0.01, colors = [Color.red, Color.green];
 self.branches.do{arg i;
 if (self.counter < 1) { // if not done
 self.counter_(self.counter + speed); // update counter
 // calculate line-segments to draw with respect to counter
 self.animatePoints[i] =
 Point(
 position.x + ((points[i].x - position.x)
 * self.counter),
 position.y + ((points[i].y - position.y)
 * self.counter),
 );
 // draw segment
 Pen.strokeColor_(colors[0].blend(colors[1],self.counter));
 // progressively blend colors with respect to counter
 Pen.line(position,self.animatePoints[i]);
 Pen.stroke;
 } { // if done
			// draw the completed fractal
 Pen.strokeColor_(colors[0].blend(colors[1],self.counter));
 Pen.line(position,self.animatePoints[i]);
 Pen.stroke;
 self.counter_(0); // reset counter to start from scratch
 };
 };
 // animate children
 if (self.children.notNil) { // if there are children
 // draw all of their branches
 self.children.do{arg item;
 item.animate(speed,colors);
 };
 };
},


( // fractal animation
var window, userView, fractal;
// first load the fractal factory
(PathName(thisProcess.nowExecutingPath).pathOnly ++
"9677OS_05_07.scd").loadPaths;
window = Window("fractal animation", 640@640).front;
fractal = ~fractalFactory.value(5, 7, window.bounds.center, 60,0.5);
// create a fractal
userView = UserView(window, 640@640).background_(Color.black).animate_
(true).frameRate_(30).drawFunc_({
	fractal.animate(0.001,[Color.red,Color.green]); // animate it
});
)