module DebatesHelper

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  def leaders_laggers(debate)
    viewpoints = debate.viewpoints
    viewpoints.sort_by { |v| v.votes }
  end

  def get_debate_from_debate_invite_notification(notification)
    DebateInvite.find_by_id(notification.unknown_object_id).debate
  end

  def get_debate_from_new_vupnt_notification(notification)
    Viewpoint.find_by_id(notification.unknown_object_id).debate
  end

  def join_request_pending?(debate)
    join_request = JoinRequest.where('debate_id = ? AND user_id = ?', debate.id, current_user.id)
    join_request.any? ? true : false
  end

  def get_leading_view(debate)
    viewpoints = debate.viewpoints
    if viewpoints.size == 0
      return nil
    else
      viewpoints.sort_by { |v| v.votes }
      viewpoints[0].desc
    end
  end

  def tied_view(debate)
    false
  end

  


  private

    def wrap_long_string(text, max_width = 20)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end
end
