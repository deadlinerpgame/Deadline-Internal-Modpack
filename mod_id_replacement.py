import os, pathlib
home = os.getenv("username")
mods_path = pathlib.Path(f"C:\\Users\\{home}\\Zomboid\\Mods")
mod_infos = mods_path.rglob("mod.info")

for info in mod_infos:
    with open(info, 'r+') as info_file:
        info_data = info_file.read()

        if 'id=DL_' in info_data:
            print("Replacing mod ID in " + str(info_data))
            info_data = info_data.replace("id=DL_", "id=dev_DL_")
            info_file.seek(0)
            info_file.write(info_data)
            info_file.truncate()
