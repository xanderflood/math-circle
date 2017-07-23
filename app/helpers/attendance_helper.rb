module AttendanceHelper
  STATES = [:present, :absent, :excused, :unexpected]

  def self.expected
    @@expected ||= self.to_struct_list(STATES - [:unexpected])
  end

  def self.okay
    @@okay ||= self.to_struct_list([:present, :excused])
  end

  def self.unexpected
    @@unexpected ||= self.to_struct_list(STATES - [:present, :absent])
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
