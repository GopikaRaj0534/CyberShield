from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB


# Training data (sample dataset)

messages = [

    "Your bank account is blocked verify your password immediately",

    "Congratulations you won free money click here",

    "Claim your lottery prize now",

    "Urgent update your account information",

    "Meeting scheduled tomorrow at 10 AM",

    "Project discussion with team members",

    "Your order has been delivered",

    "Happy birthday have a nice day"

]


labels = [

    "spam",
    "spam",
    "spam",
    "spam",

    "safe",
    "safe",
    "safe",
    "safe"

]



# Convert text into numbers

vectorizer = TfidfVectorizer()


X = vectorizer.fit_transform(messages)



# Train ML model

model = MultinomialNB()


model.fit(X, labels)




def classify_message(text):


    data = vectorizer.transform([text])


    result = model.predict(data)


    return result[0]





# Testing

if __name__ == "__main__":


    email = input("Enter message: ")


    prediction = classify_message(email)


    print("Result:", prediction)