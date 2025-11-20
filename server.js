require('dotenv').config();

const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');
const submitRoute = require('./backend/routes/submit');
const ibmRoute = require('./backend/routes/ibm');
const admin = require('firebase-admin');

const serviceAccount = require('./igeg-vault-firebase-adminsdk-fbsvc-d6d458cd69.json');

const app = express();

// 🔹 Enable CORS (allow all localhost ports in dev, restrict in prod)
app.use(cors({
  origin: (origin, callback) => {
    if (!origin) return callback(null, true); // allow curl/Postman
    if (
      origin.startsWith('http://localhost') ||
      origin.startsWith('http://127.0.0.1') ||
      origin === 'https://www.igegvault.com'
    ) {
      return callback(null, true);
    }
    return callback(new Error('Not allowed by CORS'));
  },
  methods: ['POST', 'GET'],
  allowedHeaders: ['Content-Type'],
}));

// 🔹 Initialize Firebase Admin
try {
  if (!admin.apps.length) {
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log('✅ Firebase Admin initialized');
  }
} catch (err) {
  console.error('❌ Firebase Admin init error:', err);
}

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// 🔹 Serve Flutter app under /app (inside landing/app)
app.use('/app', express.static(path.join(__dirname, 'landing', 'app')));

// 🔹 Catch-all for Flutter app routes
app.get(/^\/app(\/.*)?$/, (req, res) => {
  res.sendFile(path.join(__dirname, 'landing', 'app', 'index.html'));
});

// 🔹 Serve landing site at root
app.use('/', express.static(path.join(__dirname, 'landing')));

// Explicit static routes
[
  'fix-and-flip',
  'dscr-rental',
  'new-construction',
  'recent-deals',
  'home-loans',
  'personal-loans',
  'mutual-funds',
  'auto-loans',
  'about',
  'investing',
  'commercial',
  'apply',
  'contact'
].forEach(page => {
  app.get(`/${page}`, (req, res) => {
    res.sendFile(path.resolve(__dirname, 'landing', `${page}.html`));
  });
});

// Routes
app.use('/', submitRoute);
app.use('/', ibmRoute);

// 🔹 IBM Kubernetes Key Validation Route
app.post('/validate-ibm-key', async (req, res) => {
  try {
    const { productKey } = req.body;
    console.log('🔍 Received IBM key:', productKey);
    const isValid = productKey === '2281-HTCW-6FXW-H2HR';
    res.json({ valid: isValid });
  } catch (err) {
    console.error('❌ IBM key validation error:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

// Health check
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

// 🔹 Catch-all route: serve file if exists, else fallback to landing index.html
app.get(/.*/, (req, res) => {
  const requestedPath = req.path.replace(/^\/+/, '');
  const filePath = path.join(__dirname, 'landing', `${requestedPath}.html`);

  if (
    requestedPath.startsWith('app/') ||
    requestedPath.startsWith('assets/') ||
    requestedPath.endsWith('.js') ||
    requestedPath.endsWith('.png') ||
    requestedPath.endsWith('.json')
  ) {
    return res.status(404).send('File not found');
  }

  if (fs.existsSync(filePath)) {
    res.sendFile(filePath);
  } else {
    console.log(`🔁 Fallback triggered for: ${req.path}`);
    res.sendFile(path.join(__dirname, 'landing', 'index.html'));
  }
});

// ✅ Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});
