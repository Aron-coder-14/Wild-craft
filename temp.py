import os
import asyncio
import aiofiles
import shutil

async def rename_file(old_path, new_path, semaphore):
    async with semaphore:
        await asyncio.to_thread(shutil.move, old_path, new_path)

async def rename_pngs_sequentially(folder_path):
    # Get all PNG files in the folder
    png_files = [f for f in os.listdir(folder_path) if f.lower().endswith('.png')]
    
    # Sort the files alphabetically
    png_files.sort()
    
    # Create a temporary folder for the renaming process
    temp_folder = os.path.join(folder_path, 'temp_rename')
    os.makedirs(temp_folder, exist_ok=True)
    
    # Create a semaphore to limit concurrent file operations
    semaphore = asyncio.Semaphore(os.cpu_count() * 2)  # Adjust this value based on your system
    
    try:
        # Rename and move files to the temporary folder
        tasks = []
        for index, filename in enumerate(png_files, start=1):
            old_path = os.path.join(folder_path, filename)
            new_filename = f"{index}.png"
            new_path = os.path.join(temp_folder, new_filename)
            task = asyncio.create_task(rename_file(old_path, new_path, semaphore))
            tasks.append(task)
            print(f"Queued '{filename}' to be renamed to '{new_filename}'")
        
        # Wait for all renaming tasks to complete
        await asyncio.gather(*tasks)
        
        # Move the renamed files back to the original folder
        tasks = []
        for filename in os.listdir(temp_folder):
            old_path = os.path.join(temp_folder, filename)
            new_path = os.path.join(folder_path, filename)
            task = asyncio.create_task(rename_file(old_path, new_path, semaphore))
            tasks.append(task)
        
        # Wait for all moving tasks to complete
        await asyncio.gather(*tasks)
        
    finally:
        # Clean up: remove the temporary folder
        await asyncio.to_thread(shutil.rmtree, temp_folder)
    
    print(f"Renamed {len(png_files)} PNG files sequentially.")

async def main():
    folder_path = "processed_frames"
    await rename_pngs_sequentially(folder_path)

if __name__ == "__main__":
    asyncio.run(main())