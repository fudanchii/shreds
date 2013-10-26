class CategoryWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def destroy(id)
    category = Category.find(id)
    fail ArgumentError if category.name == Category.default
    category.safe_destroy
    EventPool.add("rmCategory-#{jid}", { view: 'destroy_category' })
  rescue
    EventPool.add("rmCategory-#{jid}", { error: "Can't remove this category" })
  end

  def perform(action, *params)
    send(action, *params)
  end

end
