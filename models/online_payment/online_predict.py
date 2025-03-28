import joblib

# Load model and encoder
model = joblib.load('online_fraud_detect_model.pkl')
encoder = joblib.load('ordinal_encoder.pkl')

# Load PCAP and preprocess (use the preprocessing code above first)
# Use the 'features' array from preprocessing

# Make predictions
predictions = model.predict(features)

# Print results
for i, pred in enumerate(predictions):
    print(f"Transaction {i+1}: {'Fraud' if pred == 1 else 'Non-Fraud'}")
