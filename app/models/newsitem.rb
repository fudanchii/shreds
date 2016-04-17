require 'shreds/feed/filters'

class Newsitem < ActiveRecord::Base
  belongs_to :feed
  has_many :entries, dependent: :destroy
  has_many :subscriptions, through: :entries

  scope :for_view, -> { order('published DESC, id DESC') }
  scope :latest_issue, -> { for_view.take 1 }

  before_destroy :hash_permalink

  before_create :filter_content

  before_save { permalink.strip! }

  class << self
    def sanitize_field(entry)
      params = {}
      %i(title published content author summary).each do |field|
        params[field] = entry.send(field) if entry.respond_to? field
      end
      params[:permalink] = get_entry_url entry
      ActionController::Parameters.new(params).permit!
    end

    def has?(link)
      ctlnk = link.dup
      links = [link.dup]
      scheme = ctlnk.slice! %r{^https?://}
      links << case scheme
               when 'http://'
                 ctlnk.prepend('https://')
               when 'https://'
                 ctlnk.prepend('http://')
               end
      links.compact.any? do |lnk|
        find_by(permalink: lnk).present? || Itemhash.has?(lnk)
      end
    end

    private

    def get_entry_url(entry)
      entry.url.presence.strip || (entry.entry_id.strip if entry.entry_id.urlish?)
    end
  end

  def next
    adj('(published < :pdate and id <> :id) or (published = :pdate and id < :id)').first
  end

  def prev
    adj('(published > :pdate and id <> :id) or (published = :pdate and id > :id)').last
  end

  def unreads
    entries.where(unread: true).count
  end

  private

  def adj(comp)
    Newsitem.for_view.where(feed_id: feed_id).where(comp, pdate: published, id: id)
  end

  def hash_permalink
    Itemhash.insert(permalink) if permalink.present? && unreads == 0
  end

  def filter_content
    Shreds::Feed::Filters.apply self
  end
end

# == Schema Information
#
# Table name: newsitems
#
#  id         :integer          not null, primary key
#  permalink  :text
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  content    :text
#  author     :text
#  title      :text
#  published  :datetime         not null
#  summary    :text
#
# Indexes
#
#  index_newsitems_on_feed_id_and_id  (feed_id,id) UNIQUE
#
