module ApiSpecHelper
  def api_double
    instance_double(DiscordBot::Api::Interface, {
      ollama: instance_double(DiscordBot::Api::Services::Ollama, {
        list_local_models: instance_double(RestClient::Response, {
          body: { models: [{ 'name' => 'llama3' }] }.to_json
        }),
        chat:              instance_double(RestClient::Response, {
          body: { message: { content: 'Some content' } }.to_json
        })
      })
    })
  end
end
