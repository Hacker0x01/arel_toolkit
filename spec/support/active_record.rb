# https://github.com/mvgijssel/arel_toolkit/issues/63
def replace_active_record_arel(arel)
  arel.ast.each do |node|
    case node
    when Arel::Table
      node.instance_variable_set(:@type_caster, nil)
    when Arel::Nodes::Equality
      case node.right
      when Arel::Nodes::BindParam
        node.right = cast_for_database(node.right.value.value_for_database)
      else
        raise "Unknown node type `#{node.class}`"
      end
    end
  end

  arel
end

def cast_for_database(value)
  case value
  when String
    Arel.sql("\"#{value}\"")
  when Integer
    value
  when TrueClass
    Arel::Nodes::TypeCast.new(Arel::Nodes::Quoted.new('t'), 'bool')
  when FalseClass
    Arel::Nodes::TypeCast.new(Arel::Nodes::Quoted.new('f'), 'bool')
  when Float
    value
  else
    raise "Unknown value cast `#{value}` with class `#{value.class}`"
  end
end
