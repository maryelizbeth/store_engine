Fabricator(:order_product, :class_name => "OrderProduct") do 
   order      { Fabricate(:order) }
   product    { Fabricate(:product) }
   quantity   1
   price      1.75
end 