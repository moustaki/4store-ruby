require '../lib/four_store/store'
require 'pp'

store = FourStore::Store.new 'http://dbtune.org/beancounter/sparql/'
response = store.load("http://moustaki.org/foaf.rdf");

pp response.body

response = store.delete("http://moustaki.org/foaf.rdf")

pp response.body
