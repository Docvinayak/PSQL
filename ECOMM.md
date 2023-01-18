# User table 
- consist of Id(pk),email,phone,password

# user address
- user_id as f.k and address_id as f.k , one user_id can have multiple address_id
- and 2 or more users and share same address

# address
- consist of address of users

# cart
- user_id as f.k and product_id as f.k and qty of product 
- and used is order line later for checkout

# wishlist
- user_id as f.k and product_id as f.k and qty of product

# product
- consist of name, discription, varient_id as f.k, price, image

# product varient 
- consist of product id as f.k and varient_options as f.k

# varient options 
- consist of various varients for products and vrient_id as f.k

# paymeant
- user_id and payment_type_id as f.k
- account number , expiry

# payment_type
- value for way of payment

# order_line
- user_id, order_date, cart_id(f.k), payment_id(f.k), address(fk), status
