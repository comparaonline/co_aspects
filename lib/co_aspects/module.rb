class Module
  private

  def aspects_annotations!
    extend CoAspects::Callbacks
  end
end
