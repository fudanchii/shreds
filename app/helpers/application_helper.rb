# frozen_string_literal: true

module ApplicationHelper
  def title(string)
    appname = ENV.key?('app_name') ? ENV['app_name'] : 'shreds'
    "#{string} · #{appname}"
  end

  def strdate(date)
    date.strftime('%B %d, %Y %H:%M')
  end

  def full_url(path)
    File.join(ENV['app_host'].to_s, path.to_s)
  end

  def pretty_json(obj)
    MultiJson.dump(obj.as_json, pretty: !Rails.env.production?)
  end
end
