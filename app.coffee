siteConfig    = require './config/site'
express       = require 'express'
_             = require 'underscore'
fs            = require 'fs'

app           = express()

app.configure () ->
    app.engine 'html', (require 'uinexpress').__express
    app.set 'view engine', 'html'
    app.set 'views', "#{__dirname}/tpl"
    
    app.locals {
        config: siteConfig
    }
    app.use express.bodyParser()
    app.use express.cookieParser(siteConfig.sessionSecret)
    app.use express.cookieSession({
        cookie: {
            maxAge: 1000 * 86400 * 365 * 5 # 5 years
        }
    })

    app.use express.static "#{__dirname}/public"

    app.set "view options", layout: 'layout.html'

app.configure 'development', () ->

app.configure 'production', () ->
    app.all '/robots.txt', (req,res) ->
        res.send 'User-agent: *', 'Content-Type': 'text/plain'

initRoutes = (path)->
    files = fs.readdirSync path;
    for file in files
        curPath = "#{path}/#{file}"
        if fs.statSync(curPath).isDirectory()
            initRoutes curPath
        else
            (require curPath)(app)
initRoutes "#{__dirname}/routes"

app.all '*', (req, res) ->
    throw new NotFound(req.url)

class NotFound extends Error
    constructor: (path) ->
        @.name = 'NotFound'
        @.path = path
        Error.call @, path        
        Error.captureStackTrace @, arguments.callee

# Handle application errors
app.use (err, req, res, next) ->
    if err 
        if err instanceof NotFound
            res.render 'errors/404.html', {error: err}, ()->
                res.send(404)
        else
            res.render 'errors/500.html', {error: err}, ()->
                res.send(500)
    else 
        next()

console.log "Running in #{siteConfig.env} mode @:#{siteConfig.port}"

app.listen(siteConfig.port)

