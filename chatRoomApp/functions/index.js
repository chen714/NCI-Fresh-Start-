const functions = require('firebase-functions');
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.sendNotiication = functions.firestore.document("notificationUpdates/{notificationId}").onCreate(async (snapshot, context) => {
    const update = snapshot.data();
    const data = {
      notification: {
        title: 'Update to '+update.courseCode,
        body: update.senderName+' said: ' +update.message,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
      };

      admin
        .messaging()
        .sendToTopic(update.courseCode,data)
        .then(response => {
          // Response is a message ID string
          console.log("Successfully sent message", response);
        })
        .catch(error => {
          console.log("Error sending message", error);
        });
})