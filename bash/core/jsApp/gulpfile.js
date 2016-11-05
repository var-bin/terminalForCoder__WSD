// gulpfile.js

"use strict";

var gulp = require("gulp"),
    postcss = require("gulp-postcss"),
    concat = require("gulp-concat"),
    rename = require("gulp-rename"),
    csso = require("postcss-csso"),
    removeRoot = require("postcss-remove-root"),
    nestRules = require("postcss-nested"),
    inject = require("postcss-inject"),
    cssvariables = require("postcss-css-variables"),
    autoprefixer = require("autoprefixer");

var fs = require("fs"),
    path = require("path");

var BASE_PATH = "../assets/",
    DIST_CSS = "/_dist/css",
    STYLES = {
      base: {
        path: function (theme) {
          return [path.join(BASE_PATH, theme, "_styles/vars.css"),
                  path.join(BASE_PATH, theme, "base/styles.css")];
        },
        concatFilename: "base.css",
        basename: "base",
        prefix: "styles-",
        suffix: ".min",
        extname: ".css"
      },
      all: {
        path: function (theme) {
          return [path.join(BASE_PATH, theme, "**/*.css"),
                  "!" + path.join(BASE_PATH, theme, "_dist/**/*.css"),
                  "!" + path.join(BASE_PATH, theme, "base/*.css"),
                  "!" + path.join(BASE_PATH, theme, "_styles/*.css")];
        },
        prefix: "styles-",
        suffix: ".min",
        extname: ".css"
      }
    };

// get themes list
function getThemes(dir) {
  return fs.readdirSync(dir).filter(function (file) {
    return fs.statSync(path.join(dir, file)).isDirectory();
  });
}

// create styles-base.min.css for each theme
gulp.task("base-css-concat", function() {
  var dirs = getThemes(BASE_PATH);

  dirs.forEach(function (dir) {
    var distPath = path.join(BASE_PATH, dir, DIST_CSS);

    gulp.src(STYLES.base.path(dir))
      .pipe(concat(STYLES.base.concatFilename))
      .pipe(postcss([autoprefixer, cssvariables({
        preserve: true
      }), nestRules, csso]))
      .pipe(rename({
        basename: STYLES.base.basename,
        prefix: STYLES.base.prefix,
        suffix: STYLES.base.suffix,
        extname: STYLES.base.extname
      }))
      .pipe(gulp.dest(distPath))
  });
});

// work with other components for each theme
gulp.task("minify-css", function () {
  var dirs = getThemes(BASE_PATH);

  dirs.forEach(function (dir) {
    var distPath = path.join(BASE_PATH, dir, DIST_CSS);

    gulp.src(STYLES.all.path(dir))
      .pipe(postcss([autoprefixer, inject({
        cssFilePath: STYLES.base.path(dir)[0]
      }), cssvariables({
        preserve: true
      }), removeRoot, nestRules, csso]))
      .pipe(rename(function (file) {
        var dirname = file.dirname,
            filename = dirname;

        file.dirname = "";
        file.basename = STYLES.all.prefix + filename + STYLES.all.suffix;
        file.extname = STYLES.all.extname;

        return file;
      }))
      .pipe(gulp.dest(distPath));
  });
});

gulp.task("default", ["base-css-concat", "minify-css"]);