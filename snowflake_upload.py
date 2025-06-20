import os
import snowflake.connector

from dotenv import load_dotenv
load_dotenv()

SNOWFLAKE_CONFIG = {
    'user': os.environ["user"],
    'password': os.environ["password"],
    'account': os.environ["account"],
    'warehouse': os.environ["warehouse"],
    'database': os.environ["database"],
    'schema': os.environ["schema"]
}

class SnowflakeUpload:
    
    def __init__(self, local_filepath: str, table_name: str, initial_column: str) -> None:
        self.local_filepath = local_filepath
        self.table_name = table_name
        self.initial_column = initial_column

    def establish_conn(self) -> None:
        self.conn = snowflake.connector.connect(**SNOWFLAKE_CONFIG)
        self.cur = self.conn.cursor()

    def create_table(self) -> None:

        try:
            print(f"Creating table {self.table_name} (if not exists)...")
            create_table_query = f"""
            CREATE TABLE IF NOT EXISTS {self.table_name} (
                {self.initial_column} VARIANT
            );
            """
            self.cur.execute(create_table_query)
        except Exception as e:
            print(f"Error {e} occurred!")

    def multifile_upload(self) -> None:
        for filename in os.listdir(self.local_filepath):
            if filename.endswith('.json'):
                full_path = os.path.join(self.local_filepath, filename)
                stage = f"@%{self.table_name}"
                put_command = f"PUT file://{full_path} {stage} AUTO_COMPRESS=TRUE"
                print(f"Uploading {filename} to {stage} ...")
                self.cur.execute(put_command)

        print("All JSON files uploaded.")

    def singlefile_uplaod(self) -> None:
        stage = f"@%{self.table_name}"
        put_command = f"PUT file://{self.local_filepath} {stage} AUTO_COMPRESS=TRUE"
        print(f"Uploading {self.local_filepath} to {stage} ...")
        self.cur.execute(put_command)
        print("File Uploaded")


    def upload_file(self, multi: bool) -> None:

        if multi:
            self.multifile_upload()
        else:
            self.singlefile_uplaod()

        copy_command = f"""
        COPY INTO {self.table_name}(data)
        FROM {f"@%{self.table_name}"}
        FILE_FORMAT = (TYPE = 'JSON' STRIP_OUTER_ARRAY=TRUE)
        ON_ERROR = 'CONTINUE';
        """
        print("Loading data into table ...")
        self.cur.execute(copy_command)
        print("Data loaded successfully.")

    def close_conn(self) -> None:
        self.cur.close()
        self.conn.close()

if __name__ == "__main__":
    review_upload = SnowflakeUpload("/Users/subhammoda/Documents/Projects/yelp-reviews-analysis/Yelp Dataset/splited_files", "yelp_review", "reviews")
    review_upload.establish_conn()
    review_upload.create_table()
    review_upload.upload_file(True)

    business_upload = SnowflakeUpload("/Users/subhammoda/Documents/Projects/yelp-reviews-analysis/Yelp Dataset/yelp_academic_dataset_business.json", "yelp_business", "business")
    business_upload.establish_conn()
    business_upload.create_table()
    business_upload.upload_file(True)