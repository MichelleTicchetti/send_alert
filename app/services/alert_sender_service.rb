class AlertSenderService
  def initialize(topic:, message:, type: "InformativeAlert", expiration_time: nil, specific_user: nil)
    @topic = topic
    @message = message
    @type = type
    @expiration_time = expiration_time
    @specific_user = specific_user
  end

  def call
    if @specific_user
      send_alert_to_user(@specific_user)
    else
      send_alerts_to_all_subscribers
    end
  end

  private

  def send_alert_to_user(user)
    alert_class.create!(
      message: @message,
      expiration_time: @expiration_time,
      user: user,
      topic: @topic,
      specific_user: true
    )
  end

  def send_alerts_to_all_subscribers
    @topic.users.each do |user|
      alert_class.create!(
        message: @message,
        expiration_time: @expiration_time,
        user: user,
        topic: @topic,
        specific_user: false
      )
    end
  end

  def alert_class
    begin
      @type.constantize
    rescue NameError
      raise "Invalid alert type: #{@type}"
    end
  end
  
end
