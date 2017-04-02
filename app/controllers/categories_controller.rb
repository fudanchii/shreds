# frozen_string_literal: true

class CategoriesController < ApplicationController
  def destroy
    may_respond_with html: { info: I18n.t('category.removed'), redirect_to: '/' },
                     json: { watch: 'rmCategory-jid' }
  end
end
