var gulp = require('gulp'),
    jade = require('gulp-jade'),
    uglify = require('gulp-uglify'),
    sass = require('gulp-sass'),
    //sass = require('gulp-ruby-sass'),
    prefix = require('gulp-autoprefixer'),
    csso = require('gulp-csso'),
    //imagemin = require('gulp-imagemin'),
    browserify = require('browserify'),
    concat = require('gulp-concat'),
    sourcemaps = require('gulp-sourcemaps'),
    changed = require('gulp-changed'),
    rev = require('gulp-rev'),
    gutil = require('gulp-util'),
    flatten = require('gulp-flatten'),
    fingerprint = require('gulp-fingerprint'),
    clean = require('gulp-clean'),
    buffer = require('gulp-buffer'),
    size = require('gulp-size'),
    fs = require('fs'),

    karma = require('gulp-karma'),
    source = require('vinyl-source-stream'),
    glob = require('glob'),
    through = require('through'),
    coffee = require('coffee-script'),

    runSequence = require('run-sequence'),
    livereload = require('gulp-livereload'),
    gulpif = require('gulp-if');

var DEVELOPMENT = 'development',
    PRODUCTION = 'production',
    SASS_ENVIROMENT = "ruby",
    USE_SASS_MAPS = true,
    BUILD = "builds/",
    ASSETS = "/assets",
    MOCKUPS = "_mockups",
    SRC = "_src",
    TEST = "test",
    libs = [
      './node_modules/angular/angular.min.js',
      './node_modules/angular-route/angular-route.min.js',
      './node_modules/underscore/underscore-min.js',
      './node_modules/jquery/dist/jquery.min.js'
    ];

var env = process.env.NODE_ENV || DEVELOPMENT;
if (env!==DEVELOPMENT) env = PRODUCTION;

function getOutputDir() {
  return BUILD+env;
}
gulp.task('jade', function() {
  var config = { "production": env == PRODUCTION }

  var jsManifest      = env === PRODUCTION ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/js/rev-manifest.json', "utf8"))) : {},
      //vendorManifest  = env === PRODUCTION ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/js-vendor/rev-manifest.json', "utf8"))) : {},
      cssManifest     = env === PRODUCTION ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/css/rev-manifest.json', "utf8"))) : {},
      imagesManifest  = env === PRODUCTION ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/images/rev-manifest.json', "utf8"))) : {};

  if (env === DEVELOPMENT) {
    config.pretty = true;
  }
  gulp.src(SRC+"/templates/*.jade")
    .pipe(jade(config).on('error', gutil.log))
    .pipe(gulpif(env === PRODUCTION, fingerprint(jsManifest, { base:'assets/js/', prefix: 'assets/js/' })))
    //.pipe(gulpif(env === PRODUCTION, fingerprint(vendorManifest, { base:'assets/js/', prefix: 'assets/js/' })))
    .pipe(gulpif(env === PRODUCTION, fingerprint(cssManifest, { base:'assets/css/', prefix: 'assets/css/' })))
    .pipe(gulpif(env === PRODUCTION, fingerprint(imagesManifest, { base:'assets/images/', prefix: 'assets/images/' })))
    .pipe(gulpif(env === PRODUCTION, size()))
    .pipe(gulp.dest(getOutputDir()));
});
gulp.task('coffee', function() {
  var bundler = browserify({debug: env === DEVELOPMENT})
    .add('./'+SRC+'/coffee/main.coffee')
    .bundle();
  return bundler
    .pipe(source('main.js'))
    .pipe(buffer())
    .pipe(gulpif(env === PRODUCTION, uglify()))
    .pipe(gulpif(env === PRODUCTION, size()))
    .pipe(gulpif(env === PRODUCTION, rev()))
    .pipe(gulp.dest(getOutputDir()+ASSETS+'/js'))
    .pipe(gulpif(env === PRODUCTION, rev.manifest()))
    .pipe(gulpif(env === PRODUCTION, gulp.dest(BUILD+'/rev/js')))
});

gulp.task('clean-js', function() {
  gulp.src(getOutputDir()+ASSETS+'/js', { read: false })
    .pipe(gulpif(env === PRODUCTION, clean()))
});
gulp.task('vendor', function() {
  gulp.src(libs)
    .pipe(gulpif(env === DEVELOPMENT, sourcemaps.init()))
    .pipe(concat('vendor.js'))
    .pipe(gulpif(env === DEVELOPMENT, sourcemaps.write()))
    .pipe(gulpif(env === PRODUCTION, uglify({mangle:false})))
    .pipe(gulpif(env === PRODUCTION, size()))
    .pipe(gulpif(env === PRODUCTION, rev()))
    .pipe(gulp.dest(getOutputDir()+ASSETS+'/js'))
    .pipe(gulpif(env === PRODUCTION, rev.manifest()))
    .pipe(gulpif(env === PRODUCTION, gulp.dest(BUILD+'/rev/js-vendor')))
});

