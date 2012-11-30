var config = module.exports;

config["jQuery Collapse specs"] = {
  rootPath: "../",
  environment: "browser",
  sources: [
    "vendor/jquery-1.8.3.min.js",
    "js/*.js",
  ],
  tests: [
    "spec/*-spec.coffee"
  ],
  extensions: [require("buster-coffee")]
}