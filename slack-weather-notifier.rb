require 'json'
require 'open-uri'
require 'slack/incoming/webhooks'

def post_forecast(title, link, text, forecast)
  attachments = [{
    title: title,
    title_link: link,
    text: text,
    image_url: forecast['image']['url'],
    color: '#7CD197'
  }]
  post_text = "#{forecast['date']}の#{title}は「#{forecast['telop']}」です。\n
  高尾山のある八王子市のピンポイント天気はこちらから
  -> http://weather.livedoor.com/area/forecast/1320100"

  slack = Slack::Incoming::Webhooks.new(ENV['WEBHOOK_URL'])
  slack.post(post_text, attachments: attachments)
end

def call
  uri = 'http://weather.livedoor.com/forecast/webservice/json/v1?city=130010'

  res     = JSON.load(open(uri).read)
  title   = res['title']
  text    = res['description']['text']
  link    = res['link']

  res['forecasts'].each do |f|
    post_forecast(title, link, text, f)
  end
end

call
