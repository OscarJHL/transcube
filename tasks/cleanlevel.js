module.exports = function(grunt) {
    grunt.registerMultiTask('cleanlevel', 'Cleaning leveldata', function() {

        var data = this.data,
            path = require("path"),
            dest = grunt.template.process(data.dest),
            files = grunt.file.expand(data.src);


        files.forEach(function(file) {
            var jdata, newdata;
            jdata = grunt.file.readJSON(file);
            newdata = {
                name: path.basename(file, '.json'),
                tileheight: jdata.tileheight,
                tilewidth: jdata.tilewidth,
                height: jdata.height,
                width: jdata.width,
                properties: jdata.properties,
                layers: (function() {
                    var obj = {};
                    for(var l in jdata.layers) {
                        var layer = jdata.layers[l];
                        if(layer.name.substr(0,1) !== '_') {
                            obj[layer.name] = {
                                data: layer.data || layer.objects,
                                name: layer.name,
                                type: layer.type,
                                properties: layer.properties
                            }
                        }
                    }
                    return obj;
                })()
            };

            grunt.file.write(dest + '/' + path.basename(file), JSON.stringify(newdata));
        });
    });
};
