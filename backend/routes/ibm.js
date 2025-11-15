// backend/routes/ibm.js
const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');

// 🔹 IBM Product Key Validation Route
router.post('/validate-ibm-key', async (req, res) => {
  const { productKey } = req.body;

  try {
    const doc = await admin.firestore()
      .collection('SystemConfig')
      .doc('ibmKeys')
      .get();

    if (!doc.exists) {
      return res.json({ valid: false });
    }

    const validKeys = doc.data().keys || [];
    const normalizedKey = productKey?.trim();
    const isValid = validKeys.includes(normalizedKey);

    console.log(`IBM Key Check: ${productKey} → ${isValid ? 'VALID' : 'INVALID'}`);

    res.json({ valid: isValid });
  } catch (err) {
    console.error('IBM Key Validation Error:', err);
    res.status(500).json({ valid: false, error: 'Server error' });
  }
});

module.exports = router;
