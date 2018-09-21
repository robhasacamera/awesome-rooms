import datetime, subprocess, os, threading, json
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
from flask import Flask, jsonify

# If modifying these scopes, delete the file token.json.
app = Flask(__name__)
SCOPES = 'https://www.googleapis.com/auth/calendar'
service = None

event_cache = {"mob" : {
							"empire" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"electra" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"lesabre" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"centurion" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"wildcat" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"riviera" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"apollo" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"]
					   }, 
			   "aug" : {}, 
			   "atl" : {}, 
			   "jbr" : {}, 
			   "abq" : {}, 
			   "okc" : {}}

def main():
	# Get the list of events and cache those hoes
	global service
	
	service = build('calendar', 'v3', developerKey='AIzaSyALZv-d7A8qZ05dDsbdPv8O6wYlIkmKHJI')
	
	for city in event_cache.keys():
		for room in event_cache[city].keys():
			events = get_event(event_cache[city][room][0])
			for event in events:
				event_cache[city][room].append(event)
				
	print(event_cache)
				
def get_event(id):
	global service
	
	now = datetime.datetime.utcnow().isoformat() + 'Z' # 'Z' indicates UTC time

	events_result = service.events().list(calendarId=id, timeMin=now, maxResults=1, singleEvents=True, orderBy='startTime').execute()
	events = events_result.get('items', [])
	
	return events
	
def main3():

	# Call the Calendar API
	now = datetime.datetime.utcnow().isoformat() + 'Z' # 'Z' indicates UTC time
	print('Getting the upcoming 10 events')
	events_result = service.events().list(calendarId='k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com',
										  timeMin=now, maxResults=1, singleEvents=True, orderBy='startTime').execute()
	events = events_result.get('items', [])

	if not events:
		print('No upcoming events found.')
	for event in events:
		start = event['start'].get('dateTime', event['start'].get('date'))
		print(start, event['summary'])
		
if __name__ == '__main__':
	main()
	app.run(host="0.0.0.0")