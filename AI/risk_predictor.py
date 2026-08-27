import sys
import os
import pickle

from language_utils import normalize_for_model, detect_language_label

# Determine the absolute directory where this script is located
script_dir = os.path.dirname(os.path.abspath(__file__))

def load_pickle(filename):
    filepath = os.path.join(script_dir, filename)
    with open(filepath, "rb") as f:
        return pickle.load(f)

# Load Scikit-learn models and vectorizers
try:
    url_vect = load_pickle("phishing_vectorizer.pkl")
    url_model = load_pickle("phishing_model.pkl")
    
    email_vect = load_pickle("spam_vectorizer.pkl")
    email_model = load_pickle("spam_model.pkl")
    
    desc_vect = load_pickle("complaint_vectorizer.pkl")
    desc_model = load_pickle("complaint_model.pkl")
except Exception as e:
    print("RISK: LOW")
    print(f"EXPLANATION: Failed to load trained AI models. Error: {str(e)}")
    sys.exit(0)

def predict_risk(url, email, description):
    explanations = []
    
    # 1. URL Phishing Detection
    is_phishing = False
    url_text = str(url).strip()
    if url_text and url_text != "null":
        X = url_vect.transform([url_text])
        pred = url_model.predict(X)[0]
        if pred == "phishing":
            is_phishing = True
            explanations.append("AI flagged suspect URL as a phishing threat")
        
        # Check HTTP vs HTTPS
        if not url_text.lower().startswith("https"):
            explanations.append("URL uses insecure HTTP protocol")
            
    # 2. Email Spam Classification
    is_spam = False
    email_text = str(email).strip()
    if email_text and email_text != "null":
        X = email_vect.transform([email_text])
        pred = email_model.predict(X)[0]
        if pred == "spam":
            is_spam = True
            explanations.append("AI flagged sender email as matching spam templates")

    # 3. NLP Crime Description Analysis
    desc_risk = "LOW"
    desc_text = str(description).strip()
    if desc_text and desc_text != "null":
        language_label = detect_language_label(desc_text)
        normalized_desc = normalize_for_model(desc_text)
        if language_label in ("MALAYALAM", "MANGLISH"):
            explanations.append(f"Detected {language_label.title()} text and mapped known cybercrime terms to English before analysis")

        X = desc_vect.transform([normalized_desc])
        desc_risk = desc_model.predict(X)[0]
        explanations.append(f"NLP analyzed crime description and categorized it as {desc_risk} risk")
    else:
        explanations.append("No description provided, defaulting description risk to LOW")

    # 4. Aggregated Decision Engine
    final_risk = desc_risk
    if is_phishing and is_spam:
        final_risk = "HIGH"
    elif is_phishing or is_spam:
        if final_risk == "LOW":
            final_risk = "MEDIUM"

    explanation_str = "; ".join(explanations) + "."
    return final_risk, explanation_str

if __name__ == "__main__":
    # Safe argument parsing
    url = sys.argv[1] if len(sys.argv) > 1 else ""
    email = sys.argv[2] if len(sys.argv) > 2 else ""
    description = sys.argv[3] if len(sys.argv) > 3 else ""

    risk, explanation = predict_risk(url, email, description)
    print(f"RISK: {risk}")
    print(f"EXPLANATION: {explanation}")