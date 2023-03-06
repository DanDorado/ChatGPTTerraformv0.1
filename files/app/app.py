from flask import Flask, render_template, request
from time import time
import openai
import json
import os

app = Flask(__name__)

#This lets us read the API Key.
def open_file(filepath):
    with open(filepath, 'r') as infile:
        return infile.read()
    
#This SHOULD let us save text files. 
def save_file(filepath, content):
    with open(filepath, 'w') as outfile:
       outfile.write(content)
    
#This reads the memory from the file
def read_file(filepath):
    with open(filepath, 'r') as file:
            memory = file.readlines()
            return memory

#Uses function above to open and read this file's contents as the API Key
openai.api_key = open_file('openaiapikey.txt')


memory_file_path = "base.jsonl"
memory = read_file(memory_file_path)

#Landing Page in Templates Folder, opens home.html
@app.route("/")
def home():
    return render_template("home.html")

#Takes us to the response page tried to consolidate onto 1 page but it didn't like it.
@app.route("/generate", methods=["POST"])
def generate():
    prompt = request.form["prompt"] #this appears to be what is fed into the form in the home.html and generate.html pages.
    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo-0301",
        messages=[
        {"role": "user", "content": open_file(memory_file_path) + prompt}, #This makes sure the AI responds to the Prompt

        ]
    )

    #Stores new info in memory
    with open(memory_file_path, 'a') as file:
         file.write(str({"prompt": prompt, "content": response.choices[0].message.content}))
            
    #This renders the CONTENT which is the response.
    return render_template("generate.html", response=response.choices[0].message.content.replace('\n', '<br>'))

#This is a cool debugger
if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')