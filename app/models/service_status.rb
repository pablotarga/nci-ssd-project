class ServiceStatus
  def self.success!(*list)
    new(:success, *list)
  end

  def self.fail!(*list)
    new(:failure, *list)
  end

  def initialize(*list)
    @statuses = []
    @errors = []
    @params = {}
    add(*list)
  end

  def add(*list)
    [list].flatten.each{|o| setEntry(o)}
    self
  end

  def as(*list)
    @statuses = []
    add(*list)
  end

  def params
    @params.clone
  end

  def errors
    @errors.clone
  end

  def get *ks
    ks = [ks].flatten.map(&:to_sym)
    v = ks.map{|k| @params.key?(k) && @params[k]}
    ks.size == 1 ? v.first : v
  end

  private

  def method_missing(method_name, *opts)
    if method_name.to_s.ends_with?('?')
      @statuses.any?(&method_name.to_sym)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.ends_with?('?') || super
  end

  def setEntry(o)
    if o.is_a? Symbol
      @statuses.push o.to_s.inquiry
    elsif o.class.included_modules.include?(Mongoid::Document) && o.errors.present?
      @errors += o.errors.full_messages
    elsif o.is_a?(Hash)
      h = o.symbolize_keys
      err = h.delete :errors
      @errors += [err].flatten if err.present?
      @params.merge!(h)
    end

  end
end
