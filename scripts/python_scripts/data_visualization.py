import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import os
import numpy as np


# Define input and output folders relative to the script's location
script_dir = os.path.dirname(os.path.abspath(__file__))
input_folder = os.path.join(script_dir, '../../data/exportedData/')
output_folder = os.path.join(script_dir, '../../visualizations/')

# Make sure output folder exists
os.makedirs(output_folder, exist_ok=True)

# Define column names for each CSV file
columns_sales_on_hours = ['hour', 'percentage']
columns_sales_per_country = ['country', 'sales_amount']
columns_top_10_customers_by_revenue = ['customer', 'revenue']
columns_top_10_most_popular_products = ['product', 'popularity']
columns_sales_per_weekday = ['weekday', 'sales_amount']
columns_customer_quantity_ordered_per_order = ['quantity_ordered']
columns_customer_total_amount_per_order = ['total_amount']
columns_top_5_categories_medium_spenders = ['category', 'medium_spenders']
columns_top_5_categories_low_spenders = ['category', 'low_spenders']
columns_top_5_categories_high_spenders = ['category', 'high_spenders']

# Load CSV files
df_sales_on_hours = pd.read_csv(os.path.join(input_folder, 'sales_on_hours.csv'), header=None, names=columns_sales_on_hours)
df_sales_per_country = pd.read_csv(os.path.join(input_folder, 'sales_per_country.csv'), header=None, names=columns_sales_per_country)
df_top_10_customers_by_revenue = pd.read_csv(os.path.join(input_folder, 'top_10_customers_by_revenue.csv'), header=None, names=columns_top_10_customers_by_revenue)
df_top_10_most_popular_products = pd.read_csv(os.path.join(input_folder, 'top_10_most_popular_products.csv'), header=None, names=columns_top_10_most_popular_products)
df_sales_per_weekday = pd.read_csv(os.path.join(input_folder, 'sales_per_weekday.csv'), header=None, names=columns_sales_per_weekday)
df_customer_quantity_ordered_per_order = pd.read_csv(os.path.join(input_folder, 'customer_quantity_ordered_per_order.csv'), header=None, names=columns_customer_quantity_ordered_per_order)
df_customer_total_amount_per_order = pd.read_csv(os.path.join(input_folder, 'customer_total_amount_per_order.csv'), header=None, names=columns_customer_total_amount_per_order)
df_top_5_categories_medium_spenders = pd.read_csv(os.path.join(input_folder, 'top_5_categories_medium_spenders.csv'), header=None, names=columns_top_5_categories_medium_spenders)
df_top_5_categories_low_spenders = pd.read_csv(os.path.join(input_folder, 'top_5_categories_low_spenders.csv'), header=None, names=columns_top_5_categories_low_spenders)
df_top_5_categories_high_spenders = pd.read_csv(os.path.join(input_folder, 'top_5_categories_high_spenders.csv'), header=None, names=columns_top_5_categories_high_spenders)

# Bar chart for sales by hour and country
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 6))

# Sales by hour
ax1.bar(df_sales_on_hours['hour'], df_sales_on_hours['percentage'])
ax1.set_title('Percentage of Daily Sales Occurring in Each Hour.')
ax1.set_xlabel('Hour of the Day')
ax1.set_ylabel('Percentage of Daily Sales')
ax1.tick_params(axis='x', rotation=0)

# Sales by country
ax2.bar(df_sales_per_country['country'], df_sales_per_country['sales_amount'])
ax2.set_title('Sales by Country Compared to Total Sales')
ax2.set_xlabel('Country')
ax2.set_ylabel('Total Sales (Log Scale) as Percentage of Global Sales')
ax2.set_yscale('log')
ax2.tick_params(axis='x', rotation=90)

plt.tight_layout()
plt.savefig(os.path.join(output_folder, 'sales_by_hour_country.png'))
plt.show()

# Bar chart for top 10 customers and products
fig, (ax3, ax4) = plt.subplots(1, 2, figsize=(12, 6))


# Ensure the 'customer' column is treated as a string
df_top_10_customers_by_revenue['customer'] = df_top_10_customers_by_revenue['customer'].astype(str)
# Top 10 customers by revenue
ax3.bar(df_top_10_customers_by_revenue['customer'], df_top_10_customers_by_revenue['revenue'], color='steelblue')
ax3.set_title('Top 10 Customers by Revenue Generated')
ax3.set_xlabel('Customer ID')
ax3.set_ylabel('Revenue Generated')
ax3.tick_params(axis='x', rotation=45)

