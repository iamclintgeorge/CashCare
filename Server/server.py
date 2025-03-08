# from flask import Flask, request
# import ollama

# # Initialize the Ollama client
# app = Flask(__name__)


# client = ollama.Client()

# # Define the model and the input prompt
# model = "llama3.2"  # Replace with your model name

# @app.route('/generate', methods =['POST'])
# def generate():

# # Format the prompt string using Python's string formatting
#     prompt = request.json.get('prompt', '')

# # Send the query to the model
#     response = client.generate(model=model, prompt=prompt)

# # Print the response from the model

#     return "Response: \n"+response.response

# if __name__ == "__main__":
#     app.run(host='0.0.0.0', port=3600)

from flask import Flask, request
import time

app = Flask(__name__)

@app.route('/generate', methods=['POST'])
def generate():
    prompt = request.json.get('prompt', '')
    # Simulate LLM processing with a 5-second delay and canned response
    time.sleep(5)  # Faster than 1 minute
    fake_response = "This packet may indicate phishing due to a known fraudulent IP (185.107.70.202) and high transaction amount."
    return "Response: \n" + fake_response

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=3600)