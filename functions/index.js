const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);

const db = admin.firestore();
const fcm = admin.messaging();



var newData;

//onCreate is fired when new document is added to specified collection
exports.messageTrigger = functions.firestore.document('messages/{names}/chats').onCreate(async (snapshot, context)=> {
    if(snapshot.exists){
        newData = snapshot.data;
        var payload = {
            notification: {title: "FCF Title", body: "FCF Title", sound: "default"}, data: {message:"Sample FCM Message"}
        }
    }
});

// export const changeFlag = functions.firestore.document('residences/{name}').onUpdate(async snapshot => {
//     const residence = snapshot.data();

//     const payload = admin.messaging. = {
//         notification: {
//             title: 'Flag Change',
//             body: `${residence.name} Flag is out`,
//             icon: `your-icon-url`, 
//             clickAction: 'FLUTTER_NOTIFICATION_CLICK'
//         }
//     }
//     return fcm.send(payload); 
// });

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

