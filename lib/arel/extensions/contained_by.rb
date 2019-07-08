# typed: true
module Arel
  module Nodes
    # https://www.postgresql.org/docs/9.1/functions-array.html
    class ContainedBy < InfixOperation
      sig { params(left: T.any(Arel::Nodes::Array, Arel::Nodes::TypeCast), right: T.any(Arel::Nodes::Array, Arel::Nodes::TypeCast)).void }
      def initialize(left, right)
        super('<@', left, right)
      end
    end
  end
end