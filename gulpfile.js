var gulp = require('gulp'),
    jade = require('gulp-jade'),
    uglify = require('gulp-uglify'),
    sass = require('gulp-sass'),
    prefix = require('gulp-autoprefixer'),
    csso = require('gulp-csso'),
    //imagemin = require('gulp-imagemin'),
    plumber = require('gulp-plumber'),
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
    crypto = require('crypto'),
    _ = require('lodash'),

    webserver = require('gulp-webserver'),

    karma = require('gulp-karma'),
    source = require('vinyl-source-stream'),
    glob = require('glob'),
    coffee = require('coffee-script'),

    duration = require('gulp-duration'),
    argv = require('yargs').argv,

    runSequence = require('run-sequence'),
    livereload = require('gulp-livereload'),
    gulpif = require('gulp-if');

var DEVELOPMENT = 'development',
    PRODUCTION = 'production',
    USE_FINGERPRINTING = false,
    BUILD = "builds/",
    ASSETS = "/assets",
    MOCKUPS = "_mockups",
    SRC = "_src",
    useServer = false,
    TEST = "test",
    watching = false,
    not_in_dependencies_libs = [
      'select2/select2',
      'bootstrap-datepicker/js/bootstrap-datepicker',
      'angular-ui-utils/modules/validate/validate',
      'angular-ui-utils/modules/mask/mask'
    ];

var env = process.env.NODE_ENV || DEVELOPMENT;
if (env!==DEVELOPMENT) env = PRODUCTION;

var jadeFiles = argv.jade || '*';

var packageJson = require('./package.json');
var dependencies = Object.keys(packageJson && packageJson.dependencies || {});

_.forEach(not_in_dependencies_libs, function(d) {
  dependencies.push(d);
});

function getOutputDir() {
  return BUILD+env;
}

gulp.task('jade', function() {
  var config = {
    "production": env === PRODUCTION,
    "pretty": env === DEVELOPMENT,
    "locals": { "production": env === PRODUCTION }
  };

  var jsManifest      = env === PRODUCTION && USE_FINGERPRINTING ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/js/rev-manifest.json', "utf8"))) : {},
      //vendorManifest  = env === PRODUCTION ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/js-vendor/rev-manifest.json', "utf8"))) : {},
      cssManifest     = env === PRODUCTION && USE_FINGERPRINTING? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/css/rev-manifest.json', "utf8"))) : {},
      imagesManifest  = env === PRODUCTION && USE_FINGERPRINTING ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/images/rev-manifest.json', "utf8"))) : {};

  gulp.src(SRC+"/templates/"+jadeFiles+".jade")
    .pipe(duration('jade'))
    .pipe(jade(config).on('error', gutil.log))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, fingerprint(jsManifest, { base:'assets/js/', prefix: 'assets/js/' })))
    //.pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, fingerprint(vendorManifest, { base:'assets/js/', prefix: 'assets/js/' })))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, fingerprint(cssManifest, { base:'assets/css/', prefix: 'assets/css/' })))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, fingerprint(imagesManifest, { base:'assets/images/', prefix: 'assets/images/' })))
    .pipe(gulpif(env === PRODUCTION, size()))
    .pipe(gulp.dest(getOutputDir())).on('end', function() {
      if (watching) livereload.changed('');
    });
});

function myCoffee(dest, name) {
  dest = dest || getOutputDir()+ASSETS+'/js';
  name = name || 'main.js';

  var bundler = browserify({debug: env === DEVELOPMENT})
    .add('./'+SRC+'/coffee/main.coffee')
      .external(dependencies);

  return bundler.bundle()
    .on('error', function(err) {
      console.log(err.message);
      this.end();
    })
    .pipe(duration('coffee'))
    .pipe(source(name))
    .pipe(buffer())
    .pipe(gulpif(env === PRODUCTION, uglify()))
    .pipe(gulpif(env === PRODUCTION, size()))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, rev()))
    .pipe(gulp.dest(dest))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, rev.manifest()))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, gulp.dest(BUILD+'/rev/js')))
}

gulp.task('coffee', function() {
  gulp.src('./'+SRC+'/coffee/main.coffee')
    .pipe(plumber())
    .pipe(myCoffee());
});

gulp.task('lib', function() {
  env = PRODUCTION;
  gulp.src('./'+SRC+'/coffee/main.coffee')
    .pipe(plumber())
    .pipe(myCoffee('_lib', 'poly-form.min.js'));

  gulp.src(dependencies)
    return browserify()
      .require(dependencies)
      .bundle()
        .on('error', function(err) {
          console.log(err.message);
          this.end();
        })
      .pipe(source('poly-form-lib.min.js'))
      .pipe(duration('vendor'))
      .pipe(buffer())
      .pipe(gulpif(env === PRODUCTION, uglify()))
      .pipe(gulpif(env === PRODUCTION, size()))
      .pipe(gulp.dest('_lib'));
});

gulp.task('clean-js', function() {
  gulp.src(getOutputDir()+ASSETS+'/js', { read: false })
    .pipe(gulpif(env === PRODUCTION, clean()))
});
gulp.task('vendor', function() {
  gulp.src(dependencies)
    return browserify()
      .require(dependencies)
      .bundle()
        .on('error', function(err) {
          console.log(err.message);
          this.end();
        })
      .pipe(source('vendor.js'))
      .pipe(duration('vendor'))
      .pipe(buffer())
      .pipe(gulpif(env === PRODUCTION, uglify()))
      .pipe(gulpif(env === PRODUCTION, size()))
      .pipe(gulp.dest(getOutputDir()+ASSETS+'/js'));
});

