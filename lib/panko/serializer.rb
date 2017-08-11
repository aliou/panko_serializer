require_relative "cache"
require_relative "serialization_descriptor"
require "oj"

module Panko
  class Serializer
    class << self
      def inherited(base)
        base._attributes = (_attributes || []).dup
        base._has_one_associations = (_has_one_associations || []).dup
        base._has_many_associations = (_has_many_associations || []).dup

        @_attributes = []
        @_has_one_associations = []
        @_has_many_associations = []
      end

      attr_accessor :_attributes, :_has_one_associations, :_has_many_associations

      def attributes(*attrs)
        @_attributes.push(*attrs).uniq!
      end

      def has_one(name, options)
        @_has_one_associations << { name: name, options: options }
      end

      def has_many(name, options)
        @_has_many_associations << { name: name, options: options }
      end
    end

    def initialize(options = {})
      @context = options.fetch(:context, nil)
      @descriptor = Panko::CACHE.fetch(self.class, options)
    end

    attr_reader :object, :context

    def serialize(object, writer = nil)
      Oj.load(serialize_to_json(object, writer))
    end

    def serialize_to_json(object, writer = nil)
      @object = object

      writer ||= Oj::StringWriter.new(mode: :rails)
      Panko::serialize_subject(object, writer, self, @descriptor)

      writer.to_s
    end
  end
end
