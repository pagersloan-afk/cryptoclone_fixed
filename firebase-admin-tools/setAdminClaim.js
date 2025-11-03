const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.cert(require('./serviceAccountKey.json')),
});

const uid = 'gPNVhYaicsciye6nQ7ItgyxfAbx1';

admin.auth().setCustomUserClaims(uid, { admin: true })
  .then(() => {
    console.log(`✅ Admin claim set for UID: ${uid}`);
  })
  .catch((error) => {
    console.error('❌ Error setting admin claim:', error);
  });
