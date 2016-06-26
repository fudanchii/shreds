class SubscriptionsController < ApplicationController
  # For managing categories
  def index
  end

  # For managing Feeds subscription
  def show
  end

  def create
    return error_response(I18n.t("feed.error.empty_url"),
      :unprocessable_entity) unless params[:feed][:url].present?
    category = if params[:category] && params[:category][:name].present?
                 params[:category][:name]
               else
                 Category.default
               end
    jid = CreateSubscription.perform_async(
      current_user.id,
      params[:feed][:url],
      category)
    render json: { watch: "create-#{jid}" }
  end

  def create_by_opml
    filename = OPML::File.new(params[:OPMLfile]).fullpath
    jid = ProcessOPML.perform_async current_user.id, filename
    render json: { watch: "opml-#{jid}" }
  rescue OPML::UploadError => e
    error_response e.message.html_safe, :unprocessable_entity
  end
end