gulp.task('autoVariables', function() {
  return gulp.src(MOCKUPS+'/ai/autovariables.scss')
    .pipe(changed(SRC+'/sass'))
    .pipe(gulp.dest(SRC+'/sass'));
});
gulp.task('spriteSass', function() {
  return gulp.src(MOCKUPS+'/sprite/sprites.scss')
    .pipe(changed(SRC+'/sass'))
    .pipe(gulp.dest(SRC+'/sass'));
});
gulp.task('sass',['clean-css', 'autoVariables', 'spriteSass'], function() {
  var imagesManifest = env === PRODUCTION ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/images/rev-manifest.json', "utf8"))) : {};
  var config = {style: 'compact'};

  if (env === DEVELOPMENT) {
    config.sourceComments = 'map';
  } else if (env === PRODUCTION) {
    config.sourcemap = false;
    config.outputStyle = 'compressed';
  }
  return gulp.src(SRC+'/sass/main.scss')
    .pipe(sass(config).on('error', gutil.log))
    .pipe(gulpif(!USE_SASS_MAPS, prefix("last 1 version", "> 1%", "ie 8", "ie 7")))
    .pipe(gulpif(env === PRODUCTION, csso().on('error', gutil.log)))
    .pipe(gulpif(env === PRODUCTION, size()))
    .pipe(gulpif(env === PRODUCTION, fingerprint(imagesManifest, { base:'../images/', prefix: '../images/' })))
    .pipe(gulpif(env === PRODUCTION, rev()))
    .pipe(gulp.dest(getOutputDir()+ASSETS+'/css'))
    .pipe(gulpif(env === PRODUCTION, rev.manifest()))
    .pipe(gulpif(env === PRODUCTION, gulp.dest(BUILD+'/rev/css')))
});
gulp.task('clean-css', function() {
  gulp.src(getOutputDir()+ASSETS+'/css', { read: false })
    .pipe(gulpif(env === PRODUCTION, clean()))
});
//gulp.task('images',['clean-images'], function() {
//  return gulp.src([MOCKUPS+'/{images,sprite}/*.{jpg,png,gif}'])
//    .pipe(imagemin({
//      progressive: true
//    }))
//    .pipe(flatten())
//    .pipe(gulpif(env === PRODUCTION, rev()))
//    .pipe(gulp.dest(getOutputDir()+ASSETS+'/images'))
//    .pipe(gulpif(env === PRODUCTION, rev.manifest()))
//    .pipe(gulpif(env === PRODUCTION, gulp.dest(BUILD+'/rev/images')))
//});
//gulp.task('clean-images', function() {
//  gulp.src(getOutputDir()+ASSETS+'/images', { read: false })
//    .pipe(gulpif(env === PRODUCTION, clean()))
//});
gulp.task('fonts', function() {
  return gulp.src(['node_modules/bootstrap/assets/fonts/**', MOCKUPS+"/fonts/*"])
    .pipe(gulp.dest(getOutputDir()+ASSETS+'/fonts'));
});

gulp.task('watch', function() {
  env = DEVELOPMENT;
  gulp.watch(SRC+'/**/*.{jade,svg,json}', ['jade']);
  gulp.watch(SRC+'/**/*.{js,coffee}', ['coffee']);
  gulp.watch(SRC+'/**/*.scss', ['sass']);
  var server = livereload();
  gulp.watch(BUILD+'**').on('change', function(file) {
    server.changed(file.path);
  })
  .on('error', gutil.log);
});

gulp.task('browserify-test', function() {
  var testFiles = glob.sync('./'+TEST+'/spec/**/*.coffee');
  return browserify(testFiles, { debug:true }).bundle()
    .pipe(source('bundle-tests.js'))
    .pipe(gulp.dest(TEST));
});
gulp.task('karma', ['browserify-test'], function() {
  // Be sure to return the stream
  return gulp.src(TEST+"/bundle-tests.js")
    .pipe(karma({
      configFile: TEST+'/karma.conf.js',
      action: 'start'
    }))
    .on('error', function(err) {
      // Make sure failed tests cause gulp to exit non-zero
      throw err;
    });
});
gulp.task('test', function() {
  runSequence('karma');
  gulp.watch(TEST+'/spec/**/*.{coffee,js}', ['karma']);
  gulp.watch(SRC+'/**/*.{js,coffee}',      ['karma']);
});

gulp.task('default', ['coffee', 'sass', 'jade']);
gulp.task('live', ['coffee', 'jade', 'sass', 'watch']);

gulp.task('build', function() {
  runSequence(['fonts','images','spriteSass','autoVariables'],['fonts','coffee','sass'],['jade']);
});

gulp.task('production', function() {
  env = PRODUCTION;
  runSequence(['images','clean-js'],['fonts','coffee','sass'],['jade']);
});