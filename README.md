# xAI Roblox Script Helper

## Loader
```lua
getgenv().GrokConfig = {
	API_KEY = "xai-9Inu98tMIIfKwzvPWfwOBsV64BaAz5pib3UO7JJT6vZYH5u0ODMbM4QUhzQ43MYxinaNTHm57Av5W4LD", -- ← put your key here
	MODEL = "grok-4.6",
	API_URL = "https://api.x.ai/v1/chat/completions"
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Git-art-byte/xAI/refs/heads/main/gui.luau"))()
```
