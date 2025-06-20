import os

class FileSplit:

    def __init__(self, input_file: str = "./Yelp Dataset/yelp_academic_dataset_review.json", output_prefix: str = "split_file_", num_output_files: int = 10) -> None:        

        self.input_file = input_file
        self.output_prefix = output_prefix
        self.num_files = num_output_files

    def split_files(self) -> None:

        with open(self.input_file, "r" , encoding="utf8") as f:
            total_lines = sum(1 for _ in f)  

        lines_per_file = total_lines // self.num_files

        print(f"Total lines: {total_lines}, Lines per file: {lines_per_file}")
        
        destination_dir = "./Yelp Dataset/splited_files"
        try:
            os.mkdir(destination_dir)
            print(f"Directory '{destination_dir}' created successfully.")
        except FileExistsError:
            print(f"Directory '{destination_dir}' already exists.")
        except Exception as e:
            print(f"An error occurred: {e}")

        with open(self.input_file, "r" , encoding="utf8") as f:

            os.chdir(destination_dir)

            for i in range(self.num_files):
                
                output_filename = f"{self.output_prefix}{i+1}.json"
                
                with open(output_filename, "w", encoding="utf8" ) as out_file:
                    for _ in range(lines_per_file):
                        line = f.readline()
                        if not line:
                            break
                        out_file.write(line)
                
                print(f"File {i+1} created!")

        print("JSON file successfully split into smaller parts!")

if __name__ == "__main__":
    fs = FileSplit()
    fs.split_files()