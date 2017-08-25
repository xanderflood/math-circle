module SemesterStateHelper
  STATES = ["hidden", "lottery_open", "lottery_closed",
            "lottery_done", "registration_open", "closed"]

  TRANSITIONS = ["publish", "hide", "close_lottery", "open_lottery", "run",
                "run_and_open", "open_registration", "close_registration"]

  STATE_DESCRIPTIONS = {
    "hidden"            => "This semester is currently hidden.",
    "lottery_open"      => "Lottery registration is currently open.",
    "lottery_closed"    => "Lottery registration has been closed.",
    "lottery_done"      => "Lottery course assignments have been made.",
    "registration_open" => "Normal registration is currently open.",
    "closed"            => "This semester is closed. No more registration is permitted."
  }

  STATE_NAMES = {
    "hidden"            => "Hidden",
    "lottery_open"      => "Lottery registration",
    "lottery_closed"    => "Lottery closed",
    "lottery_done"      => "Lottery done",
    "registration_open" => "Registration open",
    "closed"            => "Closed"
  }

  TRANSITION_SUCCESS = {
    "publish"            => "Semester has been published.",
    "hide"               => "Semester has been hidden.",
    "close_lottery"      => "Lottery registration has been closed.",
    "open_lottery"       => "Lottery registration has been open.",
    "run"                => "Lottery has been run.",
    "run_and_open"       => "Lottery has been run and registration opened.",
    "open_registration"  => "Normal registration has been opened.",
    "close_registration" => "Normal registration has been closed."
  }

  def self.transition_form(semester, transition, text)
  end
end
