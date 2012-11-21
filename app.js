// Generated by CoffeeScript 1.3.3
(function() {
  var docpadInstance, docpadInstanceConfiguration, express, fs, http, siteConfig,
    _this = this;

  siteConfig = require('./config/site');

  express = require('express');

  http = require('http');

  fs = require('fs');

  docpadInstanceConfiguration = {
    templateData: {
      site: {
        title: "Сайт Даниила Братченко"
      },
      config: siteConfig,
      getTitle: function() {
        if (this.document.title) {
          return "" + this.document.title + " [" + this.site.title + "]";
        } else {
          return this.site.title;
        }
      },
      getDescription: function() {
        if (this.document.description) {
          return this.document.description;
        }
        return "Личный сайт Даниила Братченко";
      }
    },
    collections: {
      articles: function(database) {
        return database.findAll({
          relativeOutDirPath: 'articles'
        }, [
          {
            date: -1
          }
        ]);
      }
    },
    port: siteConfig.port,
    srcPath: "src",
    outPath: "_out"
  };

  docpadInstance = require('docpad').createInstance(docpadInstanceConfiguration, function(err) {
    if (err) {
      return console.log(err, err.stack);
    }
    return docpad.action('generate server', function(err) {
      if (err) {
        return console.log(err, err.stack);
      }
      return console.log("Running in " + siteConfig.env + " mode @:" + siteConfig.port);
    });
  });

}).call(this);