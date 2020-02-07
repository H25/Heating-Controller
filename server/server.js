var express = require('express');
var app = express();
const cors = require('cors');
//const python = require('python-shell');
//const mariadb = require('mariadb');

var port = 8080;

app.use(cors());

app.get('/api/heating_controller/currentValues', function (req, res) {
  console.log("Load last temperatures");
  // sample data
  var data = {
      "datum": "2019-12-16T11:35:00.000Z",
      "klappe": 0,
      "rohr": 200,
      "puffer1": 59,
      "puffer2": 59,
      "puffer3": 59,
      "puffer4": 48,
      "zulauf": 63,
      "boiler": 100
  };
  res.status(200).json(data);
});

app.get('/api/heating_controller/update/:wantupdate', function (req, res) {
  var update = req.params.wantupdate;
  if (update === "true") {
    //python.run('updatevaluesesp.py');
    message = {
      "message":"Run script"
    }
	  res.status(200).json(message);
  } else {
    message = {
      "message":"Bad Request"
    }
    res.status(400).json(message);
  }
});

app.get('/api/heating_controller/series/:startdate/:enddate', function (req, res) {
  var startdate = req.params.startdate;
  var enddate = req.params.enddate;
  var data = {};

  if (startdate == null || enddate == null) {
    message = {
      "message":"Bad Request - missing parameters"
    }
    res.json(message);
    res.status(400);
  } else {
    // sample data
    data = [
        {
        "datum": "2020-01-26T17:45:30.961633Z",
        "klappe": 1, 
        "rohr": 50,
        "puffer1": 49,
        "puffer2": 50,
        "puffer3": 51,
        "puffer4": 52,
        "zulauf": 64,
        "boiler": 50
        },
        {
        "datum": "2020-01-26T16:45:30.961633Z",
        "klappe": 0, 
        "rohr": 35,
        "puffer1": 45,
        "puffer2": 78,
        "puffer3": 48,
        "puffer4": 78,
        "zulauf": 45,
        "boiler": 35
        },
        {
        "datum": "2020-01-26T15:45:30.961633Z",
        "klappe": 1, 
        "rohr": 42,
        "puffer1": 14,
        "puffer2": 45,
        "puffer3": 35,
        "puffer4": 78,
        "zulauf": 45,
        "boiler": 34
        }
    ];
    res.status(200).json(data);
  }
});


app.get('/api/heating_controller/open_hatch/:wantopen', function (req, res) {
  if (req.params.wantopen === "true") {
    //python.run('openhatch.py');
    message = {
      "message":"Run open Hatch"
    }
    res.status(200).json(message);
  } else {
    message = {
      "message":"Bad Request"
    }
    res.status(400).json(message);
  }
});


app.listen(port);
console.log('Listening on http://localhost:' + port);