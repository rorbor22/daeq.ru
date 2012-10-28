module.exports = (app)->

    app.get '/', (req, res, next)->
        res.render "index/index.html"

    app.get '/works', (req, res, next)->
        res.render "index/works.html"