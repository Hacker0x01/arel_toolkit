# rubocop:disable Naming/MethodName
# rubocop:disable Naming/UncommunicativeMethodParamName

module Arel
  module Visitors
    class ToSql
      private

      def visit_Arel_Nodes_NotEqual(o, collector)
        right = o.right

        collector = visit o.left, collector

        case right
        when Arel::Nodes::Unknown, Arel::Nodes::False, Arel::Nodes::True
          collector << ' IS NOT '
          visit right, collector

        when NilClass
          collector << ' IS NOT NULL'

        else
          collector << ' != '
          visit right, collector
        end
      end

      def visit_Arel_Nodes_Equality(o, collector)
        right = o.right

        collector = visit o.left, collector

        case right
        when Arel::Nodes::Unknown, Arel::Nodes::False, Arel::Nodes::True
          collector << ' IS '
          visit right, collector

        when NilClass
          collector << ' IS NULL'

        else
          collector << ' = '
          visit right, collector
        end
      end

      def visit_Arel_Nodes_NotBetweenSymmetric(o, collector)
        collector = visit o.left, collector
        collector << ' NOT BETWEEN SYMMETRIC '
        visit o.right, collector
      end

      def visit_Arel_Nodes_NamedFunction(o, collector)
        aggregate(o.name, o, collector)
      end

      def visit_Arel_Nodes_Factorial(o, collector)
        if o.prefix
          collector << '!! '
          visit o.expr, collector
        else
          visit o.expr, collector
          collector << ' !'
        end
      end

      def visit_Arel_Nodes_DefaultValues(_o, collector)
        collector << 'DEFAULT VALUES'
      end

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
        when 0
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

        unless o.returning.empty?
          collector << ' RETURNING '
          collector = inject_join o.returning, collector, ', '
        end

        visit(o.on_conflict, collector) if o.on_conflict
        collector
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/PerceivedComplexity

      # rubocop:disable Metrics/AbcSize
      def visit_Arel_Nodes_Conflict(o, collector)
        collector << ' ON CONFLICT '

        visit(o.infer, collector) if o.infer

        case o.action
        when 1
          collector << 'DO NOTHING'
        when 2
          collector << 'DO UPDATE SET '
        else
          raise "Unknown conflict clause `#{action}`"
        end

        o.values.any? && (inject_join o.values, collector, ', ')

        if o.wheres.any?
          collector << ' WHERE '
          collector = inject_join o.wheres, collector, ' AND '
        end

        collector
      end
      # rubocop:enable Metrics/AbcSize

      def visit_Arel_Nodes_Infer(o, collector)
        if o.name
          collector << 'ON CONSTRAINT '
          collector << o.name
          collector << SPACE
        end

        if o.indexes
          collector << '('
          inject_join o.indexes, collector, ', '
          collector << ') '
        end

        collector
      end

      def visit_Arel_Nodes_SetToDefault(_o, collector)
        collector << 'DEFAULT'
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/PerceivedComplexity
      def visit_Arel_Nodes_UpdateStatement(o, collector)
        if o.with
          collector = visit o.with, collector
          collector << SPACE
        end

        wheres = if o.orders.empty? && o.limit.nil?
                   o.wheres
                 else
                   [Nodes::In.new(o.key, [build_subselect(o.key, o)])]
                 end

        collector << 'UPDATE '
        collector = visit o.relation, collector
        unless o.values.empty?
          collector << ' SET '
          collector = inject_join o.values, collector, ', '
        end

        unless o.froms.empty?
          collector << ' FROM '
          collector = inject_join o.froms, collector, ', '
        end

        unless wheres.empty?
          collector << ' WHERE '
          collector = inject_join wheres, collector, ' AND '
        end

        unless o.returning.empty?
          collector << ' RETURNING '
          collector = inject_join o.returning, collector, ', '
        end

        collector
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def visit_Arel_Nodes_CurrentOfExpression(o, collector)
        collector << 'CURRENT OF '
        collector << o.cursor_name
      end

      # rubocop:disable Metrics/AbcSize
      def visit_Arel_Nodes_DeleteStatement(o, collector)
        if o.with
          collector = visit o.with, collector
          collector << SPACE
        end

        collector << 'DELETE FROM '
        collector = visit o.relation, collector

        if o.using
          collector << ' USING '
          collector = inject_join o.using, collector, ', '
        end

        if o.wheres.any?
          collector << WHERE
          collector = inject_join o.wheres, collector, AND
        end

        unless o.returning.empty?
          collector << ' RETURNING '
          collector = inject_join o.returning, collector, ', '
        end

        maybe_visit o.limit, collector
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/AbcSize
      def aggregate(name, o, collector)
        collector << "#{name}("
        collector << 'DISTINCT ' if o.distinct
        collector << 'VARIADIC ' if o.variardic

        collector = inject_join(o.expressions, collector, ', ')

        if o.within_group
          collector << ')'
          collector << ' WITHIN GROUP ('
        end

        if o.orders.any?
          collector << SPACE unless o.within_group
          collector << 'ORDER BY '
          collector = inject_join o.orders, collector, ', '
        end

        collector << ')'

        if o.filter
          collector << ' FILTER(WHERE '
          visit o.filter, collector
          collector << ')'
        end

        if o.alias
          collector << ' AS '
          visit o.alias, collector
        else
          collector
        end
      end
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/AbcSize

      def apply_ordering_nulls(o, collector)
        case o.nulls
        when 1
          collector << ' NULLS FIRST'
        when 2
          collector << ' NULLS LAST'
        else
          collector
        end
      end
    end
  end
end

# rubocop:enable Naming/MethodName
# rubocop:enable Naming/UncommunicativeMethodParamName
