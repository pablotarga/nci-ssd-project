class ApplicationService
  def self.success!(*list)
    ServiceStatus.success!(*list)
  end

  def self.fail!(*list)
    ServiceStatus.fail!(*list)
  end

  def success!(*list)
    ServiceStatus.success!(*list)
  end

  def fail!(*list)
    ServiceStatus.fail!(*list)
  end
end
