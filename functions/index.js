const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
exports.sendPushForHelp = functions.database.ref('/help/{id}').onWrite(event => {
       const payLoad = {
         notification: {
             title: 'Someone',
             body: 'needs help',
             badge: '0',
             sound: 'default'
         }
       };
       return admin.database().ref('fcmToken').once('value').then(allToken => {
           if (allToken.val()) {
            const token = Object.keys(allToken.val());
            return admin.messaging().sendToDevice(token, payLoad).then(response => {

            });
        };
    });
});

exports.sendPushForThreat = functions.database.ref('/threat/{id}').onWrite(event => {
        const payLoad = {
            notification: {
                title: 'New',
                body: 'Threat',
                badge: '0',
                sound: 'default'
            }
        };
return admin.database().ref('fcmToken').once('value').then(allToken => {
        if (allToken.val()) {
    const token = Object.keys(allToken.val());
    return admin.messaging().sendToDevice(token, payLoad).then(response => {

            });
        };
    });
});
exports.sendPushForAccident = functions.database.ref('/accident/{id}').onWrite(event => {
        const payLoad = {
            notification: {
                title: 'New',
                body: 'Accident',
                badge: '0',
                sound: 'default'
            }
        };
return admin.database().ref('fcmToken').once('value').then(allToken => {
        if (allToken.val()) {
    const token = Object.keys(allToken.val());
    return admin.messaging().sendToDevice(token, payLoad).then(response => {

            });
        };
    });
});