module FourStore

  class Namespace
    
    @namespaces = {
      'rdf' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      'dc' => 'http://purl.org/dc/elements/1.1/',
      'foaf' => 'http://xmlns.com/foaf/0.1/',
      'rdfs' => 'http://www.w3.org/2000/01/rdf-schema#',
      'xsd' => 'http://www.w3.org/2001/XMLSchema#',
      'activ' => 'http://www.bbc.co.uk/ontologies/activity/',
      'event' => 'http://purl.org/NET/c4dm/event.owl#',
      'po' => 'http://purl.org/ontology/po/',
      'timeline' => 'http://purl.org/NET/c4dm/timeline.owl#',
      'skos' => 'http://www.w3.org/2008/05/skos#',
      'time' => 'http://www.w3.org/2006/time#',
      'mo' => 'http://purl.org/ontology/mo/',
      'dcterms' => 'http://purl.org/dc/terms/',
      'wgs84_pos' => 'http://www.w3.org/2003/01/geo/wgs84_pos#',
      'owl' => 'http://www.w3.org/2002/07/owl#'
    }

    def self.add(short, long)
      @namespaces[short] = long
    end

    def self.get(short)
      @namespaces[short]
    end

    def self.to_sparql()
      sparql = ""
      @namespaces.keys.each do |short|
        sparql += "PREFIX #{short}: <#{@namespaces[short]}>\n"
      end
      sparql
    end

    def self.to_turtle()
      turtle = ""
      @namespaces.keys.each do |short|
        turtle += "@prefix #{short}: <#{@namespaces[short]}>.\n"
      end
      turtle
    end

  end

end
