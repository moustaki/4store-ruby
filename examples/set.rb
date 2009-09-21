require '../lib/four_store/store'

store = FourStore::Store.new 'http://dbtune.org/beancounter/sparql/'
response = store.set('http://github.com/moustaki/4store-ruby', "
    <http://github.com/moustaki/4store-ruby> foaf:maker <http://moustaki.org/foaf.rdf#moustaki> .
");

puts response
