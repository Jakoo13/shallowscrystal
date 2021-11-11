const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { user, userRecordConstructor } = require("firebase-functions/v1/auth");

admin.initializeApp(functions.config().functions);

const db = admin.firestore();
const fcm = admin.messaging();






//onCreate is fired when new document is added to specified collection
exports.messageTrigger = functions.firestore.document('/messages/{names}/chats/{chatId}').onCreate(async (snapshot, context)=> {
        var newData;
        newData = snapshot.data();

        var sentFrom = newData.from;
        var sentTo = newData.to;
        var content = newData.content;
        var userRef = admin.firestore().collection("users");
        const userSnapshot = await userRef.get();
        var deviceTokens = [];
        userSnapshot.forEach(doc=> {
            if(doc.data().residence == sentTo){
                deviceTokens.push(doc.data().tokens)
            }
        });
        const tokenIds = await Promise.all(deviceTokens);
        
        var messagesPayload = {
            notification: {title: `New Message from ${sentFrom}`, body: `${content.substring(0,10)}`, sound: "default"}, data: {click_actions: "FLUTTER_NOTIFICATION_CLICK", message:"Sample FCM Message"}
        }
        try {
            //send to device accepts array of device tokens
            const response = await admin.messaging().sendToDevice(tokenIds, messagesPayload);
            console.log('Notification sent successfully')
        } catch (error) {
            console.log(`error sending notifications: ${error}`)
        }
    
});

//Fires when a Residence puts there flag out and puts there flag in. 
exports.flagOutTrigger = functions.firestore.document('/residences/{name}').onUpdate(async (change, context)=> {
    var newData;
    newData = snapshot.data();
    var residenceName = newData.name;
    var userRef = admin.firestore().collection("users");
    const userSnapshot = await userRef.get();
    var deviceTokens = [];
    userSnapshot.forEach(doc=> {
        if(doc.data().residence != residenceName){
            deviceTokens.push(doc.data().tokens)
        }
    });
    const tokenIds = await Promise.all(deviceTokens);

    const after = change.after.data();
    const before = change.before.data();
    
    if (after.flagOut != before.flagOut && after.flagOut === true){
        var flagOutPayload = {
            notification: {title: "Flag Change", body: `${context.params.name}'s Flag Is Out`, sound: "default"}, data: {click_actions: "FLUTTER_NOTIFICATION_CLICK", message:"Sample FCM Message"}
        }
        try {
            //send to device accepts array of device tokens
            const response = await admin.messaging().sendToDevice(tokenIds, flagOutPayload);
            console.log('Notification sent successfully')
        } catch (error) {
            console.log(`error sending notifications: ${error}`)
        }
    } else if (after.flagOut != before.flagOut && after.flagOut === false){
        var flagInPayload = {
            notification: {title: "Flag Change", body: `${context.params.name}'s Flag Is Now In`, sound: "default"}, data: {click_actions: "FLUTTER_NOTIFICATION_CLICK", message:"Sample FCM Message"}
        }
        try {
            //send to device accepts array of device tokens
            const response = await admin.messaging().sendToDevice(tokenIds, flagInPayload);
            console.log('Notification sent successfully')
        } catch (error) {
            console.log(`error sending notifications: ${error}`)
        }
    }
});



// userSnapshot.forEach((doc)=> {
        //     console.log(doc.data().residence);
        //     if(doc.data().residence == sentTo){
        //     deviceTokens.push(doc.data().tokens)
        //     }
        // });
        // for (let user in userSnapshot){
        //     if(doc.data().residence == sentTo){
        //         deviceTokens.push(doc.data().tokens)
        //     }
        // }