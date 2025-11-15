// server.js
const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const submitRoute = require('./backend/routes/submit');
const ibmRoute = require('./backend/routes/ibm');
const admin = require('firebase-admin');

const app = express();

// 🔹 Initialize Firebase Admin (using environment variables from Vercel)
if (!admin.apps.length) {
  try {
    admin.initializeApp({
      credential: admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n'),
      }),
    });
    console.log('✅ Firebase Admin initialized');
  } catch (err) {
    console.error('❌ Firebase Admin init error:', err);
  }
}

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Serve static assets from landing/
app.use(express.static('landing'));

// ✅ Match Firebase rewrites
app.get('/fix-and-flip', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'fix-and-flip.html'));
});
app.get('/dscr-rental', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'dscr-rental.html'));
});
app.get('/new-construction', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'new-construction.html'));
});
app.get('/recent-deals', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'recent-deals.html'));
});
app.get('/home-loans', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'home-loans.html'));
});
app.get('/personal-loans', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'personal-loans.html'));
});
app.get('/about', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'about.html'));
});
app.get('/investing', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'investing.html'));
});
app.get('/apply', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'apply.html'));
});
app.get('/contact', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'landing', 'contact.html'));
});

// ✅ Routes
app.use('/', submitRoute);
app.use('/', ibmRoute);

// 🔎 Health check route for Firebase
app.get('/ping-firebase', async (req, res) => {
  try {
    const db = admin.firestore();
    await db.collection('SystemConfig').limit(1).get();
    res.json({ ok: true, message: 'Firebase connected!' });
  } catch (err) {
    console.error('Firebase connection error:', err);
    res.status(500).json({ ok: false, error: err.message });
  }
});

// ✅ Export for Vercel
module.exports = app;

// ✅ Local dev only
if (process.env.NODE_ENV !== 'production') {
  app.listen(3000, () => {
    console.log('✅ Server running on http://localhost:3000');
  });
}
