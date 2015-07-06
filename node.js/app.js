/**
 * Curaté
 * Hackathon at MIT Blueprint: February 22, 2015
 * 
 * Anthony Topper
 * Abhinav Kurada
 * Aniruddh Iyengar
 */

process.chdir(__dirname);

// Ensure a "sails" can be located:
(function() {
  var sails;
  try {
    sails = require('sails');
  } catch (e) {
    console.error('To run an app using `node app.js`, you usually need to have a version of `sails` installed in the same directory as your app.');
    console.error('To do that, run `npm install sails`');
    console.error('');
    console.error('Alternatively, if you have sails installed globally (i.e. you did `npm install -g sails`), you can use `sails lift`.');
    console.error('When you run `sails lift`, your app will still use a local `./node_modules/sails` dependency if it exists,');
    console.error('but if it doesn\'t, the app will run with the global sails instead!');
    return;
  }

  // Try to get `rc` dependency
  var rc;
  try {
    rc = require('rc');
  } catch (e0) {
    try {
      rc = require('sails/node_modules/rc');
    } catch (e1) {
      console.error('Could not find dependency: `rc`.');
      console.error('Your `.sailsrc` file(s) will be ignored.');
      console.error('To resolve this, run:');
      console.error('npm install rc --save');
      rc = function () { return {}; };
    }
  }


  // Start server
  sails.lift(rc('sails'));
});


var http = require("http");
var GooglePlaces = require("google-places");

var places = new GooglePlaces('AIzaSyC4t-DwrTTjrC3C28B34m1ctxZK8I3xAhI'); // AIzaSyAQNf94myuvcZPRBd_pDKw0hDO5t6FKbV0

var supportedCats = [
  "restaurant",
  "stadium",
  "food",
  "amusement_park",
  "book_store",
  "clothing_store",
  "movie_theater",
  "cafe",
  "night_club",
  "stadium",
  "point_of_interest"
];

http.createServer(function(req, res) {
    if (req.method == 'POST') {
        var jsonString = '';
        req.on('data', function (data) {
            jsonString += data;
        });
        req.on('end', function () {
            onPost(req.url,jsonString,function (responseData) {
              res.end(responseData);
              console.log("sent",responseData);
              jsonString = '';
            });
            // console.log(jsonString);
        });
    } else {
      res.end("Use satwik");
    }
}).listen(process.env.PORT, process.env.IP);

// var http = require("https");
http.get("http://curlmyip.com/",function (res) {
  var data = '';
  res.on('data',function (c) {
    data+=c;
  });
  res.on('end',function () {
    console.log("IP: "+data);
  });
})

console.log("========= RUNNING ON "+process.env.IP+" =========");

onPost("","{}",function (r) {
  console.log(r);
});

function onPost(path,data,callback) {
    var json = parseJSON(data);
    if (json != null){
        try {
            
            var lat = json.latitude;
            var lon = json.longitude;
            var price = json.price;
            var time = json.time;
            
            // {
            //   latitude
            //   longitude
            //   price
            //   time
            // }
            
            // var lat = 42.360082;
            // var lon = -71.058880;
            
            var r = {locations:[]};
            
            places.search({location:[lat,lon],radius:500},function (error,response) {
                console.log("========= RUNNING ON "+process.env.IP+" =========");
                if (error) { console.log("ERROR places.search: ",error); return; }
                // console.log(response.results); 
                
                var processedCount = 0;
                var len = response.results.length;
                
                console.log("COUNT:",len);
                
                for (var i = 0; i < len; i++){
                  places.details({reference: response.results[i].reference}, function(err, response) {
                   // console.log("search result: ", response.result.name);
                    
                    var result = response.result;
                    var curatecR = curatecRating(response.result,price,{lat:lat,lng:lon},result.geometry.location);
                    
                    console.log("rating: ",curatecR);
                    
                    // ADDED
                    // var types = result.types;
                    // if (!isLegitType(types)) {
                    //   // All responses processed
                    //   if (++processedCount == len) {
                    //     sortByCuratec(r.locations);
                    //     callback(JSON.stringify(r));
                    //   }
                    //   return;
                    // }
                    // END ADDED
                    
                    // RESPONSE PACKAGE
                    r.locations.push({
                      curatec:curatecR+"",
                      name:result.name,
                      address:result.formatted_address,
                      location:(result.geometry? result.geometry.location : {lat:0,lng:0}),
                      icon:result.icon
                    });
                    
                    // All responses processed
                    if (++processedCount == len) {
                      sortByCuratec(r.locations);
                      callback(JSON.stringify(r));
                    }
                    
                  });
                }
                
            });
            
        } catch (e){
            console.log("ERROR onPost: "+e);
        }
    }
}

function isLegitType(types) {
  for (var i = 0; i < types.length; i++) {
    if (supportedCats.indexOf(types[i]) > -1) return true;
  }
  return false;
}

function sortByCuratec(arr) {
  arr.sort(function (a,b) {
    return b.curatec - a.curatec;
  });
}

function parseJSON(str) {
    try {
        return JSON.parse(str)
    } catch (e) {
        console.log("ERROR parseJSON: "+e);
        return null;
    }
}

function distance(x1,y1,x2,y2) {
  return Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
}

function curatecRating(result,price,from,to) {
  // return 5;
  var dist = (from && to)? distance(from.lng,from.lat,to.lng,to.lat) : 10;
  
  var gausFunc = preguassian(getNu(result),4);
    return ((result.rating || 3.5) * 20 + 50 * (riemann(gausFunc,-10,price,20) || 40) + 0.01/dist) / 15.0;
}

function getNu(result) {
  var price = result.price_level || 2;
  return (price * 15 + 7);
}

function preguassian(nu,sigma) {
  var n = nu;
  var s = sigma;
  return function (x) {
    return gaussian(x,n,s);
  }
}

function gaussian(x,nu,sigma) {
  var E = 2.71828182845904523536;
  return (1.0/(sigma*Math.sqrt(2*Math.PI))) * Math.pow( E, -((x-nu)*(x-nu))/(2.0*sigma*sigma) );
}

// LRAM
function riemann(func,start,end,subintervals) {
  var delta = (end - start)/subintervals;
  var sum = 0.0;
  for (var i = 0; i < subintervals; i++) {
    sum += func(start + i * delta);
  }
  sum = sum * delta;
  return sum;
}

console.log("WIKSAT",Math.pow( 2.71828, -((5)*(5))/(2.0*4*4) ));
console.log("WIKSAT",Math.pow( 2.71828, -((.02)*(.02))/(2.0*4*4) ));
console.log("WIK",gaussian(10,10,10));
console.log("WIK",gaussian(10,0,10));
console.log("WIK",gaussian(0,10,10));
console.log("EG",curatecRating({price_level:1,rating:4.5},30,{lat:0,lng:0},{lat:.10,lng:.10}));
console.log("EG",curatecRating({price_level:3,rating:4.5},30,{lat:0,lng:0},{lat:.10,lng:.10}));
console.log("EG",curatecRating({price_level:1,rating:4.5},10,{lat:0,lng:0},{lat:.03,lng:.03}));
console.log("EG",curatecRating({price_level:2,rating:2.5},10,{lat:0,lng:0},{lat:.03,lng:.03}));
console.log("EG",curatecRating({price_level:2,rating:2.5},20,{lat:0,lng:0},{lat:.03,lng:.03}));
