# typed: true
# rubocop:disable Naming/MethodName
# rubocop:disable Naming/UncommunicativeMethodParamName

module Arel
  module Nodes
    class SessionUser < Arel::Nodes::Node
    end
  end

  module Visitors
    class ToSql
      sig { params(_o: Arel::Nodes::SessionUser, collector: Arel::Collectors::SQLString).returns(Arel::Collectors::SQLString) }
      def visit_Arel_Nodes_SessionUser(_o, collector)
        collector << 'session_user'
      end
    end
  end
end

# rubocop:enable Naming/MethodName
# rubocop:enable Naming/UncommunicativeMethodParamName