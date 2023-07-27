import os
import time
from moviepy.editor import *
from flask import Flask, render_template, request, send_file
import pyttsx3
from flask_cors import CORS
app = Flask(__name__)
CORS(app)



@app.route('/')
def index():
    return render_template('index.html')

@app.route('/generate_audio', methods=['POST'])
def generate_audio():
    data=request.get_json()
    print(data)
    input_text = data.get('input_text')
    voice = data.get('voice')
    character=data.get("character")
    language = data.get('language')
    print(voice)
    if language=='English':
        set_language_and_gender('en',voice)
    elif language=="Hindi":
        set_language_and_gender('hi',voice)
    elif language=='Russian':
        set_language_and_gender('ru',voice)
    else:
        set_language_and_gender('fr',voice)

    engine = pyttsx3.init()

    output_audio = 'static/output.mp3'
    engine.save_to_file(input_text, "static/output.mp3")
    engine.runAndWait()

    # Adjust video duration and attach audio
    video_path = 'static/input_video.mp4'
    if character=='Male':
        video_path = 'static/input_video_male.mp4'
    elif character=='Nigerian Male':
        video_path = 'static/nigerianMan.mp4'
    elif character=='Nigerian Female':
        video_path = 'static/nigerianWoman.mp4'
    audio_duration = get_audio_duration(output_audio)
    output_video = adjust_video_duration(video_path, audio_duration, output_audio)
    
    return send_file(output_video,mimetype='video/mp4')
def set_language_and_gender(language='en', gender='female'):
    engine = pyttsx3.init()
    voices = engine.getProperty('voices')
    for voice in voices:    
        if language in voice.languages and gender.lower() in voice.name.lower():
            engine.setProperty('voice', voice.id)
            break

def get_audio_duration(audio_path):
    audio = AudioFileClip(audio_path)
    return audio.duration

def adjust_video_duration(video_path, target_duration, audio_path):
    video = VideoFileClip(video_path)
    audio = AudioFileClip(audio_path)

    # Mute existing audio track in the video
    video = video.set_audio(None)

    # Adjust video duration
    current_duration = video.duration
    if current_duration > target_duration:
        video = video.subclip(0, target_duration)
    else:
        video = video.fx(VideoFileClip.set_duration, target_duration)

    # Make sure audio duration matches the video duration
    audio = audio.subclip(0, video.duration)

    # Set the new audio track for the video
    video = video.set_audio(audio)
    # Save the final video
    output_path = 'static/output_video.mp4'
    video.write_videofile(output_path, codec='libx264', audio_codec='aac')

    return output_path

@app.route('/download/<filename>')
def download(filename):
    return send_file(os.getcwd()+'/static/'+filename, mimetype='video/mp4')

@app.route('/get/<filename>')
def get(filename):
    return send_file(os.getcwd()+'/static/'+filename, as_attachment=True,mimetype='audio/raw')


@app.route('/used_audio', methods=['POST'])
def used_audio():
    try:
        
        character=request.form['character']
        file=request.files['audio']
        output_audio = 'static/output.mp3'
        file_path=os.path.join('static','output.mp3')
        file.save(file_path)
        # Adjust video duration and attach audio
        video_path = 'static/input_video.mp4'
        if character=='Male':
            video_path = 'static/input_video_male.mp4'
        if character=='Nigerian Male':
            video_path = 'static/nigerianMan.mp4'
        if character=='Nigerian Female':
            video_path = 'static/nigerianWoman.mp4'
        audio_duration = get_audio_duration(output_audio)
        output_video = adjust_video_duration(video_path, audio_duration, output_audio)

        return send_file(output_video,mimetype='video/mp4')
    except Exception as e:
        print(e)
        return "NO"
def get_audio_duration(audio_path):
    audio = AudioFileClip(audio_path)
    return audio.duration

def adjust_video_duration(video_path, target_duration, audio_path):
    video = VideoFileClip(video_path)
    audio = AudioFileClip(audio_path)

    # Mute existing audio track in the video
    video = video.set_audio(None)

    # Adjust video duration
    current_duration = video.duration
    if current_duration > target_duration:
        video = video.subclip(0, target_duration)
    else:
        video = video.fx(VideoFileClip.set_duration, target_duration)

    # Make sure audio duration matches the video duration
    audio = audio.subclip(0, video.duration)

    # Set the new audio track for the video
    video = video.set_audio(audio)
    # Save the final video
    output_path = 'static/output_video.mp4'
    video.write_videofile(output_path, codec='libx264', audio_codec='aac')

    return output_path


if __name__ == '__main__':
    app.run(debug=True)
