Fabricator(:order_product, :class_name => "OrderProduct") do 
   order      { Fabricate(:order) }
   product    { Fabricate(:product, :price => 1.75) }
   quantity   1
   price      1.75
end 