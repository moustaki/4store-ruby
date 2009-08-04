require 'uri'
require 'net/http'
require 'rexml/document'
require File.expand_path(File.dirname(__FILE__)) + '/namespace'

module FourStore

  class Store

    def initialize(endpoint)
      @endpoint = URI.parse(endpoint)
      @proxy = URI.parse(ENV['HTTP_PROXY']) if ENV['HTTP_PROXY']
    end

    def select(query)
      http.start do |h|
        request = Net::HTTP::Post.new(@endpoint.path)
        request.set_form_data({ 'query' => Namespace::to_sparql + query })
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
        request = Net::HTTP::Post.new(@endpoint.path.split("/sparql/")[0] + "/data/")
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

    private

    def http
      if @proxy
        http = Net::HTTP::Proxy(@proxy.host, @proxy.port).new(@endpoint.host, @endpoint.port)
      else
        http = Net::HTTP.new(@endpoint.host, @endpoint.port)
      end
      http
    end

    def parse_sparql_xml_results(xml)
      results = []
      doc = REXML::Document.new xml
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
