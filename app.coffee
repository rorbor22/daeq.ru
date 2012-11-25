siteConfig    = require './config/site'
express       = require 'express'
http          = require 'http'
fs            = require 'fs'

docpadInstanceConfiguration = {
    templateData:
        site:
            title: "Сайт Даниила Братченко"
        config: siteConfig
        _: require 'underscore'
        getTitle: ->
            if @document.title 
                return "#{@document.title} [#{@site.title}]"
            else
                return @site.title
        getDescription: ->
            if @document.description then return @document.description 
            return "Личный сайт Даниила Братченко"
    #srcPath: 'content'
    collections:
        articles: (database) ->
            database.findAll({relativeOutDirPath:'articles'},[date:-1])

    port: siteConfig.port
    srcPath: "src"
    outPath: "_out"
}

docpadInstance = require('docpad').createInstance docpadInstanceConfiguration, (err)=>
    if err then return console.log(err, err.stack)
    docpad.action 'generate server', (err)=>
        if err then return console.log(err, err.stack)
        console.log "Running in #{siteConfig.env} mode @:#{siteConfig.port}"