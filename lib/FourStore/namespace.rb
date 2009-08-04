module FourStore

  class Namespace
    
    @namespaces = {
      'dc' => 'http://purl.org/dc/elements/1.1/',
      'foaf' => 'http://xmlns.com/foaf/0.1/',
      'rdfs' => 'http://www.w3.org/2000/01/rdf-schema#',
      'xsd' => 'http://www.w3.org/2001/XMLSchema#'
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
