fs = require('fs')
xml2js = require 'xml2js'
path = require('path')
{bold} = require('chalk')

{error, pr} = require '../lib/utils'

BASE = "#{process.env['HOME']}/.tvcli"
BASE_STORE = "#{BASE}/store"

list = ->
  return error("Your database is empty") unless fs.existsSync(BASE_STORE)
  ids = fs.readdirSync(BASE_STORE).filter (f) ->
    fs.statSync(path.join(BASE_STORE, f)).isDirectory()

  ids.forEach (id) ->
    fs.readFile "#{BASE_STORE}/#{id}/en.xml", (err, data) ->
      return error(err) if err
      parser = new xml2js.Parser()
      parser.parseString data, (err, result) ->
        return error(err) if err
        info = result['Data']['Series'][0]
        title = info['SeriesName'][0]
        overview = info['Overview'][0]
        pr("#{id} #{bold(title)}")
        # console.log(overview)
        # console.log("\n")

module.exports = list