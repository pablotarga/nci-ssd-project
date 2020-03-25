module Fetchable
  extend ActiveSupport::Concern

  class_methods do
    def fetchable?
      included_modules.include?(Fetchable)
    end

    def fetch(entry)
      return unless entry.present?
      entry.try(:fetchable?) ? entry : where(id: entry).first
    end
  end

  included do
    def fetchable?
      self.class.fetchable?
    end
  end



end
