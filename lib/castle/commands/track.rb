# frozen_string_literal: true

module Castle
  module Commands
    class Track
      def initialize(context)
        @context_merger = ContextMerger.new(context)
      end

      def build(options = {})
        event = options[:event]

        raise Castle::InvalidParametersError if event.nil? || event.to_s.empty?

        if options[:context] && options[:context].key?(:active)
          unless [true, false].include?(options[:context][:active])
            options[:context].delete(:active)
          end
        end

        args = {
          event: event,
          context: build_context(options[:context])
        }

        args[:user_id] = options[:user_id] if options.key?(:user_id)
        args[:properties] = options[:properties] if options.key?(:properties)
        args[:traits] = options[:traits] if options.key?(:traits)

        Castle::Command.new('track', args, :post)
      end

      private

      def build_context(request_context)
        @context_merger.call(request_context || {})
      end
    end
  end
end