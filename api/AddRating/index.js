const { TableClient } = require("@azure/data-tables");
const crypto = require('crypto');

module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    // Check if rating value is provided in the request body
    if (req.body && "rating" in req.body && "url" in req.body) {
        const rating = parseInt(req.body.rating);
		if (rating != 0 && rating != 1){
			context.res = {
				status: 500,
				body: "Please provide a rating as 0 or 1."
			};						
		}else{
			
			// Generate a unique ID for the rating record
			const id = Date.now().toString();
			// Define the table name and entity object
			const tableName = 'ratings';
			
		
			const ratingEntity = {
				partitionKey: crypto.createHash('sha256').update(req.body.url).digest('hex'),
				rowKey: id,
				rating: rating
			};

			// Insert the entity into the table
			const connectionString = process.env.StorageAcct;

			const tableClient = TableClient.fromConnectionString(connectionString, tableName);
			await tableClient.createEntity(ratingEntity);

			context.log(`Rating saved to storage with ID ${id}`);
			context.res = {
				headers: {
					"Content-Type": "application/json"
				},	
				body: {
					message: `Rating ${rating} saved for URL ${req.body.url}`
				}
			};			
		}        
    } else {
        context.res = {
            status: 400,			
			headers: {
				"Content-Type": "application/json"
			},				
            body: {message: "Please provide a rating value and URL in the request body."}
        };
    }
}