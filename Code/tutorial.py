from transformers import pipeline

transcriber = pipeline(model="openai/whisper-large-v2", device_map="auto")

print(transcriber("./test.flac"))
