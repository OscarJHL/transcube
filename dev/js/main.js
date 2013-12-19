require('./lib/class.js');
require('./lib/requestAnimFrame');

var Input = require('./engine/input');
var config = require('./config');
// DEBUG STUFF

// window.Stats = require('./lib/stats');

// window.debug = {
//     draws: 0,
//     physdebug: true
// }
// var dat = require('./lib/dat.gui');
// window.gui = new dat.GUI({
//     autoPlace: true
// });

// gui.add(debug, 'draws').listen();
// gui.add(config.physics, 'debug').listen();
// gui.add(debug, 'physdebug');
// gui.close();

// GLOBALS




var engine;
$(function() {
    engine = new(require('./engine/engine'))();
});

$(window).resize(function() {
    if (engine) engine.resize.call(engine);
});

$(document).keydown(Input._down.bind(Input));
$(document).keyup(Input._up.bind(Input));
$(document).mousedown(Input._down.bind(Input));
$(document).mouseup(Input._up.bind(Input));
$(document).bind("contextmenu", function(e) {
    return false;
});


$('#github').click(function() {
    window.location = "https://github.com/jeroenverfallie/game-off-2013";
})
