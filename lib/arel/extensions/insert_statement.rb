# rubocop:disable Naming/MethodName
# rubocop:disable Naming/UncommunicativeMethodParamName

module Arel
  module Nodes
    class InsertStatement
      # https://www.postgresql.org/docs/9.5/sql-insert.html
      module InsertStatementExtension
        attr_accessor :with
        attr_accessor :conflict
        attr_accessor :override
        attr_accessor :returning

        def initialize
          super

          @returning = []
        end
      end

      prepend(InsertStatementExtension)
    end
  end

  module Visitors
    class ToSql
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/PerceivedComplexity
      def visit_Arel_Nodes_InsertStatement(o, collector)
        if o.with
          collector = visit o.with, collector
          collector << SPACE
        end

        collector << 'INSERT INTO '
        collector = visit o.relation, collector
        if o.columns.any?
          collector << " (#{o.columns.map do |x|
            quote_column_name x.name
          end.join ', '})"
        end

        case o.override
        when nil, 0
          collector << ''
        when 1
          collector << ' OVERRIDING USER VALUE'
        when 2
          collector << ' OVERRIDING SYSTEM VALUE'
        else
          raise "Unknown override `#{o.override}`"
        end

        collector = if o.values
                      maybe_visit o.values, collector
                    elsif o.select
                      maybe_visit o.select, collector
                    else
                      collector
                    end

        visit(o.conflict, collector) if o.conflict

        unless o.returning.empty?
          collector << ' RETURNING '
          collector = inject_join o.returning, collector, ', '
        end

        collector
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/PerceivedComplexity
    end

    class Dot
      module InsertStatementExtension
        def visit_Arel_Nodes_InsertStatement(o)
          super

          visit_edge o, 'with'
          visit_edge o, 'conflict'
          visit_edge o, 'override'
          visit_edge o, 'returning'
        end
      end

      prepend(InsertStatementExtension)
    end
  end
end

# rubocop:enable Naming/MethodName
# rubocop:enable Naming/UncommunicativeMethodParamName
