# SCD2 Using Task and Streams Snowflake

Welcome to your very basic introduction to setting up and running a data pipeline for managing customer data in Snowflake! 🎉

## Overview 🌟

This script orchestrates a simple data pipeline for managing customer data from two CSV files (`d_customer_one.csv` and `d_customer_two.csv`) to a Snowflake database. It performs several tasks, including data loading, data transformations, and file management.

## Usage 🚀

1. **Set Up Snowflake Environment:**
   - Ensure you have access to a Snowflake environment with the necessary privileges to create and execute tasks, streams, and stages.

2. **Upload CSV Files:**
   - Upload the CSV files `d_customer_one.csv` and `d_customer_two.csv` to the appropriate directory in your Snowflake stage.

3. **Create Streams and Tasks:**
   - Execute the provided SQL script to create streams and tasks for the data pipeline.

4. **Execute Tasks:**
   - Execute the tasks in the following order:
     - `truncate_d_customer_raw`: Truncates the `d_customer_raw` table.
     - `csv_to_d_customer_raw`: Loads data from the CSV files into the `d_customer_raw` table.
     - `raw_to_d_customer_landing`: Merges data from `d_customer_raw` to `d_customer_landing` using SCD Type 1 logic.
     - `d_customer_landing_to_staging`: Loads data from `d_customer_landing` to `d_customer_staging` using streams for SCD Type 2 logic.
     - `d_customer_stage_file_remove`: Removes all files from the staging directory after data loading.

5. **View Results:**
   - View the data in the target tables (`d_customer_landing` and `d_customer_staging`) to verify the data loading and transformations.

## Note 📝

This README provides a very basic introduction to setting up and running a data pipeline in Snowflake. It's designed to help you get started quickly. If you have any questions or need further assistance, feel free to reach out! 😊

---

Enjoy exploring your data with Snowflake! 🎈