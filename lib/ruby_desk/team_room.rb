class RubyDesk::TeamRoom
  # Attribute readers for all attributes
  attr_reader :company_recno, :company_name, :name, :id, :recno, :teamroom_api

  class << self
    def get_teamrooms(connector)
      response = connector.prepare_and_invoke_api_call 'team/v1/teamrooms',
          :method=>:get
      # parses a JSON result returned from oDesk and extracts an array of TeamRooms out of it
      json = JSON.parse(response)
      team_rooms = []
      [json['teamrooms']['teamroom']].flatten.each do |teamroom|
        # Append this TeamRoom to array
        team_rooms << self.new(teamroom)
      end
      # return the resulting array
      team_rooms
    end

  end

  # Create a new TeamRoom from a hash similar to the one in ActiveRecord::Base.
  # The given hash maps each attribute name to its value
  def initialize(params={})
    params.each do |k, v|
      self.instance_variable_set("@#{k}", v)
    end
  end

  def snapshot(connector, online='now')
    response = connector.prepare_and_invoke_api_call "team/v1/teamrooms/#{self.id}",
      :params=>{:online=>online}, :method=>:get
    json = JSON.parse(response)
    RubyDesk::Snapshot.new(json['teamroom']['snapshot'])
  end

  def work_diary(connector, user_id, date = nil, timezone = "mine")
    RubyDesk::Snapshot.workdiary(connector, self.id, user_id, date, timezone)
  end
end

