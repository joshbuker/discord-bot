# discord-bot
Playing around with writing a Discord bot in Ruby

https://github.com/shardlab/discordrb

## Install Nvidia Container Toolkit

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
