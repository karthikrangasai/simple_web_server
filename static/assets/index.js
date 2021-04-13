var c = document.getElementById("c");
var ctx = c.getContext("2d");

c.height = window.innerHeight;
c.width = window.innerWidth;

var base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
base64 = base64.split("");

var font_size = 20;
var columns = c.width / font_size;
var drops = [];

for (var x = 0; x < columns; x++) {
	drops[x] = 1;
}

function draw() {
	ctx.fillStyle = "rgba(0, 0, 0, 0.07)";
	ctx.fillRect(0, 0, c.width, c.height);

	ctx.fillStyle = "#0F0";
	ctx.font = font_size + "px arial";
	for (var i = 0; i < drops.length; i++) {
		var text = base64[Math.floor(Math.random() * base64.length)];
		ctx.fillText(text, i * font_size, drops[i] * font_size);
		if (drops[i] * font_size > c.height && Math.random() > 0.975)
			drops[i] = 0;
		drops[i]++;
	}
}
setInterval(draw, 33);