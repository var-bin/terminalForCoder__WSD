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

var BASE_PATH = path.resolve("../assets/origin/baseTheme"),
    DIST_PATH = path.resolve("../assets/origin/baseTheme/_dist/css"),
    STYLES = {
      base: {
        path: [path.join(BASE_PATH, "_styles/vars.css"),
                path.join(BASE_PATH, "base/styles.css")],
        concatFilename: "base.css",
        basename: "base",
        prefix: "styles-",
        suffix: ".min",
        extname: ".css"
      },
      all: {
        path: [path.join(BASE_PATH, "**/*.css"),
                "!" + path.join(BASE_PATH, "_dist/**/*.css"),
                "!" + path.join(BASE_PATH, "base/*.css"),
                "!" + path.join(BASE_PATH, "_styles/*.css")],
        prefix: "styles-",
        suffix: ".min",
        extname: ".css"
      }
    };

gulp.task("base-css-concat", function () {
  return gulp.src(STYLES.base.path)
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
  .pipe(gulp.dest(DIST_PATH))
});

gulp.task("minify-css", function () {
  return gulp.src(STYLES.all.path)
  .pipe(postcss([autoprefixer, inject({
    cssFilePath: STYLES.base.path[0]
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
  .pipe(gulp.dest(DIST_PATH));
});

gulp.task("default", ["base-css-concat", "minify-css"]);