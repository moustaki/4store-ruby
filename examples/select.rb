require '../lib/four_store/store'
require 'pp'

store = FourStore::Store.new 'http://dbtune.org/beancounter/sparql/'
response = store.select("
    SELECT ?subject ?predicate ?object
    WHERE {
        GRAPH <http://github.com/moustaki/4store-ruby> {
            ?subject ?predicate ?object
        }
    }
");

pp response
