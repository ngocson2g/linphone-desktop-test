import os
import subprocess
import configparser

SDK_DIR = "/home/son/Project/softphoneZlink_desktop/linphone-desktop/external/linphone-sdk"
os.chdir(SDK_DIR)

# .gitmodules doesn't have a section header at the very top sometimes, but it does for submodules
config = configparser.ConfigParser()
config.read(".gitmodules")

for section in config.sections():
    path = config.get(section, "path")
    url = config.get(section, "url")
    
    if url.startswith("../"):
        repo_name = url[3:]
    else:
        repo_name = url.split("/")[-1]
    
    if repo_name.endswith(".git"):
        repo_name = repo_name[:-4]
        
    if "github.com" in url:
        new_url = url
    else:
        new_url = f"https://github.com/BelledonneCommunications/{repo_name}.git"
        
    print(f"Checking {path}...")
    if not os.path.exists(path) or len(os.listdir(path)) == 0:
        print(f"Cloning {new_url} into {path}...")
        if os.path.exists(path):
            os.rmdir(path)
        subprocess.run(["git", "clone", "--depth", "1", new_url, path])
        git_dir = os.path.join(path, ".git")
        if os.path.exists(git_dir):
            import shutil
            shutil.rmtree(git_dir)
    else:
        print(f"Skipping {path} (already populated)")
