const { TableClient } = require("@azure/data-tables");
const crypto = require('crypto');

module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    // Check if URL is provided in the query string
    if (req.query.url) {
        const url = req.query.url;

		console.log (`url: ${url}`)


        // Create a TableServiceClient object to interact with the storage account
        const connectionString = process.env.AzureWebJobsStorage;
        const tableName = 'ratings';

        const tableClient = TableClient.fromConnectionString(connectionString, tableName);

		const partitionKey = crypto.createHash('sha256').update(url).digest('hex');


        // Define the table name and query object
		const listEntitiesOptions = {
			queryOptions: {filter:`PartitionKey eq '${partitionKey}'`},
		};

        // Query the table for all ratings for the URL
        const queryIterator = tableClient.listEntities(listEntitiesOptions);

        let upvote = 0;
        let downvote = 0;

        for await (const entity of queryIterator) {
            const rating = parseInt(entity.rating);
			if(rating){
				upvote++;
			}else{
				downvote++;				
			}
        }
       
		context.res = {
			status: 200,
			headers: {
				"Content-Type": "application/json"
			},				
			body: { url: url, upvote: upvote, downvote: downvote }
		};

    } else {
        context.res = {
            status: 400,
            body: "Please provide a URL in the query string"
        };
    }
}