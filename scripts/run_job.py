import argparse
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum

def process_data(input_path, output_path):
    """Main processing function"""
    # Initialize Spark session
    spark = SparkSession.builder \
        .appName("DataProcessing") \
        .getOrCreate()

    # Read input CSV files
    print(f"Reading input data from: {input_path}")
    df = spark.read.csv(input_path, header=True, inferSchema=True)
    
    # aggregating by order_status to get the total amount at each order status
    print("Processing data...")
    processed_df = df.groupBy(col("order_status")).agg(
        sum(col("order_amount")).alias("order_amount")
    )
    
    # Write output as csv
    print(f"Writing results to: {output_path}")
    processed_df.write.mode("overwrite").csv(output_path)
    
    # Cleanup
    spark.stop()
    print("Job completed successfully")

if __name__ == "__main__":
    # Parse command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, help="Input data path (S3 or local)")
    parser.add_argument("--output", required=True, help="Output data path (S3 or local)")
    args = parser.parse_args()
    
    # Run processing
    process_data(args.input, args.output)