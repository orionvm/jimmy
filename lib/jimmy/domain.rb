require 'uri'
require 'pathname'
require 'json'

require_relative 'schema_creation'

module Jimmy
  class Domain

    attr_reader :root, :types

    def initialize(root)
      @root = URI(root)
      @schemas = {}
      @types = {}
    end

    def domain
      self
    end

    def import(path)
      path = Pathname(path) unless path.is_a? Pathname
      @types = import_schemas(path + 'types', path).map { |k, v| [k.to_sym, v] }.to_h
      @schemas = import_schemas(path, path, 'types/')
    end

    def [](schema_name)
      @schemas[schema_name.to_s]
    end

    def export(path = nil)
      path = Pathname(path) if path.is_a? String
      raise 'Please specify an export directory' unless path.is_a?(Pathname) && (path.directory? || !path.exist?)
      path.mkpath
      @schemas.each { |name, schema| export_schema schema, path + "#{name.to_s}.json" }
    end

    private

    def import_schemas(path, base_path, reject_prefix = nil)
      result = {}
      Dir[path + '**/*.rb'].each do |full_path|
        full_path = Pathname(full_path)
        relative_path = full_path.relative_path_from(path)
        next if reject_prefix && relative_path.to_s.start_with?(reject_prefix)
        base_name = relative_path.to_s[0..-4]
        schema = instance_eval(full_path.read, full_path.to_s).schema
        schema.name = full_path.relative_path_from(base_path).to_s[0..-4]
        result[base_name] = schema
      end
      result
    end

    def export_schema(schema, target_path)
      target_path.parent.mkpath
      target_path.write JSON.pretty_generate(schema.to_h)
    end

    SchemaCreation.apply_to self

  end
end
