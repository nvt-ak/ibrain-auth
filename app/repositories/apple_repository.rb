class AppleRepository < Ibrain::BaseRepository
  def initialize(record, params)
    super(nil, record)

    @params = params
    @collection = Ibrain.user_class
  end
end