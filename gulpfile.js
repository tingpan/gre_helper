var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
var inject = require('gulp-inject');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var coffee = require('gulp-coffee');

var paths = {
  sass: ['./scss/**/*.scss', './www/**/*.scss', '!./www/lib/**/*.scss'],

  css: [
    './www/css/app.css',
    './www/css/components/**/*.css',
    '!./www/css/components/**/*.min.css',
    './www/css/pages/**/*.css',
    '!./www/css/pages/**/*.min.css'
  ],

  libcss: [],

  coffee: ['./coffee/**/*.coffee','./www/**/*.coffee', '!./www/lib/**/*.coffee'],

  js: [
    './www/js/**/*.js',
    '!./www/js/app.beifen.js'
  ],

  libjs:[
    './www/lib/ngCordova/dist/ng-cordova.min.js',
    './www/lib/animate.css/animate.min.css',
    './www/lib/jquery/dist/jquery.min.js'
  ],

  pages: [
    './www/app.layout.html',
    './www/components/**/*.html',
    './www/pages/**/*.html'
  ]
};

gulp.task('default', ['sass', 'coffee', 'inject']);

gulp.task('inject', function(){
  return gulp.src('./www/app.layout.html')
    .pipe(inject(
      gulp.src(paths.libjs,{read: false}),{
        relative:true,
        starttag: '<!-- inject:libjs -->',
        endtag: '<!-- endinject -->'
      }))
    .pipe(inject(
      gulp.src(paths.js,{read: false}),{
        relative:true,
        starttag: '<!-- inject:js -->',
        endtag: '<!-- endinject -->'
      }))
    .pipe(inject(
      gulp.src(paths.css,
        {read: false}), {relative: true}))
    .pipe(inject(
      gulp.src(paths.libcss,{read: false}),{
        relative:true,
        starttag: '<!-- inject:libcss -->',
        endtag: '<!-- endinject -->'
      }))
    .pipe(rename('index.html'))
    .pipe(gulp.dest('./www'))
});

gulp.task('sass', function(done) {
  gulp.src(paths.sass)
    .pipe(sass({
      errLogToConsole: true
    }))
    .pipe(gulp.dest('./www/css/'))
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/css/'))
    .on('end', done);
});

gulp.task('coffee', function() {
  gulp.src(paths.coffee)
    .pipe(coffee({bare: true})
      .on('error', gutil.log))
    .pipe(gulp.dest('./www/js'))
});

gulp.task('watch', function() {
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.coffee, ['coffee']);
  gulp.watch([
    paths.js,
    paths.css,
    paths.pages
  ], ['inject']);
});

gulp.task('install', ['git-check'], function() {
  return bower.commands.install()
    .on('log', function(data) {
      gutil.log('bower', gutil.colors.cyan(data.id), data.message);
    });
});

gulp.task('git-check', function(done) {
  if (!sh.which('git')) {
    console.log(
      '  ' + gutil.colors.red('Git is not installed.'),
      '\n  Git, the version control system, is required to download Ionic.',
      '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
      '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
    );
    process.exit(1);
  }
  done();
});
