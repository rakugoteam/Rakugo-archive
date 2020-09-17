extends Label

const day_of_week = ["",
"Monday",
"Tuesday",
"Wednesday",
"Thursday",
"Friday",
"Saturday",
"Sunday"]

const months = ["",
"January",
"February",
"March",
"April",
"May",
"June",
"July",
"August",
"September",
"October",
"November",
"December"]

func _on_set_datetime(datetime):
	if datetime == 0:
		text = ''
		return
	datetime = OS.get_datetime_from_unix_time(datetime)
	datetime.month = months[datetime.month]
	datetime.weekday = day_of_week[datetime.weekday]
	datetime.hour = "%02d" % datetime.hour
	datetime.minute = "%02d" % datetime.minute
	text = "{weekday}, {month} {day} {year}, {hour}:{minute}".format(datetime)
