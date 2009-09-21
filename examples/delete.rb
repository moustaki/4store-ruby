require '../lib/four_store/store'

store = FourStore::Store.new 'http://dbtune.org/beancounter/sparql/'
response = store.delete('http://github.com/moustaki/4store-ruby')

puts response
