# frozen_string_literal: true

class AppleRepository < Ibrain::BaseRepository
  def initialize(record, params)
    super(nil, record)

    @params = params
    @collection = Ibrain.user_class
  end

  def find_or_initialize!
    user = @collection.find_by_apple(uid: params['uid'])
    return user if user.present?

    @collection.create_with_line!
  end
end
