"""
language_utils.py
------------------
Lightweight bilingual (Malayalam <-> English) preprocessing for the
complaint description NLP model.

Honest scope: this is NOT a machine translation engine. The complaint risk
model (complaint_vectorizer.pkl / complaint_model.pkl) was trained on
English text, so Malayalam-script or "Manglish" (Malayalam written in Latin
letters) complaint descriptions would otherwise be nearly meaningless to it.

This module instead does dictionary-based keyword substitution: it detects
Malayalam Unicode script and known Manglish tokens, and maps a curated list
of cybercrime-relevant terms to their English equivalents before the text
reaches the vectorizer. This recovers the model's ability to recognize the
handful of high-signal words (money, OTP, bank, fraud, threat, etc.) that
drive its classification, even when the rest of the sentence stays
untranslated. It is a low-resource NLP technique, not full translation -
nuance and grammar outside the lexicon are not handled.
"""

import re

# Malayalam Unicode block: U+0D00 to U+0D7F
_MALAYALAM_RE = re.compile(r"[\u0D00-\u0D7F]")


def contains_malayalam_script(text: str) -> bool:
    """True if the text contains any Malayalam Unicode characters."""
    return bool(_MALAYALAM_RE.search(text or ""))


# Malayalam-script cybercrime-relevant vocabulary -> English
# (kept intentionally small and high-signal; extend as real complaint
#  data reveals more frequent terms worth mapping)
MALAYALAM_TO_ENGLISH = {
    "പണം": "money",
    "കാശ്": "money",
    "തട്ടിപ്പ്": "fraud",
    "വഞ്ചന": "cheat",
    "ബാങ്ക്": "bank",
    "അക്കൗണ്ട്": "account",
    "പാസ്‌വേഡ്": "password",
    "ഒടിപി": "otp",
    "കാർഡ്": "card",
    "വിളി": "call",
    "സന്ദേശം": "message",
    "ഭീഷണി": "threat",
    "ഭീഷണിപ്പെടുത്തി": "threatened",
    "ബ്ലാക്ക്‌മെയിൽ": "blackmail",
    "ഫോട്ടോ": "photo",
    "വീഡിയോ": "video",
    "കുട്ടി": "child",
    "പെൺകുട്ടി": "girl",
    "ആൺകുട്ടി": "boy",
    "പോലീസ്": "police",
    "പരാതി": "complaint",
    "ലിങ്ക്": "link",
    "വെബ്സൈറ്റ്": "website",
    "ജോലി": "job",
    "ലോൺ": "loan",
    "വായ്പ": "loan",
    "സഹായം": "help",
    "പിടിച്ചുപറി": "extortion",
    "ഹാക്ക്": "hack",
    "വ്യാജ": "fake",
}

# Common "Manglish" (Malayalam written phonetically in Latin script) tokens.
# These overlap heavily with everyday chat spelling and are inherently
# ambiguous with English words, so this list is deliberately conservative -
# only cybercrime-specific tokens unlikely to appear as genuine English words.
MANGLISH_TO_ENGLISH = {
    "kaashu": "money",
    "panam": "money",
    "thattipp": "fraud",
    "thattippu": "fraud",
    "vanchana": "cheat",
    "otp chodichu": "asked for otp",
    "bheeshani": "threat",
    "bheeshanippeduthi": "threatened",
    "vilichu": "called",
    "sandesham": "message",
    "pattiyo": "cheated me",
    "karuthi": "believed",
    "vishwasich": "trusted",
    "vanchichu": "deceived",
}


def normalize_for_model(description: str) -> str:
    """
    Prepares a (possibly Malayalam or Manglish) complaint description for
    the English-trained NLP risk model by substituting known cybercrime
    vocabulary with English equivalents. Returns the text unchanged if no
    Malayalam/Manglish terms are recognized.
    """
    if not description:
        return description

    text = description

    if contains_malayalam_script(text):
        for mal_term, eng_term in MALAYALAM_TO_ENGLISH.items():
            if mal_term in text:
                text = text.replace(mal_term, f" {eng_term} ")

    lowered = text.lower()
    for manglish_term in sorted(MANGLISH_TO_ENGLISH.keys(), key=len, reverse=True):
        if manglish_term in lowered:
            eng_term = MANGLISH_TO_ENGLISH[manglish_term]
            # Case-insensitive whole-token replace, preserving the rest of the text
            pattern = re.compile(re.escape(manglish_term), re.IGNORECASE)
            text = pattern.sub(f" {eng_term} ", text)
            lowered = text.lower()

    # Collapse extra whitespace introduced by substitutions
    text = re.sub(r"\s+", " ", text).strip()
    return text


def detect_language_label(description: str) -> str:
    """Best-effort label for what the citizen appears to have typed in."""
    if not description:
        return "UNKNOWN"
    if contains_malayalam_script(description):
        return "MALAYALAM"
    lowered = description.lower()
    if any(term in lowered for term in MANGLISH_TO_ENGLISH):
        return "MANGLISH"
    return "ENGLISH"
