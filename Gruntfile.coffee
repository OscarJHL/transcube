module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")

        jade:
            build:
                options:
                    pretty: true
                    data: 
                        debug: true
                files:
                    "./build/index.html": ["./dev/index.jade"]
            dist:
                options:
                    pretty: false
                    data: 
                        debug: false
                files:
                    "./dist/index.html": ["./dev/index.jade"]

        less:
            options:
                paths: ["./dev/css"]
            build:
                options:
                    sourceMap: true
                    sourceMapRootpath: '../../'
                files:
                    "./build/css/main.css": "./dev/css/main.less"

            dist:
                options:
                    compress: true
                    cleancss: true
                    relativeUrls: true
                files:
                    "./dist/css/main.css": "./dev/css/main.less"

        browserify2:
            build:
                debug: true
                entry: "./dev/js/main.js"
                compile: "./build/js/main.js"
            dist:
                entry: "./dev/js/main.js"
                compile: "./build/js/main.js"

        uglify:
            options:
                banner: "/*! <%= pkg.name %> - v<%= pkg.version %> - <%= grunt.template.today('yyyy-mm-dd') %> */\n"

            dist:
                src: "./build/js/main-clean.js"
                dest: "./dist/js/main.min.js"

        removelogging: 
            dist:
                src: "./build/js/main.js"
                dest: "./build/js/main-clean.js"
                options:
                    methods: ['log']

        copy: 
            build: 
                files: [
                    expand: true
                    cwd: "./dev/media/"
                    src: ["**/*", "!*.less", "!*.psd"]
                    dest: "./build/media/"
                ]
            dist: 
                files: [
                    expand: true
                    cwd: "./dev/media/"
                    src: ["**/*", "!**/*.less", "!**/*.psd"]
                    dest: "./dist/media/"
                ]
            build_libs:
                files: [
                    expand: true
                    cwd: "./dev/js/lib/"
                    src: ["./soundmanager2-nodebug-jsmin.js", "./jquery.plugins.min.js", "./jquery-1.10.1.min.js"]
                    dest: "./build/js/"
                ]
            dist_libs:
                files: [
                    expand: true
                    cwd: "./dev/js/lib/"
                    src: ["./soundmanager2-nodebug-jsmin.js", "./jquery.plugins.min.js", "./jquery-1.10.1.min.js"]
                    dest: "./dist/js/"
                ]

        clean:
            build: ["./build/media"]
            dist: ["./dist/**/*", "!**/.git"]

        cleanlevel:
            build:
                src: ["./dev/media/data/levels/*.json"]
                dest: "./build/media/data/levels"
            dist:
                src: ["./dev/media/data/levels/*.json"]
                dest: "./dist/media/data/levels"

        watch:
            build:
                options:
                    livereload: true
                files: ["./build/**"]
            cleanlevel:
                files: ["./dev/media/data/levels/*.json"]
                tasks: ["cleanlevel"]
            css:
                files: ["./dev/css/**/*.less"]
                tasks: ["less:build"]

            jade:
                files: ["./dev/*.jade"]
                tasks: ["jade:build"]

            js:
                files: ["./dev/js/**/*.js"]
                tasks: ["browserify2:build", "copy:build_libs"]

            media: 
                files: ["./dev/media/**/*"]
                tasks: ["copy:build", "cleanlevel:all"]
    
    grunt.loadNpmTasks "grunt-contrib-less"
    grunt.loadNpmTasks "grunt-contrib-jade"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-browserify2"
    grunt.loadNpmTasks "grunt-remove-logging"

    grunt.loadTasks "./tasks"
 
    grunt.registerTask "dist", ["clean:dist", "jade:dist", "less:dist", "browserify2:dist", "removelogging", "uglify", "copy:dist", "copy:dist_libs", "cleanlevel:dist"]
    grunt.registerTask "default", ["clean:build", "jade:build", "less:build", "browserify2:build", "copy:build", "copy:build_libs", "cleanlevel:build"]