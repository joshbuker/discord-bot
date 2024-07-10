module DiscordBot
  class Server < Sinatra::Application
    configure do
      disable :logging
    end

    # Of course this doesn't work, why would it, it's sinatra
    before do
      content_type :json
    end

    get '/' do
      settings.bot.logger.info "Hello friend #{settings.logging}"
      settings.bot.discord_bot.channel(1242561194535944282).send_message('testing')
      'Hello friend'
    end

    post '/callback' do
      # data = request.body
      # settings.bot.logger.info data
      payload = params
      payload = JSON.parse(request.body.read).symbolize_keys unless params[:path]
      byebug
      # settings.bot.discord_bot.channel(1242561194535944282).send_message(data)
      { status: 200 }.to_json
    end
  end
end
