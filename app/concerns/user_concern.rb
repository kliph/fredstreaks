require 'active_support/concern'

# Concern including helper methods for the User model.
module UserConcern
  extend ActiveSupport::Concern
  included do
    def self.standings_query(columns)
      find_by_sql("SELECT #{columns.join(', ')}, rank() OVER (ORDER BY points DESC) FROM users")
    end
  end
end
