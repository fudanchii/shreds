# frozen_string_literal: true

require 'opml/file'

class SubscriptionsController < ApplicationController
  # For managing categories
  def index; end

  # For managing Feeds subscription
  def show; end

  def create
    if params[:feed][:url].blank?
      return error_response(I18n.t('feed.error.empty_url'),
                            :unprocessable_entity)
    end
    category = if params[:category] && params[:category][:name].present?
                 params[:category][:name]
               else
                 Category.default
               end
    jid = CreateSubscription.perform_async(
      current_user.id,
      params[:feed][:url],
      category
    )
    render json: { watch: "create-#{jid}" }
  end

  def create_from_opml
    filename = OPML::File.new(params[:OPMLfile]).path
    jid = ProcessOPML.perform_async current_user.id, filename
    render json: { watch: "opml-#{jid}" }
  rescue OPML::UploadError => e
    error_response e.message, :unprocessable_entity
  end

  def mark_all_as_read
    Entry.where(subscription_id: current_user.subscriptions.pluck(:id))
         .update_all(unread: false)
    render json: { info: I18n.t('feed.all_marked_read') }
  end

  def mark_all_as_unread
    Entry.where(subscription_id: current_user.subscriptions.pluck(:id))
         .update_all(unread: true)
    render json: { info: I18n.t('feed.all_marked_unread') }
  end

  def mark_feed_as_read
    current_user.subscriptions.find(params[:id])
                .entries.update_all(unread: false)
    render json: { info: I18n.t('feed.feed_marked_read') }
  end

  def mark_feed_as_unread
    current_user.subscriptions.find(params[:id])
                .entries.update_all(unread: true)
    render json: { info: I18n.t('feed.feed_marked_unread') }
  end
end
