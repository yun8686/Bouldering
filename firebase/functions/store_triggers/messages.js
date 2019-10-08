const functions = require('firebase-functions');
const admin = require('firebase-admin');
const firestore = functions.firestore;
module.exports = firestore
.document('/chats/{chatid}/logs/{logid}')
.onCreate(async (snapshot, context)=>{
  const data = snapshot.data();
  const chatid = context.params.chatid;
  const creator = data.creator;
  const chatData = await admin.firestore().collection('chats').doc(chatid).get();
  const users = chatData.data().users;
  users.forEach(uid=>{
    if(creator == uid) return;
    admin.firestore().collection('users').doc(uid).get()
    .then(user=>{
      pushToDevice(user.data().notifyId,{
        notification: {
          title: "title",
          body: "body" + "さん：" + "body",
          badge: "1",
          sound:"default",
        }
      });
    });
  });
});


// 特定のfcmTokenに対してプッシュ通知を打つ
function pushToDevice(token, payload){
  // priorityをhighにしとくと通知打つのが早くなる
  const options = {
    priority: "high",
  };
  admin.messaging().sendToDevice(token, payload, options)
  .then(pushResponse => {
    console.log("Successfully sent message:", pushResponse);
  })
  .catch(error => {
    console.log("Error sending message:", error);
  });
}
