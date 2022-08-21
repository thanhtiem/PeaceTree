AccessPolicy = Struct.new(:user, :access) do
  def manager?
    true
  end
end
