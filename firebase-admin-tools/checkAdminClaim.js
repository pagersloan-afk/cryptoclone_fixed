const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.cert(require('./serviceAccountKey.json')),
});

const uid = 'gPNVhYaicsciye6nQ7ItgyxfAbx1'; // Replace with your target UID

admin.auth().getUser(uid)
  .then((userRecord) => {
    const claims = userRecord.customClaims || {};
    console.log(`🔍 Custom claims for UID ${uid}:`, claims);
    console.log(`✅ Is admin: ${claims.admin === true}`);
  })
  .catch((error) => {
    console.error('❌ Error fetching user claims:', error);
  });
