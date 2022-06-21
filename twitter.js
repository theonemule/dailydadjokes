const Twitter = require('twitter');
const fs = require('fs');
const request = require('request');


var client = new Twitter({
  consumer_key: process.env.TW_CONSUMER_KEY,
  consumer_secret: process.env.TW_CONSUMER_SECRET,
  access_token_key: process.env.TW_ACCESS_TOKEN_KEY,
  access_token_secret: process.env.TW_ACCESS_TOKEN_SECRET
});

var category = "";

if(process.argv.length > 2){
	category = process.argv[2]
}


const data = fs.readFileSync('./tweets.json',
            {encoding:'utf8', flag:'r'});

var records = JSON.parse(data)

if (records.length > 0){
	var queuedTweet;
	
	if(category == ""){
		queuedTweet = records.splice(0,1)[0];
	}else{
		for(var i = 0; i < records.length; i++){
			if(records[i].category == category){
				queuedTweet = records.splice(i,1)[0];
				break;
			}
		}
	}
	

	if(queuedTweet){
		
		if(queuedTweet.evergreen){
			records.push(queuedTweet);
		}		
		
		client.post('statuses/update', {status: queuedTweet.tweet})
			.then(function (tweet) {
				console.log(tweet);
				fs.writeFileSync("./tweets.json", JSON.stringify(records, null, 2));							
			})
			.catch(function (error) {
				console.log(error);
			});	
	}
}
