module FollowerMaze
  class User
    attr_reader :id, :followers

    @@users = {}

    class << self
      def all
        @@users.values
      end

      def find(id)
        @@users[id]
      end

      def find_many(ids)
        @@users.values.select { |u| ids.include? u.id }
      end

      def create(id, attrs = {})
        new(id, attrs)
      end

      def find_or_create(id)
        @@users.fetch(id) do
          new(id)
        end
      end
    end

    def initialize(id, attrs = {})
      @id        = id
      @followers = []

      @@users[@id] = self
    end

    def notify(data)
      connection = Base.connections.find_by_user_id(id)

      if connection
        connection.write data
      end
    end

    def add_follower(user_id)
      @followers << user_id
    end

    def remove_follower(user_id)
      @followers.delete(user_id)
    end

    def each(&block)
      map &block
      nil
    end

    def map(&block)
      [block.call(self)]
    end

    def any?
      true
    end
  end
end