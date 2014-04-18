if Rails.env.production? && ENV["STAT_ACCOUNT"].present?
  instLog ||= Logger.new("#{Rails.root}/log/perf.log")
  ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|
    duration = (finish - start) * 1000
    unless payload[:view_runtime].nil?
      view_time = payload[:view_runtime]
      StatHat::API.ez_post_value("View Rendering", ENV["STAT_ACCOUNT"], view_time)
    end
    StatHat::API.ez_post_value("Response Time", ENV["STAT_ACCOUNT"], duration)
    if duration > 500
      StatHat::API.ez_post_count("Slow Requests", ENV["STAT_ACCOUNT"], 1)
    end
    if duration > 100
      instLog.debug("[action] #{payload[:method]} #{payload[:path]} #{duration}ms")
    end
  end

  ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|
    if payload[:sql]
      duration = (finish - start) * 1000
      StatHat::API.ez_post_value("DB Query", ENV["STAT_ACCOUNT"], duration)
      if duration > 50
        instLog.debug("[sql] #{payload[:name]} '#{payload[:sql]}' #{duration}ms")
      end
    end
  end
end
