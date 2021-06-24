class EmptyArgumentError < StandardError
  EMPTY_ARGUMENT_ERROR = 'Argument cannot be empty!'.freeze
  def initialize(msg = EMPTY_ARGUMENT_ERROR)
    super
  end
end
