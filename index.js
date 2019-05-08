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

	if(process.env.pass != req.query.pass)
	{
		return res.send('no auth')
	}

	var count = req.query.count || 14
	var increment = (req.query.inc ? (req.query.inc * 60) : (3600 * 24)) * 1000

	cams.map(function(cam) {
		cd = { images: [], name: config[cam] || cam, videos: [ 
			{ title: '24hrs', path: cam + '/' + '24hrs.mp4' },
			{ title: 'Week', path: cam + '/' + 'week.mp4' }] }
		for(var i = 0; i < count; ++i) {
			now = new Date()
			file = df(new Date(now.getTime() - (i * increment) - 120 * 1000), "yyyy-mm-dd_HH:MM.jpg")
			cd['images'].push(cam + '/' + file);
		}
		data.push(cd)
	})
  res.render('index', { cameras: data })
})

app.listen(port, function () {
  console.log('Example app listening on port ' + port + '!')
})


