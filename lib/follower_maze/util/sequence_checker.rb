require 'set'
require 'forwardable'

module FollowerMaze
  module Util
    class SequenceChecker
      extend Forwardable

      attr_reader :first

      def_delegators :@sequence, :size

      def initialize(first = 1, opts = {})
        @sequence        = java.util.TreeMap.new
        @first           = first
        @options         = opts
        @identity_method = opts[:identity_method] || :id
        @limit           = opts[:limit] || 1000
      end

      def <<(item)
        @sequence.put item.send(@identity_method), item
      end

      def next
        raise "Sequence is not complete." unless complete?
        self.class.new(max_id + 1, @options)
      end

      def complete?
        false if size < @limit
        (max_id - min_id == size - 1) && (min_id == first)
      end

      def max_id
        @sequence.last_key
      end

      def min_id
        @sequence.first_key
      end

      def data
        @sequence.values
      end
    end
  end
end