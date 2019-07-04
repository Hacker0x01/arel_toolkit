require_relative './transformer/node'
require_relative './transformer/visitor'

module Arel
  module Transformer
  end

  def self.transformer(object)
    return object if object.is_a?(Arel::Transformer::Node)

    Arel::Transformer::Visitor.new.accept(object)
  end
end
