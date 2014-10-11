class CategoriesController < ApplicationController
  def feed_subscriptions
    @categories = Category.includes(:feeds).all
  end

  def destroy
    may_respond_with(
      html: { info: I18n.t('category.removed'), redirect_to: '/' },
      json: { watch: 'rmCategory-jid' }
    )
  end
end
