$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dhis2'

require 'minitest/autorun'

#Dhis2.connect(url: "http://127.0.1.1:8082", user: "admin", password: "district")
Dhis2.connect(url: "https://play.dhis2.org/demo", user: "admin", password: "district")
