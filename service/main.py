import datetime, subprocess, os, threading, json, time
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
from flask import Flask, jsonify, request, abort
from google.oauth2 import service_account

# If modifying these scopes, delete the file token.json.
app = Flask(__name__)
SCOPES = ['https://www.googleapis.com/auth/calendar']
service = None

event_cache = {"mob" : {
							"empire" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"electra" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"lesabre" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"centurion" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"wildcat" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"riviera" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"apollo" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"],
							"skyhawk" : ["k3qvt79nvuaarrah6p8g1ra2g8@group.calendar.google.com"]
					   }, 
			   "aug" : {
							"pascal" : [None]
					   }, 
			   "atl" : {}, 
			   "jbr" : {}, 
			   "abq" : {}, 
			   "okc" : {}}

def main():
	global service
	
	creds = service_account.Credentials.from_service_account_file("token.json", scopes=SCOPES)
	service = build('calendar', 'v3', credentials=creds)
			
def get_events():
	print("Refreshing events...")
	for city in event_cache.keys():
		for room in event_cache[city].keys():
			if event_cache[city][room][0] is not None:
				events = get_event(event_cache[city][room][0])
				for event in events:
					processed_event = {}
					processed_event["start"] = event["start"]["dateTime"]
					processed_event["end"] = event["end"]["dateTime"]
					processed_event["name"] = event["summary"]
					if processed_event not in event_cache[city][room]:
						event_cache[city][room].append(processed_event)
			print("Events cached for " + city + '/' + room + ": " + str(len(event_cache[city][room]) - 1))
	print("Events refreshed!")
				
def clear_old_events():
	now = datetime.datetime.now().isoformat() + '-0500' # 'Z' indicates UTC time
	
	for city in event_cache.keys():
		for room in event_cache[city].keys():
			to_remove = []
			for event in event_cache[city][room][1:]:
				if (event["start"] < now):
					to_remove.append(event)
			for rem in to_remove:
				event_cache[city][room].remove(rem)
			
def get_event(id):
	global service
	
	now = datetime.datetime.now().isoformat() + '-0500' # 'Z' indicates UTC time

	events_result = service.events().list(calendarId=id, timeMin=now, maxResults=10, singleEvents=True, orderBy='startTime').execute()
	events = events_result.get('items', [])
	
	return events
	
def add_event(id, name, description, start, end, guests):
	global service
	
	event = {}
	event["summary"] = name
	event["description"] = description
	event["end"] = end
	event["start"] = start
	
	service.events().insert(calendarId=id, body=event).execute()
	
@app.route("/devjam/echo", methods=["GET"])
def echo():
	return "Yeah yeah, I'm here."
	
@app.route("/devjam/list", methods=["GET"])
def list():
	city = request.args.get("city")
	room = request.args.get("room")
	
	if city in event_cache.keys():
		if room in event_cache[city].keys():
			#print(event_cache[city][room])
			events = event_cache[city][room]
			if len(events)> 1:
				return json.dumps(events[1])
			else:
				return ""
	
@app.route("/devjam/add", methods=["POST"])
def add():
	city = request.form.get("city")
	room = request.form.get("room")
	name = request.form.get("name")
	description = request.form.get("description")
	start = request.form.get("startDateTime")
	end = request.form.get("endDateTime")
	guests = request.form.get("guests")
	
	start = {"dateTime" : start}
	end = {"dateTime" : end}
	
	print(city)
	print(room)
	print(name)
	print(description)
	print(start)
	print(end)
	print(guests)
	
	if city in event_cache.keys():
		if room in event_cache[city].keys():
			print(event_cache[city][room])
			id = event_cache[city][room][0]
	
	add_event(id, name, description, start, end, guests)
	
	return "", 201
		
def thread():
	while True:
		clear_old_events()
		get_events()
		time.sleep(10)
		
if __name__ == '__main__':
	main()
	threading.Thread(target=thread).start()
	app.run(host="0.0.0.0")
	#app.run(host="45.33.102.224")