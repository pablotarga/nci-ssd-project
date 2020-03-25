class ApplicationService
  def success!(*list)
    ServiceStatus.success!(*list)
  end

  def fail!(*list)
    ServiceStatus.fail!(*list)
  end
end
