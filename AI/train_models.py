import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB

# 1. Phishing URL Classification
# Classifies URLs as phishing vs safe
url_corpus = [
    "http://secure-login-paypal.com",
    "https://bank-verify-auth.net",
    "http://free-giftcard-lottery.org",
    "http://amazon-update-billing.click",
    "https://netflix-account-renew.support",
    "http://claim-your-prize-now.com",
    "http://verify-bank-security-login.xyz",
    "http://instagram-hack-account.info",
    "https://google.com",
    "https://github.com",
    "https://wikipedia.org",
    "https://oracle.com",
    "https://apache.org",
    "https://microsoft.com",
    "https://stackoverflow.com",
    "https://youtube.com"
]
url_labels = [
    "phishing", "phishing", "phishing", "phishing", "phishing", "phishing", "phishing", "phishing",
    "safe", "safe", "safe", "safe", "safe", "safe", "safe", "safe"
]

url_vectorizer = TfidfVectorizer()
X_url = url_vectorizer.fit_transform(url_corpus)
url_model = MultinomialNB()
url_model.fit(X_url, url_labels)

# 2. Spam Email Classification
# Classifies messages as spam vs safe
email_corpus = [
    "Your bank account is blocked verify your password immediately",
    "Congratulations you won free money click here to claim your cash",
    "Claim your lottery prize now and double your income easily",
    "Urgent update your online billing credentials",
    "Get rich quick with zero effort check out this deal",
    "Dear customer update your profile info to avoid suspension",
    "Meeting scheduled tomorrow at 10 AM in the conference room",
    "Project discussion with team members regarding the new launch",
    "Your order has been delivered successfully. Thank you for shopping",
    "Happy birthday have a nice day ahead",
    "Can you please review this code and merge the pull request?",
    "Please find attached the quarterly financial report for review"
]
email_labels = [
    "spam", "spam", "spam", "spam", "spam", "spam",
    "safe", "safe", "safe", "safe", "safe", "safe"
]

email_vectorizer = TfidfVectorizer()
X_email = email_vectorizer.fit_transform(email_corpus)
email_model = MultinomialNB()
email_model.fit(X_email, email_labels)

# 3. NLP Crime Description Risk Level Classifier
# Classifies descriptions into LOW, MEDIUM, or HIGH risk categories
desc_corpus = [
    "Enterprise database was hacked and database files encrypted with ransomware demanding bitcoin payment.",
    "Critical server compromised by attackers, corporate intellectual property and data exfiltrated.",
    "Ransom extortion email received threatening to leak sensitive executive emails unless paid.",
    "Denial of service attack has completely shut down our payment gateway server.",
    "Unauthorized intrusion detected on core systems, administrative account credentials stolen.",
    "My social media account was hacked and some stranger is sending fake messages to my friends.",
    "Someone created a fake profile of me on Facebook and is cyber bullying my classmates.",
    "I was scammed online while shopping, paid for a phone but received a fake box.",
    "Unauthorized UPI transaction of 5000 Rs took place from my savings bank account without OTP.",
    "A credit card fraud incident where card details were stolen and used for unauthorized shopping.",
    "I received a suspicious spam email about credit card score check, looks like spam.",
    "Minor dispute regarding wrong email address entry in profile.",
    "Just getting general guidance on cyber safety tips and how to stay safe.",
    "Receive too many advertising spam comments on my personal blog.",
    "Minor UI issues reported on a social platform."
]
desc_labels = [
    "HIGH", "HIGH", "HIGH", "HIGH", "HIGH",
    "MEDIUM", "MEDIUM", "MEDIUM", "MEDIUM", "MEDIUM",
    "LOW", "LOW", "LOW", "LOW", "LOW"
]

desc_vectorizer = TfidfVectorizer()
X_desc = desc_vectorizer.fit_transform(desc_corpus)
desc_model = MultinomialNB()
desc_model.fit(X_desc, desc_labels)

# Save the models and vectorizers to files
with open("AI/phishing_vectorizer.pkl", "wb") as f:
    pickle.dump(url_vectorizer, f)
with open("AI/phishing_model.pkl", "wb") as f:
    pickle.dump(url_model, f)

with open("AI/spam_vectorizer.pkl", "wb") as f:
    pickle.dump(email_vectorizer, f)
with open("AI/spam_model.pkl", "wb") as f:
    pickle.dump(email_model, f)

with open("AI/complaint_vectorizer.pkl", "wb") as f:
    pickle.dump(desc_vectorizer, f)
with open("AI/complaint_model.pkl", "wb") as f:
    pickle.dump(desc_model, f)

print("AI Models trained and serialized successfully!")
