require '../lib/FourStore/store'

store = FourStore::Store.new 'http://dbtune.org/beancounter/sparql/'
response = store.delete('http://github.com/moustaki/4store-ruby')

puts response
