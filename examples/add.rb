require '../lib/four_store/store'

store = FourStore::Store.new 'http://dbtune.org/beancounter/sparql/'
response = store.add('http://github.com/moustaki/4store-ruby', "
    <http://moustaki.org/foaf.rdf#moustaki> foaf:nick \"moustaki\".
");

puts response
