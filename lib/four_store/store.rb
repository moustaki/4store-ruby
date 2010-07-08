require 'uri'
require 'net/http'
require 'rexml/document'
require File.expand_path(File.dirname(__FILE__)) + '/namespace'

module FourStore

  class Store

    def initialize(endpoint, options = nil)
      raise "4Store SPARQL end-point URI must end by '/sparql/'" if endpoint.split("/sparql/").size != 1
      @endpoint = URI.parse(endpoint)
      @proxy = URI.parse(ENV['HTTP_PROXY']) if ENV['HTTP_PROXY']
      @certificate = options["certificate"] if options
      @key = options["key"] if options
      @softlimit = options["soft-limit"] if options
    end

    def select(query)
      http.start do |h|
        request = Net::HTTP::Post.new(@endpoint.path)
        request.set_form_data({ 'query' => Namespace::to_sparql + query, 'soft-limit' => @softlimit })
        response = h.request(request)
        parse_sparql_xml_results(response.body)
      end
    end

    def set(graph, turtle)
      http.start do |h|
        request = Net::HTTP::Put.new(@endpoint.path + graph)
        request.body = Namespace::to_turtle + turtle
        request.content_type = 'application/x-turtle'
        response = h.request(request)
      end
    end

    def add(graph, turtle)
      http.start do |h|
        request = Net::HTTP::Post.new((@endpoint.path.split("/sparql/")[0] or "") + "/data/")
        request.set_form_data({
            'graph' => graph,
            'data' => Namespace::to_turtle + turtle,
            'mime-type' => 'application/x-turtle'
        })
        response = h.request(request)
      end
    end

    def delete(graph)
      http.start do |h|
        request = Net::HTTP::Delete.new(@endpoint.path + graph)
        response = h.request(request)
      end
    end

    def load(uri)
      # WARNING - relies on the -U flag being set when running 4s-httpd
      http.start do |h|
        request = Net::HTTP::Post.new((@endpoint.path.split("/sparql/")[0] or "") + "/update/")
        request.set_form_data({
            'update' => "LOAD <#{uri}>"
        })
        response = h.request(request)
      end
    end

    private

    def http
      if @proxy
        h = Net::HTTP::Proxy(@proxy.host, @proxy.port).new(@endpoint.host, @endpoint.port)
      else
        h = Net::HTTP.new(@endpoint.host, @endpoint.port)
      end
      if @certificate && @key
        require 'net/https'
        h.use_ssl = true
        h.cert = OpenSSL::X509::Certificate.new( File.read(@certificate) )
        h.key = OpenSSL::PKey::RSA.new( File.read(@key) )
        h.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      h
    end

    def parse_sparql_xml_results(xml)
      results = []
      doc = REXML::Document.new(REXML::Source.new(xml))
      doc.elements.each("*/results/result") do |result|
        result_hash = {}
        result.elements.each do |binding|
          key = binding.attributes["name"]
          value = binding.elements[1].text
          type = binding.elements[1].name 
          result_hash[key] = value
        end
        results.push result_hash
      end
      results
    end

  end

end
