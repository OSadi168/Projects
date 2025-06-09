import numpy as np
from flask import Flask, request, jsonify, render_template
import pickle

from unicodedata import numeric

# Create flask app
flask_app = Flask(__name__)
model = pickle.load(open("model.pkl", "rb"))


@flask_app.route("/")
def home():
    return render_template("index.html")


@flask_app.route("/predict", methods=["POST"])
def predict():
    id =  numeric(request.form.get("Id"))

    v1 = float(request.form.get("V1"))
    v2 = float(request.form.get("V2"))
    v3 = float(request.form.get("V3"))
    v4 = float(request.form.get("V4"))
    v5 = float(request.form.get("V5"))
    v6 = float(request.form.get("V6"))
    v7 = float(request.form.get("V7"))
    v8 = float(request.form.get("V8"))
    v9 = float(request.form.get("V9"))
    v10 = float(request.form.get("V10"))
    v11 = float(request.form.get("V11"))
    v12 = float(request.form.get("V12"))
    v13 = float(request.form.get("V13"))
    v14 = float(request.form.get("V14"))
    v15 = float(request.form.get("V15"))
    v16 = float(request.form.get("V16"))
    v17 = float(request.form.get("V17"))
    v18 = float(request.form.get("V18"))
    v19 = float(request.form.get("V19"))
    v20 = float(request.form.get("V20"))
    v21 = float(request.form.get("V21"))
    v22 = float(request.form.get("V22"))
    v23 = float(request.form.get("V23"))
    v24 = float(request.form.get("V24"))
    v25 = float(request.form.get("V25"))
    v26 = float(request.form.get("V26"))
    v27 = float(request.form.get("V27"))
    v28 = float(request.form.get("V28"))
    amount = float(request.form.get("Amount"))
    print("Variable 1:", v1)
    print("Variable 1:", v2)

    intial_features = [id,v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11,
                    v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24,
                    v25, v26, v27, v28, amount]

    final_features = [np.array(intial_features)]
    prediction = model.predict(final_features)
    print("Predicted:", prediction)
    result = "Real transaction" if prediction == 0 else "Fraud transaction"

    print("Transaction status:", result)
    return render_template("index.html", prediction_text="According to the model, the provided transaction is a  {}".format(result))


if __name__ == "__main__":
    flask_app.run(debug=True)
