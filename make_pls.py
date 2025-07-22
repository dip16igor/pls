import os

def create_pls_playlist(directory, suffix):
    # Получаем список всех .mp3 и .Mp3 файлов в директории и подкаталогах
    mp3_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith('.mp3'):
                mp3_files.append(os.path.join(root, file))

    # Путь к плейлисту в корневой папке
    playlist_path = os.path.join(os.path.dirname(directory), f'playlist{suffix}.pls')
    
    # Записываем плейлист
    with open(playlist_path, 'w', encoding='utf-8') as playlist_file:
        # Записываем заголовок
        playlist_file.write("[playlist]\n")
        # Записываем каждый файл
        for index, mp3_file in enumerate(mp3_files, start=1):
            # Записываем информацию о файле
            playlist_file.write(f"File{index}={mp3_file}\n")
            playlist_file.write(f"Title{index}={os.path.basename(mp3_file)}\n")
            # Длительность можно оставить -1, если не известна
            playlist_file.write(f"Length{index}=-1\n")
        # Записываем количество треков
        playlist_file.write(f"NumberOfEntries={len(mp3_files)}\n")
        playlist_file.write("Version=2\n")

def main():
    # Папки с музыкой
    directories = ['./day', './night']
    suffixes = ['_day', '_night']
    
    for directory, suffix in zip(directories, suffixes):
        if os.path.exists(directory):
            create_pls_playlist(directory, suffix)
            print(f"Плейлист создан в корневой папке: playlist{suffix}.pls")
        else:
            print(f"Папка {directory} не найдена.")

if __name__ == "__main__":
    main()
