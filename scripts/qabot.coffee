# Description:
#   qabot helps you share info with qa team
#
# Commands: 
#   record regression/staging start/end date
#   get regression/staging start/end date
#   show calendar
#
# Author:
#   GabrielSonger

module.exports = (robot) ->

  # Create an empty calendar
  init_calendar = () ->
    console.log "Creating a new calendar"
    robot.brain.set("calendar",{})

  # Assign date to calendar
  update_calendar = (stage, mode) ->
    date = new Date()
    local_date = date.toLocaleString()

    calendar = robot.brain.get("calendar")
    date_key = stage + "_" + mode

    calendar[date_key] = local_date
  
  show_calendar = () ->
    calendar = robot.brain.get("calendar")
    response = "\n"
    for test_stage, time of calendar
      response += "#{test_stage}: #{time}\n"
    
    return response

  robot.hear /reset/i, (res) ->
    init_calendar()
    res.send "Reset done"

  robot.hear /record (staging|regression) (start|end) date/i, (res) ->
    stage = res.match[1].toLowerCase()
    mode = res.match[2].toLowerCase()

    update_calendar(stage, mode)
  
    res.send "Date recorded"

  robot.hear /get (staging|regression) (start|end) date/i, (res) ->
    date = res.match[1].toLowerCase() + "_" + res.match[2].toLowerCase()

    calendar = robot.brain.get("calendar")
    res.send "#{calendar[date]}"

  robot.hear /show calendar/i, (res) ->
    calendar = show_calendar()
    res.send "#{calendar}"

