const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.cert(require('./serviceAccountKey.json')),
});

const uid = 'DV5FPQ6bfwgUXyPep1b15xbxAYI3'; // your actual UID

admin.auth().setCustomUserClaims(uid, { admin: true })
  .then(() => {
    console.log(`✅ Admin claim set for UID: ${uid}`);
  })
  .catch((error) => {
    console.error('❌ Error setting admin claim:', error);
  });
