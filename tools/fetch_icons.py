import os
import urllib.request
import ssl

ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
}

ICONS = {
    'google': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/google.png',
    ],
    'steam': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/steam.png',
    ],
    'discord': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/discord.png',
    ],
    'riot_games': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/riotgames.png',
    ],
    'epic_games': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/epicgames.png',
    ],
    'shopee': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/shopee.png',
    ],
    'ubisoft': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/ubisoft.png',
    ],
    'roblox': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/roblox.png',
    ],
    'ea': [
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/electronicarts.png',
        'https://cdn.jsdelivr.net/npm/simple-icons-png@latest/icons/ea.png',
    ],
}

out_dir = os.path.join('assets', 'icons', 'services')
os.makedirs(out_dir, exist_ok=True)

for key, urls in ICONS.items():
    dest = os.path.join(out_dir, f'{key}.png')
    success = False
    for url in urls:
        try:
            print(f'Fetching {key} from {url}...')
            req = urllib.request.Request(url, headers=HEADERS)
            with urllib.request.urlopen(req, timeout=10, context=ctx) as resp:
                data = resp.read()
                if len(data) > 200:
                    with open(dest, 'wb') as f:
                        f.write(data)
                    print(f'Saved {key}.png ({len(data)} bytes)')
                    success = True
                    break
        except Exception as e:
            print(f'Failed {key} from {url}: {e}')
    if not success:
        print(f'WARNING: Could not download {key}.png')
