module Arel
  module SqlToArel
    class PgQueryVisitor
      class FrameOptions
        class << self
          def arel(frame_options, start_offset, end_offset)
            frame_option_names = calculate_frame_option_names(frame_options)
            return unless frame_option_names.include?('FRAMEOPTION_NONDEFAULT')

            range_klass = if frame_option_names.include?('FRAMEOPTION_RANGE')
                            Arel::Nodes::Range
                          else
                            Arel::Nodes::Rows
                          end

            start_node = calculate_frame_node(
              'FRAMEOPTION_START_',
              frame_option_names,
              start_offset,
            )
            end_node = calculate_frame_node(
              'FRAMEOPTION_END_',
              frame_option_names,
              end_offset,
            )

            if frame_option_names.include?('FRAMEOPTION_BETWEEN')
              Arel::Nodes::Between.new(
                range_klass.new,
                Arel::Nodes::And.new([start_node, end_node]),
              )
            else
              range_klass.new start_node
            end
          end

          private

          # always NONDEFAULT
          # RANGE or ROWS
          # mandatory BETWEEN
          # RANGE only unbounded
          # ROWS all
          # https://github.com/postgres/postgres/blob/REL_10_1/src/include/nodes/parsenodes.h
          FRAMEOPTIONS_V10 = {
            'FRAMEOPTION_NONDEFAULT' => 0x00001,
            'FRAMEOPTION_RANGE' => 0x00002,
            'FRAMEOPTION_ROWS' => 0x00004,
            'FRAMEOPTION_BETWEEN' => 0x00008,
            'FRAMEOPTION_START_UNBOUNDED_PRECEDING' => 0x00010,
            'FRAMEOPTION_END_UNBOUNDED_PRECEDING' => 0x00020,
            'FRAMEOPTION_START_UNBOUNDED_FOLLOWING' => 0x00040,
            'FRAMEOPTION_END_UNBOUNDED_FOLLOWING' => 0x00080,
            'FRAMEOPTION_START_CURRENT_ROW' => 0x00100,
            'FRAMEOPTION_END_CURRENT_ROW' => 0x00200,
            'FRAMEOPTION_START_VALUE_PRECEDING' => 0x00400,
            'FRAMEOPTION_END_VALUE_PRECEDING' => 0x00800,
            'FRAMEOPTION_START_VALUE_FOLLOWING' => 0x01000,
            'FRAMEOPTION_END_VALUE_FOLLOWING' => 0x02000,
          }.freeze

          FRAMEOPTIONS_V11_AND_UP = {
            'FRAMEOPTION_NONDEFAULT' => 0x00001, # any specified? */
            'FRAMEOPTION_RANGE' => 0x00002, # RANGE behavior */
            'FRAMEOPTION_ROWS' => 0x00004, # ROWS behavior */
            'FRAMEOPTION_GROUPS' => 0x00008,  # GROUPS behavior */
            'FRAMEOPTION_BETWEEN' => 0x00010, # BETWEEN given? */
            'FRAMEOPTION_START_UNBOUNDED_PRECEDING' => 0x00020, # start is U. P. */
            'FRAMEOPTION_END_UNBOUNDED_PRECEDING' => 0x00040, # (disallowed) */
            'FRAMEOPTION_START_UNBOUNDED_FOLLOWING' => 0x00080, # (disallowed) */
            'FRAMEOPTION_END_UNBOUNDED_FOLLOWING' => 0x00100, # end is U. F. */
            'FRAMEOPTION_START_CURRENT_ROW' => 0x00200, # start is C. R. */
            'FRAMEOPTION_END_CURRENT_ROW' => 0x00400, # end is C. R. */
            'FRAMEOPTION_START_OFFSET_PRECEDING' => 0x00800, # start is O. P. */
            'FRAMEOPTION_END_OFFSET_PRECEDING' => 0x01000, # end is O. P. */
            'FRAMEOPTION_START_OFFSET_FOLLOWING' => 0x02000, # start is O. F. */
            'FRAMEOPTION_END_OFFSET_FOLLOWING' => 0x04000, # end is O. F. */
            'FRAMEOPTION_EXCLUDE_CURRENT_ROW' => 0x08000, # omit C.R. */
            'FRAMEOPTION_EXCLUDE_GROUP' => 0x10000, # omit C.R. & peers */
            'FRAMEOPTION_EXCLUDE_TIES' => 0x20000, # omit C.R.'s peers */
          }.freeze

          def frameoptions
            case PG.library_version.to_s[0, 2]
            when '09', '10'
              FRAMEOPTIONS_V10
            when '11', '12', '13', '14', '15', '16', '17'
              FRAMEOPTIONS_V11_AND_UP
            else
              raise "Version #{PG.library_version.to_s[0, 2]} not supported"
            end
          end

          def biggest_detractable_number(number, candidates)
            high_to_low_candidates = candidates.sort { |a, b| b <=> a }
            high_to_low_candidates.find do |candidate|
              number - candidate >= 0
            end
          end

          def calculate_frame_option_names(frame_options, names = [])
            return names if frame_options.zero?

            number = biggest_detractable_number(frame_options, frameoptions.values)
            name = frameoptions.key(number)
            calculate_frame_option_names(
              frame_options - number, names + [name]
            )
          end

          def calculate_frame_node(pattern, frame_option_names, offset)
            node_name = frame_option_names.select { |n| n.start_with?(pattern) }
            raise "Don't know how to handle multiple nodes" if node_name.length > 1

            node_name = node_name.first.gsub(/FRAMEOPTION_(START|END)_/, '')
            name_to_node(node_name, offset)
          end

          def name_to_node(node_name, offset)
            case node_name
            when 'UNBOUNDED_PRECEDING'
              Arel::Nodes::Preceding.new

            when 'UNBOUNDED_FOLLOWING'
              Arel::Nodes::Following.new

            when 'CURRENT_ROW'
              Arel::Nodes::CurrentRow.new

            when 'VALUE_PRECEDING', 'OFFSET_PRECEDING'
              Arel::Nodes::Preceding.new offset

            when 'VALUE_FOLLOWING', 'OFFSET_FOLLOWING'
              Arel::Nodes::Following.new offset

            else
              raise "Unknown start / end frame node `#{node_name}`"
            end
          end
        end
      end
    end
  end
end
