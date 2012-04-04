Fabricator(:order_product, :class_name => "OrderProduct") do 
   order_id   { Fabricate(:order).id }
   product_id { Fabricate(:product).id }
   quantity   1
   price      1.75
end 