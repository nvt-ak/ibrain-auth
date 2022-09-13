# frozen_string_literal: true

class TwitterRepository < Ibrain::BaseRepository
  def initialize(record, params)
    super(nil, record)

    @params = params
    @collection = Ibrain.user_class
  end
end
