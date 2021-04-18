from sys import platform

if platform.startswith("linux"):
  platform = platform[:5]
elif platform.startswith("win"):
  platform = platform[:3]

print(platform)
