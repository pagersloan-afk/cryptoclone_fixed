const admin = require('firebase-admin');
const express = require('express');
const router = express.Router();

router.post('/confirm-bank-setup', async (req, res) => {
  const { userId, accountId } = req.body;

  if (!userId || !accountId) {
    console.warn('⚠️ Missing userId or accountId in request body');
    return res.status(400).json({ error: 'Missing userId or accountId' });
  }

  console.log(`🔍 Attempting to update Firestore for userId: ${userId}, accountId: ${accountId}`);

  try {
    const userRef = admin.firestore().collection('users').doc(userId);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      console.error(`❌ No user found with ID: ${userId}`);
      return res.status(404).json({ error: 'User not found in Firestore' });
    }

    await userRef.update({
      bankSetupComplete: true,
      payoutAccountId: accountId,
      payoutVerifiedAt: new Date().toISOString(),
    });

    console.log(`✅ Firestore updated for user: ${userId}`);
    return res.status(200).json({ success: true, message: 'Bank setup marked complete.' });
  } catch (error) {
    console.error('🔥 Firestore update error:', error.message);
    return res.status(500).json({ error: 'Failed to update user bank setup.' });
  }
});

module.exports = router;
