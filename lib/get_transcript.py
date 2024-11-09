# get_transcript.py
import sys
from youtube_transcript_api import YouTubeTranscriptApi

def fetch_transcript(video_id):
    try:
        transcript = YouTubeTranscriptApi.get_transcript(video_id, languages=['ja'])
        return " ".join([entry['text'] for entry in transcript])
    except Exception as e:
        return f"Error: {str(e)}"

if __name__ == "__main__":
    video_id = sys.argv[1]
    print(fetch_transcript(video_id))
