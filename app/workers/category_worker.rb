class CategoryWorker
  include Sidekiq::Worker

  sidekiq_options :retry => false

  def destroy(id)
    category = Category.find(id)
    raise ArgumentError if category.name == Category.default
    category.safe_destroy
    $redis.set("rmCategory-#{jid}", {
      view: 'destroy_category'
    }.to_json, :ex => 60)
  rescue
    $redis.set("rmCategory-#{jid}", {
      error: "Can't remove this category"
    }.to_json, :ex => 60)
  end

  def perform(action, *params)
    send(action, *params)
  end

end
