module AttendanceHelper
  STATES = [:present, :absent, :excused, :unexpected]
  IDS    = STATES.map.with_index.to_h.freeze

  def self.unexpected
    @@unexpected ||= self.to_struct_list([:unexpected])
  end

  def self.expected
    @@expected   ||= self.to_struct_list(STATES - [:unexpected])
  end

  PRESENT_ISH = [:present, :excused, :unexpected]
  def self.present_ish
    @@okay       ||= self.to_struct_list(PRESENT_ISH)
  end

  protected
    def self.to_struct_list(states)
      states.map do |state|
        OpenStruct.new({
          id: STATES.find_index(state),
          name: state.to_s
        })
      end
    end
end
