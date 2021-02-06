class Service
  include Dry::Monads[:maybe, :result, :do, :try]

  class << self
    def call(*data, &block)
      new.call(*data, &block)
    end
  end
end