gulp.task('autoVariables', function() {
  return gulp.src(MOCKUPS+'/ai/autovariables.scss')
    .pipe(changed(SRC+'/sass'))
    .pipe(gulp.dest(SRC+'/sass'))
});
gulp.task('spriteSass', function() {
  return gulp.src(MOCKUPS+'/sprite/sprites.scss')
    .pipe(changed(SRC+'/sass'))
    .pipe(gulp.dest(SRC+'/sass'))
});
gulp.task('sass', function() {
  var imagesManifest = env === PRODUCTION && USE_FINGERPRINTING ? (JSON.parse(fs.readFileSync("./"+BUILD+'/rev/images/rev-manifest.json', "utf8"))) : {};
  var config = { errLogToConsole: true };

  if (env === DEVELOPMENT) {
    config.sourceComments = 'map';
  } else if (env === PRODUCTION) {
    config.outputStyle = 'compressed';
  }
  return gulp.src(SRC+'/sass/poly-form.scss')
    .pipe(duration('sass'))
    .pipe(plumber())
    .pipe(sass(config).on('error', gutil.log))
    .pipe(gulpif(env === PRODUCTION, prefix("last 2 versions", "> 1%", "ie 8", "ie 7", { cascade: true })))
    .pipe(gulpif(env === PRODUCTION, csso()))
    .pipe(gulpif(env === PRODUCTION, size()))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, fingerprint(imagesManifest, { base:'../images/', prefix: '../images/' })))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, rev()))
    .pipe(gulp.dest(getOutputDir()+ASSETS+'/css'))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, rev.manifest()))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, gulp.dest(BUILD+'/rev/css')))
});
gulp.task('clean-css', function() {
  gulp.src(getOutputDir()+ASSETS+'/css', { read: false })
    .pipe(gulpif(env === PRODUCTION, clean()))
});
gulp.task('images',['clean-images'], function() {
  return gulp.src([MOCKUPS+'/{images,sprite}/**/*.{jpg,png,gif}'])
    .pipe(imagemin({
      progressive: true
    }))
    .pipe(duration('images'))
    .pipe(flatten())
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, rev()))
    .pipe(gulp.dest(getOutputDir()+ASSETS+'/images'))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, rev.manifest()))
    .pipe(gulpif(env === PRODUCTION && USE_FINGERPRINTING, gulp.dest(BUILD+'/rev/images')))
});
gulp.task('clean-images', function() {
  gulp.src(getOutputDir()+ASSETS+'/images', { read: false })
    .pipe(gulpif(env === PRODUCTION, clean()))
});
gulp.task('fonts', function() {
  return gulp.src(['node_modules/bootstrap/assets/fonts/**', MOCKUPS+"/fonts/*"])
    .pipe(gulp.dest(getOutputDir()+ASSETS+'/fonts'))
});

gulp.task('watch', function() {
  watching = true;
  livereload.listen();
  gulp.watch(SRC+'/**/*.jade', ['jade']).on('error', gutil.log);
  gulp.watch(SRC+'/**/*.coffee', ['coffee']).on('error', gutil.log);
  gulp.watch(SRC+'/**/*.scss', ['sass']).on('error', gutil.log);
  gulp.watch(BUILD+env+'/assets/**').on('change', function(file) {
    console.log(file.path);
    livereload.changed(file.path);
  }).on('error', gutil.log);
});

gulp.task('connect', function() {
  useServer = true;
  gulp.src(BUILD+env)
    .pipe(webserver({
      //host: '0.0.0.0',
      livereload: true,
      directoryListing: true,
      open: "index.html"
    }));
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
      frameworks: [
        'jasmine'
      ],
      autoWatch: true,
      singleRun: false,
      browsers: ['Chrome'],
      action: 'start'
    }))
    .on('error', function(err) {
      // Make sure failed tests cause gulp to exit non-zero
      throw err;
    });
});
gulp.task('test', function() {
  runSequence('karma');
  gulp.watch(TEST+'/spec/**/*.{coffee,js,jade}', ['karma']);
  gulp.watch(SRC+'/**/*.{js,coffee}',      ['karma']);
});

gulp.task('default', ['coffee', 'sass', 'jade']);
gulp.task('live', ['coffee', 'jade', 'sass', 'watch']);

gulp.task('build', function() {
  runSequence(['fonts','images','spriteSass','autoVariables'],['fonts','coffee','vendor','sass'],['jade']);
});
gulp.task('server', ['connect', 'watch']);
gulp.task('production', function() {
  env = PRODUCTION;
  runSequence(['images','clean-js'],['fonts','coffee','vendor','sass'],['jade']);
});

//function sha1(buf) {
//  return crypto.createHash('sha1').update(buf).digest('hex');
//}

//function getFilesWithSha1(path) {
//  var a = [];
//  fs.readdirSync(path).map(function(file) {
//    var filePath = path+'/'+file;
//    var stats = fs.lstatSync(filePath);
//    if (stats.isFile()) {
//      var targetDigest = sha1(fs.readFileSync(filePath));
//      a.push(targetDigest)
//    }
//  });
//  return a;
//}
