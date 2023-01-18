# User Table 
- Consist of Id as primary key and new user data (ID,email,phone,password)

# Admin Table
- Consist of users with admin access

# User Address
- User_id as forign key(f.k) and address_id as f.k , one user_id can have multiple address_id
- 2 or more users can share same address 
- A single user can have multiple address

# Address
- Consist of address of users

# Cart
- User_id as f.k and product_id as f.k and qty of product 
- Used is order line later for checkout

# Wishlist
- User_id as f.k and product_id as f.k and qty of product
- User can add products to there wishlist

# Product
- Consist of name, discription, varient_id as f.k, price, image

# Best seller 
- Consist of product id and orderd id and count of sell

# Product varient 
- Consist of product_id as f.k and varient_options as f.k
- Store products with there avalible varient

# Varient options 
- Consist of various varients for products and vrient_id as f.k
- Stores avalible varients 

# Paymeant
- User_id and payment_type_id as f.k
- Account number , expiry as card details

# Payment_type
- Value as a way of payment mastercard/visa/debit/credit

# Order_line
- User_id, order_date, cart_id(f.k), payment_id(f.k), address(fk), status
- Use to store data of orders and there status
