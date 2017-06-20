// This registration token comes from the client FCM SDKs.
var functions = require('firebase-functions');
var admin = require('firebase-admin')
var registrationToken = "fYTTAmYIcBY:APA91bFo4gtaiEaujMtRV6kzu0jJlaSFyTlOc_QY-WaolRcwh8BqrUJ-gUUzkHhEBAkJFEFx198t9hlaGCV7ZI3JHnLhy6tyHLVS9QGEJHseoGvBlMyOxVatjsSvL1GbYiA_AVEsslka";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://userlocation-aba20.firebaseio.com/"
});


var payload = {
  notification: {
    title: "Name of App",
    body: "Someone has shared a journey with you."
  },
};

var options = {
  priority: "high"
}

exports.newEntry = functions.database.ref('/StartedJourneys/{fireUserID}')
  .onWrite(event => {
    const original = event.data.val()
    console.log(original)
    console.log(original.SharedWithUser)
        
    const sharedUserID = original.SharedWithUser
    console.log(sharedUserID)
    var db = admin.database()
    var ref = db.ref('/UserInfo')
    ref.orderByKey().equalTo(sharedUserID).on("child_added", function(snapshot) {
      const deviceToken = snapshot.val()
      console.log(deviceToken)
    })
    
  	return admin.messaging().sendToDevice(registrationToken, payload, options)
  	.then(function(response) {
  	// See the MessagingDevicesResponse reference documentation for
  	// the contents of response.
    	console.log("Successfully sent message:", response);
  	})
  	.catch(function(error) {
    	console.log("Error sending message:", error);
  	});
   
})
