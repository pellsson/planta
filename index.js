const port = process.env.port || 8080
const configfile = process.env.config || 'config.json'

var fs = require('fs');
var express = require('express')
var df = require('dateformat');
var app = express()

app.set('view engine', 'pug')
app.use(express.static('images'))

app.get('/', function (req, res) {
	var config = {}
	if(fs.existsSync(configfile)) {
		config = JSON.parse(fs.readFileSync(configfile, 'utf8'))
	}
	var cams = fs.readdirSync('./images')
	var data = []

	cams.map(function(cam) {
		cd = { images: [], name: config[cam] || cam }
		for(var i = 0; i < 14; ++i) {
			delta = ((i * 3600 * 24) - 60) * 1000
			now = new Date()
			file = df(new Date(now.getTime() - delta), "yyyy-mm-dd_HH:MM.jpg")
			cd['images'].push(cam + '/' + file);
		}
		data.push(cd)
	})
  res.render('index', { cameras: data })
})

app.listen(port, function () {
  console.log('Example app listening on port ' + port + '!')
})


