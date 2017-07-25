// This registration token comes from the client FCM SDKs.
var functions = require('firebase-functions');
var admin = require('firebase-admin')
//var registrationToken = "f2og_pbqadc:APA91bH6MJynSoPqqDzxGDKkfUJf6zwGatniXTU5HrRpEYlpSC2Y4TNBZnAiHnrlowFgx1E8MFavixW6Hnp_nQioY6tO4dc6LyAAEanE0Sxh-7T_91yb596Mpyh9C_urD2BZ-bu8Hx_W";
var userDeviceToken = ""
var sharedUserID = ""

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://userlocation-aba20.firebaseio.com/"
});


var payloadStart = {
  notification: {
    title: "See You Soon",
    body: "Someone has shared a journey with you."
  },
};

var options = {
  priority: "high"
}

var payloadEnd = {
  notification: {
    title: "See You Soon",
    body: "A shared journey has ended."
  },
};

exports.newEntry = functions.database.ref('/StartedJourneys/{fireUserID}')
  .onWrite(event => {
    const original = event.data.val()
    //console.log(original)
    console.log(original.SharedWithUserID)
    console.log(original.JourneyEnded)
    console.log(event.data.changed())
    console.log(event.data.exists())
    console.log(event.data.previous)
    console.log(event.params)
    var payload = payloadStart
    if (original.JourneyEnded) {
    	payload = payloadEnd
    } 
        
    sharedUserID = original.SharedWithUserID
    console.log(sharedUserID)
    var db = admin.database()
    var ref = db.ref('/UserTokens')
    return ref.orderByKey().equalTo(sharedUserID).on("child_added", function(snapshot) {
      const deviceToken = snapshot.val()
      //userDeviceToken = deviceToken
      //console.log(userDeviceToken)

      admin.messaging().sendToDevice(deviceToken, payload, options)
	  	.then(function(response) {
	  	// See the MessagingDevicesResponse reference documentation for
	  	// the contents of response.
	    	console.log("Successfully sent message:", response);
	  	})
	  	.catch(function(error) {
	    	console.log("Error sending message:", error);
	  	});

    })
   
})

/*
exports.secondEntry = functions.database.ref('/StartedJourneys/{fireUserID}/JourneyEnded')
	.onUpdate(event => {
		const original = event.data.val()
		
		console.log(sharedUserID)
		var db = admin.database()
		var ref = db.ref('/UserTokens')
		return ref.orderByKey().equalTo(sharedUserID).on("child_added", function(snapshot) {
			const deletionDeviceToken = snapshot.val()
			console.log("XXX")
			userDeletionDeviceToken = deletionDeviceToken
			console.log(userDeletionDeviceToken)

			admin.messaging().sendToDevice(userDeletionDeviceToken, secondPayload, options)
				.then(function(response) {
					console.log("Successfully sent message:", response);
				})
				.catch(function(error) {
					console.log("Error sending message:", error);
			});
	})
})
*/
