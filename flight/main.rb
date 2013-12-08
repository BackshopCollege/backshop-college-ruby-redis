$: << '.'

require 'flight_searcher'
require 'flight'
require 'window'
require 'redis'
require 'date'

puts "-"*30
puts ' Saving flights '

Flight.new(321931, 'TAP', 'LISBON', 'RECIFE', Time.new(2013,5,10,13)).save
Flight.new(66632,  'TAP', 'LISBON', 'RECIFE', Time.new(2013,5,10,16)).save

Flight.new(99382, 'VARIG','SAMPA', 'RECIFE', Time.new(2013,6,10,13)).save
Flight.new(1123,  'TAM',  'RIO', 'RECIFE', Time.new(2013,5,10,15)).save

Flight.new(7732, 'RYANAIR', 'LISBON', 'DUBLIN', Time.new(2013,5,10,13)).save

puts "-" * 30

window = Window.new(Time.new(2013,5,10,13), Time.new(2013,5,10,17))
flight_finder = FlightSearcher.new('RECIFE', 'LISBON', window)
puts flight_finder.flights











