if Rails.env.production? && ENV["STAT_ACCOUNT"].present?
  ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|
    duration = (finish - start) * 1000
    unless payload[:view_runtime].nil?
      view_time = payload[:view_runtime]
      StatHat::API.ez_post_value("rails request view duration", ENV["STAT_ACCOUNT"], view_time)
    end
    StatHat::API.ez_post_value("rails request duration", ENV["STAT_ACCOUNT"], duration)
    if duration > 500
      StatHat::API.ez_post_count("rails slow requests", ENV["STAT_ACCOUNT"], 1)
    end  
  end
end
