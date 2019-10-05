const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

// このファンクションは試しに作っただけなので削除してもOK
exports.addMessage = functions.https.onCall((data, context) => {
    const original = data.text;
    console.log('original:', original);

    admin.database().ref('/messages').push({ original: original}).then((snapshot) => {
        console.log('messages/original:', snapshot.ref.toString());
    })

    return { result: original };
});