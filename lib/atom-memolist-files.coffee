exec = require('child_process').exec
module.exports = (cb, key, dir, obj) ->
  command = undefined
  results = undefined
  command = 'grep -nrl ' + key + ' ' + dir
  results = exec(command, (err, stdout, stderr) ->
    unless err
      cb stdout, obj
    else
      console.log err
  )
  return
