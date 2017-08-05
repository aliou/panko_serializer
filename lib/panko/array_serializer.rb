require_relative 'cache'

module Panko
  class ArraySerializer
    attr_accessor :subjects

    def initialize subjects, options = {}
      @subjects = subjects
      @each_serializer = options[:each_serializer]


      serializer_options = {
        only: options.fetch(:only, []),
        except: options.fetch(:except, []),
        context: options.fetch(:context, nil)
      }

      @descriptor = Panko::CACHE.fetch(@each_serializer, serializer_options)
      @serializer_instance = @each_serializer.new(serializer_options)
    end

    def to_json
      serialize_to_json @subjects
    end

    def serialize(subjects)
      Oj.load(serialize_to_json(subjects))
    end

    def to_a
      Oj.load(serialize_to_json(@subjects))
    end

    def serialize_to_json(subjects)
      writer = Oj::StringWriter.new(mode: :rails)
      Panko::serialize_subjects(subjects.to_a, writer, @descriptor, @serializer_instance)
      writer.to_s
    end
  end
end
