from flask import Flask, request
import ollama

# Initialize the Ollama client
app = Flask(__name__)


client = ollama.Client()

# Define the model and the input prompt
model = "llama3.2"  # Replace with your model name

@app.route('/generate', methods =['POST'])
def generate():

# Format the prompt string using Python's string formatting
    prompt = request.json.get('prompt', '')

# Send the query to the model
    response = client.generate(model=model, prompt=prompt)

# Print the response from the model

    return "Response: \n"+response.response

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=3600)