# Top 10 most popular products
ax4.bar(df_top_10_most_popular_products['product'], df_top_10_most_popular_products['popularity'])
ax4.set_title('Top 10 Most Popular Products by Quantity Sold')
ax4.set_xlabel('Product')
ax4.set_ylabel('Quantity Sold')
ax4.tick_params(axis='x', rotation=90)

plt.tight_layout()
plt.savefig(os.path.join(output_folder, 'top10_customers_products.png'))
plt.show()

# Bar chart for sales by weekday
fig, ax5 = plt.subplots(figsize=(12, 6))
ax5.bar(df_sales_per_weekday['weekday'], df_sales_per_weekday['sales_amount'])
ax5.set_title('Sales Distribution by Weekday')
ax5.set_xlabel('Weekday')
ax5.set_ylabel('Sales Amount (as Percentage of Weekly Total)')
ax5.tick_params(axis='x', rotation=0)

plt.tight_layout()
plt.savefig(os.path.join(output_folder, 'sales_by_weekday.png'))
plt.show()

# Histogram and bar chart for quantity and total amount ordered
fig, (ax6, ax7) = plt.subplots(1, 2, figsize=(12, 6))

# Downsample for ax6 and ax7
df_sampled_quantity_ordered = df_customer_quantity_ordered_per_order.sample(frac=0.2, random_state=42)
df_sampled_total_amount = df_customer_total_amount_per_order.sample(frac=0.2, random_state=42)

df_customer_quantity_ordered_per_order = df_customer_quantity_ordered_per_order[df_customer_quantity_ordered_per_order['quantity_ordered'] < 800]
ax6.hist(df_customer_quantity_ordered_per_order['quantity_ordered'], bins=40)
ax6.set_title('Distribution of Quantity Ordered per Order')
ax6.set_xlabel('Quantity Ordered')
ax6.set_ylabel('Frequency')
ax6.set_yscale('log')

df_customer_total_amount_per_order = df_customer_total_amount_per_order[df_customer_total_amount_per_order['total_amount'] <= 15000]
ax7.hist(df_customer_total_amount_per_order['total_amount'], bins = 50)
ax7.set_title('Distribution of Total Amount per Order')
ax7.set_xlabel('Total Amount')
ax7.set_ylabel('Frequency')
ax7.set_yscale('log')
ax7.tick_params(axis='x', rotation=45)

plt.tight_layout()
plt.savefig(os.path.join(output_folder, 'distribution_total_amount_quantity.png'))
plt.show()


fig, (ax8, ax9) = plt.subplots(1,2,figsize=(12, 6))

# Bar chart for low spenders
ax8.bar(df_top_5_categories_low_spenders['category'], df_top_5_categories_low_spenders['low_spenders'])
ax8.set_title('Top 10 Most Popular Products by Quantity Sold for Low Spenders')
ax8.set_xlabel('product')
ax8.set_ylabel('Quantity Sold')
ax8.tick_params(axis='x', rotation=75)

# Bar chart for high spenders
ax9.bar(df_top_5_categories_high_spenders['category'], df_top_5_categories_high_spenders['high_spenders'])
ax9.set_title('Top 10 Most Popular Products by Quantity Sold for High Spenders')
ax9.set_xlabel('Product')
ax9.set_ylabel('Quantity Sold')
ax9.tick_params(axis='x', rotation=75)

plt.tight_layout()
plt.savefig(os.path.join(output_folder, 'top5_products_low_high.png'))
plt.show()


fig, ax10 = plt.subplots(1,figsize = (12,6))
ax10.bar(df_top_5_categories_medium_spenders['category'], df_top_5_categories_medium_spenders['medium_spenders'])
ax10.set_title('Top 10 Most Popular Products by Quantity Sold for Medium Spenders')
ax10.set_xlabel('Product')
ax10.set_ylabel('Quantity Sold')
ax10.tick_params(axis='x', rotation=45)

plt.tight_layout()
plt.savefig(os.path.join(output_folder, 'top5_products_medium.png'))
plt.show()
