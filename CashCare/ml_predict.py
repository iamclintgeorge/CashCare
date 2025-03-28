# ml_predict.py
import pandas as pd
import joblib
import json

model_path = '/home/clint/Desktop/credit_card_model/app/'
label_encoders = joblib.load(model_path + 'label_encoders.pkl')
imputer = joblib.load(model_path + 'imputer.pkl')
scaler = joblib.load(model_path + 'scaler.pkl')
model = joblib.load(model_path + 'fraud_detection_model.pkl')

categorical_cols = ['merchant', 'category', 'gender', 'job', 'city', 'state']
numerical_cols = ['amt', 'lat', 'long', 'city_pop', 'unix_time', 'merch_lat', 'merch_long', 'age', 'distance']

def classify_packet(packet_json):
    try:
        txn = json.loads(packet_json)
        df = pd.DataFrame([txn])

        for col in categorical_cols:
            df[col] = df[col].fillna('Unknown')
            if col in label_encoders:
                df[col] = df[col].apply(lambda x: x if x in label_encoders[col].classes_ else 'Unknown')
                if 'Unknown' not in label_encoders[col].classes_:
                    df[col] = df[col].replace('Unknown', label_encoders[col].classes_[0])
                df[col] = label_encoders[col].transform(df[col])
         # Handle missing values for numerical features using the trained imputer
        df[numerical_cols] = imputer.transform(df[numerical_cols])
         # Normalize numerical features using the trained scaler
        df[numerical_cols] = scaler.transform(df[numerical_cols])

        y_pred_proba = model.predict_proba(df)[:, 1]
        prediction = 1 if y_pred_proba[0] >= 0.2 else 0
        return prediction, y_pred_proba[0]
    except Exception as e:
        print(f"Error classifying packet: {e}")
        return None, None

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        pred, prob = classify_packet(sys.argv[1])
        print(f"{pred},{prob}")
