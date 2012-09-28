# Merges site.common.coffee and site.local.coffee (if present)
fs = require 'fs'

settings = require './site.common.coffee'

mergeSettings = (mergeTo, mergeFrom)->
    if not mergeTo?
        mergeTo = {}
    for key, value of mergeFrom 
        if typeof value == 'object'
            value = mergeSettings mergeTo[key], value 
        mergeTo[key] = value
    return mergeTo

if fs.existsSync "#{__dirname}/site.local.coffee"
    localSettings = require './site.local.coffee'
    settings = mergeSettings(settings, localSettings)
 
module.exports = settings;
