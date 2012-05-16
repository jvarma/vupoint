module DebatesHelper

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  def leaders_laggers(debate)
    viewpoints = debate.viewpoints
    viewpoints.sort_by { |v| v.votes }
  end

  def get_debate_from_notification(notification)
    DebateInvite.find_by_id(notification.unknown_object_id).debate
  end


  private

    def wrap_long_string(text, max_width = 20)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
end
