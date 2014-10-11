if Rails.env.production? && ENV['STAT_ACCOUNT'].present?
  instlog ||= Logger.new("#{Rails.root}/log/perf.log")
  ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |_name, start, finish, _id, payload|
    duration = (finish - start) * 1000
    unless payload[:view_runtime].nil?
      view_time = payload[:view_runtime]
      StatHat::API.ez_post_value('View Rendering', ENV['STAT_ACCOUNT'], view_time)
    end
    StatHat::API.ez_post_value('Response Time', ENV['STAT_ACCOUNT'], duration)
    if duration > 300
      StatHat::API.ez_post_count('Slow Requests', ENV['STAT_ACCOUNT'], 1)
      instlog.info("[action] #{payload[:method]} #{payload[:path]} #{duration}ms")
    end
  end

  ActiveSupport::Notifications.subscribe 'sql.active_record' do |_name, start, finish, _id, payload|
    duration = (finish - start) * 1000
    if payload[:name] == 'SQL'
      StatHat::API.ez_post_value('DB Query', ENV['STAT_ACCOUNT'], duration)
    end
    if duration > 300
      instlog.info("[sql] #{payload[:name]} '#{payload[:sql]}' #{duration}ms")
    end
  end
end
