# xAI Roblox Script Helper

## Loader
```lua
getgenv().GrokConfig = {
	API_KEY = "xai-9Inu98tMIIfKwzvPWfwOBsV64BaAz5pib3UO7JJT6vZYH5u0ODMbM4QUhzQ43MYxinaNTHm57Av5W4LD", -- ← put your key here
	MODEL = "grok-4.6",
	API_URL = "https://api.x.ai/v1/chat/completions"
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/gui.luau"))()
```

## Configurations
```lua
getgenv().GrokConfig = {
	API_KEY = "PUT UR API KEY HERE", -- ← put your key here
	MODEL = "grok-4.6", -- latest Model
	API_URL = "https://api.x.ai/v1/chat/completions"
}
```
