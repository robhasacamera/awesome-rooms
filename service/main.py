import datetime
from googleapiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools

# If modifying these scopes, delete the file token.json.
SCOPES = 'https://www.googleapis.com/auth/calendar.readonly'

def main():
	service = build('calendar', 'v3', developerKey='AIzaSyALZv-d7A8qZ05dDsbdPv8O6wYlIkmKHJI')

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