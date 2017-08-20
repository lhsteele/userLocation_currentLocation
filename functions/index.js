var functions = require('firebase-functions');
var admin = require('firebase-admin')
var userDeviceToken = "";
var sharedUserID = "";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://userlocation-aba20.firebaseio.com/"
});


var payloadStart = {
  notification: {
    title: "See You Soon!",
    body: "Someone has shared a journey with you."
  },
}

var options = {
  priority: "high"
}

var payloadEnd = {
  notification: {
    title: "See You Soon!",
    body: "A shared journey has ended."
  },
}

exports.newEntry = functions.database.ref('/StartedJourneys/{fireUserID}')
  .onWrite(event => {
    const original = event.data.val()
    
    if (original.JourneyEnded != true) {
    	var payload = payloadStart;
    } else {
    	var payload = payloadEnd;
    }

    sharedUserID = original.SharedWithUserID;
    var db = admin.database();
    var ref = db.ref('/UserTokens');
    console.log (sharedUserID)
    
    return ref.orderByKey().equalTo(sharedUserID).on("child_added", function(snapshot) {
      const deviceToken = snapshot.val();
      console.log (deviceToken)

      admin.messaging().sendToDevice(deviceToken, payload, options)
	  	.then(function(response) {
	    	console.log("Successfully sent message:", response);
	  	})
	  	.catch(function(error) {
	    	console.log("Error sending message:", error);
	  	});

    })
   	
})

