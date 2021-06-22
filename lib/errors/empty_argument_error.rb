class EmptyArgumentError < StandardError
  EMPTY_ARGUMENT_ERROR = 'Argument cannot be empty!'.freeze
  def initialize
    EMPTY_ARGUMENT_ERROR
  end
end
