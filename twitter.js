const Twitter = require('twitter');
const fs = require('fs');


var startDate = new Date(2021,6,7);//startDate="20210707"//
var diff = Math.floor((new Date().getTime() - startDate.getTime()) / (1000 * 3600 * 24));
console.log(diff)

const allFileContents = fs.readFileSync('general.txt', 'utf-8');
var jokes = allFileContents.split(/\r?\n/)
var joke = jokes[diff]

var tweettxt = `${joke}

http://www.dailydadjokes.net

#humor #dadjoke #dailydadjoke`

var client = new Twitter({
  consumer_key: process.env.CONSUMER_KEY,
  consumer_secret: process.env.CONSUMER_SECRET,
  access_token_key: process.env.ACCESS_TOKEN,
  access_token_secret: process.env.ACCESS_TOKEN_SECRET
});

client.post('statuses/update', {status: tweettxt})
	.then(function (tweet) {
		console.log(tweet);
		fs.writeFileSync("./tweets.json", JSON.stringify(records, null, 2));							
	})
	.catch(function (error) {
		console.log(error);
	});	
