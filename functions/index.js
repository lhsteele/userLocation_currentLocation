// This registration token comes from the client FCM SDKs.
var functions = require('firebase-functions');
var admin = require('firebase-admin')
//var registrationToken = "f2og_pbqadc:APA91bH6MJynSoPqqDzxGDKkfUJf6zwGatniXTU5HrRpEYlpSC2Y4TNBZnAiHnrlowFgx1E8MFavixW6Hnp_nQioY6tO4dc6LyAAEanE0Sxh-7T_91yb596Mpyh9C_urD2BZ-bu8Hx_W";
var userDeviceToken = ""

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
    var ref = db.ref('/UserTokens')
    ref.orderByKey().equalTo(sharedUserID).on("child_added", function(snapshot) {
      const deviceToken = snapshot.val()
      userDeviceToken = deviceToken
      console.log(userDeviceToken)
    })
    
  	return admin.messaging().sendToDevice(userDeviceToken, payload, options)
  	.then(function(response) {
  	// See the MessagingDevicesResponse reference documentation for
  	// the contents of response.
    	console.log("Successfully sent message:", response);
  	})
  	.catch(function(error) {
    	console.log("Error sending message:", error);
  	});
   
})
