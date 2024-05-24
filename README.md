# Ruby Discord Bot

Playing around with writing a Discord bot in Ruby.

Discord API Library: https://github.com/shardlab/discordrb

## Usage

Instructions on how to run locally via dev container, or as a docker compose service.

### Install Docker

Install Docker Desktop to be able to run the compose file locally, or install Docker using your existing methods.

https://docs.docker.com/desktop/

### Install Nvidia Container Toolkit

To run, you'll either need to install the nvidia container toolkit, or disable the GPU reservation in the docker-compose.yml.

https://hub.docker.com/r/ollama/ollama

1. Configure the repository

```sh
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
```

2. Install the NVIDIA Container Toolkit packages

```sh
sudo apt-get install -y nvidia-container-toolkit
```

3. Configure Docker to use Nvidia driver

```sh
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### Create Discord Bot Token

From the Discord Developer Portal: https://discord.com/developers/applications

Create a new application for your bot. You'll want to save the token to your password manager, as it will be needed to test and run the bot.

Also, you'll want to enable all of the Privileged Gateway Intents, otherwise you will run into errors on startup due to permission mismatch.

### Populate .env

```sh
cp .env.sample .env
```

Edit the `.env` file, and add the bot token from above.

### Run using Dev Containers

If you have VS Code, and are familiar with dev containers, you can test the bot locally as you would normally for any other application.

If you need to stop the service and restart it, the entrypoint from terminal is:

```sh
bundle exec ruby lib/discord_bot.rb
```

### Running using Docker Compose

If however, you're looking to use this as a service, you can run it using Docker Compose:

```sh
docker compose up -d
```

Follow the logs by grabbing the docker container id:

```sh
docker ps
```

Then tailing the logs (exit logs with `ctrl+c`):

```sh
docker logs -f container_id
```

To bring down the service and update it:

```sh
docker compose down
docker compose pull
```
