import re


def detect_phishing(url):

    suspicious_words = [
        "login",
        "verify",
        "bank",
        "secure",
        "update",
        "password",
        "free"
    ]


    url = url.lower()


    for word in suspicious_words:

        if word in url:

            return "HIGH"


    if not url.startswith("https"):

        return "MEDIUM"


    return "LOW"



if __name__ == "__main__":

    url=input("Enter URL: ")

    print(
        detect_phishing(url)
    )