# Base de Datos B2C con Prestashop 

La plataforma B2C se encuentra basada en “Prestashop”   el cual es un sistema de gestión de contenidos (CMS) libre y de código abierto pensado para construir desde cero tiendas en línea de comercio electrónico. Enfocado para permitir crear tiendas en línea desde pequeñas empresas a grandes corporaciones. Cuenta con un amplio mercado de temas con los que personalizar la tienda y más de 5000 módulos, entre gratuitos y de pago, con los que adaptar las funcionalidades propias de la herramienta.

## Requisitos

1. Realize primero el despliegue de la base de datos B2B, de acuerdo con https://github.com/simonbustamante/farmerRegistration.git alli podrá realizar la configuración de docker y docker-compose entre otras librerías necesarias para la ejecución de este script

## Despliegue de Herramienta y Datos

      ./install-Nginx-PrestaShop1.7.sh
      
## Detener Herramienta

      docker-compose down

## Descripción de data

* La data generada se obtiene con la herramienta prestashop-shop-creator https://github.com/simonbustamante/prestashop-shop-creator.git

* Una vez cargada la data en prestashop se procedió a crear un DUMP de MySQL que se encuentra ubicado en este mismo proyecto https://github.com/simonbustamante/nginx-prestashop/blob/master/docker-images/mysql/prestashop.zip 
* El DUMP es descomprimido durante la instalación en el archivo **prestashop.sql** el cual contiene toda una instalación de con data generada aleatoriamente con **prestashop-shop-creator** y también una serie de comandos SQL para poder adecuar la data y hacerla coincidir con la información de la plataforma B2B 
    

## Comandos SQL Ejecutados durante la instalación

```
-- PERSONALIZACION DE DATA --
-- actualizar pais a Filipinas
UPDATE `ps_address` SET `id_country`=170,`id_state`= 0 WHERE 1;

-- borrar direccion de anonimo
DELETE FROM `ps_address` WHERE `ps_address`.`id_address` = 1;

-- borrar customer anonimo
DELETE FROM `ps_customer` WHERE `ps_customer`.`id_customer` = 1;

-- actualizar id_customer

UPDATE `ps_customer` CROSS JOIN (SELECT @id := 0 ) as a  SET `id_customer`= @id := @id + 1;

-- actualizar 1 direccion para cada customer y el unico supplier Mayani

UPDATE `ps_address` CROSS JOIN (SELECT @id := 0 ) as a SET `id_customer`=@id := @id + 1 WHERE 1;
UPDATE `ps_address` CROSS JOIN (SELECT @id := 0 ) as a SET `id_address`=@id := @id + 1 WHERE 1;
UPDATE `ps_address` SET `id_supplier`= 0;
UPDATE `ps_address` SET `id_manufacturer`= 0;
UPDATE `ps_address` SET `id_customer`= 0, `id_supplier` = 1  WHERE `id_customer` = 13001;
UPDATE `ps_supplier` SET `name` = 'Mayani' WHERE `ps_supplier`.`id_supplier` = 1;

-- actualizar manufacturer name

UPDATE `ps_manufacturer` CROSS JOIN (SELECT @id := 0 ) as a SET `name`=CONCAT("Farm ", @id := @id + 1) WHERE 1;


-- actualizar product names

UPDATE `ps_product_lang` CROSS JOIN (SELECT @id := 0 ) as a SET `name`= CONCAT ("Product ", @id := @id + 1), `description` = CONCAT ("Product ", @id), `link_rewrite`= CONCAT ("product-", @id), `description_short` =  CONCAT ("Product ", @id) WHERE id_lang = 1;
UPDATE `ps_product_lang` CROSS JOIN (SELECT @id := 0 ) as a SET `name`= CONCAT ("Product ", @id := @id + 1), `description` = CONCAT ("Product ", @id), `link_rewrite`= CONCAT ("product-", @id), `description_short` =  CONCAT ("Product ", @id) WHERE id_lang = 2;


-- actualizar manufacturer de los products


UPDATE `ps_product` CROSS JOIN (SELECT @id := 0 ) as a SET `id_manufacturer`= @id := @id + 1;



-- actualizar categorias

UPDATE `ps_category_lang` SET `name`= "Farming",`description`= "Farming",`link_rewrite`= "farming" WHERE `id_category`= 3;
UPDATE `ps_category_lang` SET `name`= "Fishing",`description`= "Fishing",`link_rewrite`= "fishing" WHERE `id_category`= 4;
UPDATE `ps_category_lang` SET `name`= "Cattle Raising",`description`= "Cattle Raising",`link_rewrite`= "cattle-raising" WHERE `id_category`= 5;

UPDATE `ps_category` SET `id_parent` = 2, `active` = 1, `position`= 0  WHERE `id_category` = 3;
UPDATE `ps_category` SET `id_parent` = 2, `active` = 1, `position`= 1 WHERE `id_category` = 4;
UPDATE `ps_category` SET `id_parent` = 2, `active` = 1, `position`= 2 WHERE `id_category` = 5;
UPDATE `ps_category_shop` SET `position`= 0 WHERE 1;


-- actualizar categorias default de los productos

UPDATE `ps_product` CROSS JOIN (SELECT @id := 1 ) as a SET `id_category_default` = 3 WHERE `id_product` = @id AND @id:= @id+3;
UPDATE `ps_product` CROSS JOIN (SELECT @id := 2 ) as a SET `id_category_default` = 4 WHERE `id_product` = @id AND @id:= @id+3;
UPDATE `ps_product` CROSS JOIN (SELECT @id := 3 ) as a SET `id_category_default` = 5 WHERE `id_product` = @id AND @id:= @id+3;
UPDATE `ps_product_shop` CROSS JOIN (SELECT @id := 1 ) as a SET `id_category_default` = 3 WHERE `id_product` = @id AND @id:= @id+3;
UPDATE `ps_product_shop` CROSS JOIN (SELECT @id := 2 ) as a SET `id_category_default` = 4 WHERE `id_product` = @id AND @id:= @id+3;
UPDATE `ps_product_shop` CROSS JOIN (SELECT @id := 3 ) as a SET `id_category_default` = 5 WHERE `id_product` = @id AND @id:= @id+3;


-- actualizar direcciones y customers de carts

UPDATE `ps_cart` CROSS JOIN (SELECT @id := 0) as a SET `id_address_delivery`=@id:= @id + 1,`id_address_invoice`=@id:= @id,`id_customer`= @id WHERE `id_cart` <=13000;

UPDATE `ps_cart` CROSS JOIN (SELECT @id := 0) as a SET `id_address_delivery`=@id:= @id + 1,`id_address_invoice`=@id:= @id,`id_customer`= @id WHERE `id_cart` > 13000 AND `id_cart`<= 26000;

UPDATE `ps_cart` CROSS JOIN (SELECT @id := 0) as a SET `id_address_delivery`=@id:= @id + 1,`id_address_invoice`=@id:= @id,`id_customer`= @id WHERE `id_cart` > 26000 AND `id_cart`<= 39000;

UPDATE `ps_cart` CROSS JOIN (SELECT @id := 0) as a SET `id_address_delivery`=@id:= @id + 1,`id_address_invoice`=@id:= @id,`id_customer`= @id WHERE `id_cart` > 39000 AND `id_cart`<= 52000;

UPDATE `ps_cart` SET `id_guest`= 0 WHERE 1;


-- actualizar carritos y clientes en ordenes


UPDATE `ps_orders` CROSS JOIN (SELECT @id := 0) as a
CROSS JOIN (SELECT @aux := 1) as b
SET `id_customer` = @id := @id + 1
WHERE `id_order` = @aux AND @aux := @aux + 4;

UPDATE `ps_orders` 
CROSS JOIN (SELECT @id := 0) as a
CROSS JOIN (SELECT @aux := 2) as b
SET `id_customer` = @id := @id + 1
WHERE `id_order` = @aux AND @aux := @aux + 4;

UPDATE `ps_orders` 
CROSS JOIN (SELECT @id := 0) as a
CROSS JOIN (SELECT @aux := 3) as b
SET `id_customer` = @id := @id + 1
WHERE `id_order` = @aux AND @aux := @aux + 4;

UPDATE `ps_orders` 
CROSS JOIN (SELECT @id := 0) as a
CROSS JOIN (SELECT @aux := 4) as b
SET `id_customer` = @id := @id + 1
WHERE `id_order` = @aux AND @aux := @aux + 4;

UPDATE `ps_orders` AS A 
INNER JOIN (
	SELECT @id := @id + 1 AS id_order,`id_cart`, `id_customer`
	FROM `ps_cart`
	CROSS JOIN(SELECT @id := 0) as a
) AS B
ON A.`id_order`= B.`id_order`
SET A.`id_cart` = B.`id_cart`;




-- actualizar order details - product_name y cantidades devueltas


UPDATE `ps_order_detail` a
INNER JOIN `ps_product_lang` b ON a.`product_id` = b.`id_product` 
SET a.`product_name` = b.`name`,
a.`product_quantity_refunded` = 0,
a.`product_quantity_return` = 0,
a.`product_quantity_reinjected` = 0
WHERE b.`id_lang`= 1;


-- actualizar order details - product attribute

UPDATE `ps_order_detail` a
INNER JOIN `ps_product_attribute` b ON a.`product_id` = b.`id_product` 
SET a.`product_attribute_id` = b.`id_product_attribute`;


-- update product price

UPDATE `ps_product`CROSS JOIN (SELECT @id := 1) as a SET `price` = 1, `wholesale_price`=1  WHERE `id_product`=@id AND @id:= @id + 8;
UPDATE `ps_product`CROSS JOIN (SELECT @id := 2) as a SET `price` = 3, `wholesale_price`=3 WHERE `id_product`=@id AND @id:= @id + 8;
UPDATE `ps_product`CROSS JOIN (SELECT @id := 3) as a SET `price` = 5, `wholesale_price`=5 WHERE `id_product`=@id AND @id:= @id + 8;
UPDATE `ps_product`CROSS JOIN (SELECT @id := 4) as a SET `price` = 10, `wholesale_price`=10 WHERE `id_product`=@id AND @id:= @id + 8;
UPDATE `ps_product`CROSS JOIN (SELECT @id := 5) as a SET `price` = 15, `wholesale_price`=15 WHERE `id_product`=@id AND @id:= @id + 8;
UPDATE `ps_product`CROSS JOIN (SELECT @id := 6) as a SET `price` = 20, `wholesale_price`=20 WHERE `id_product`=@id AND @id:= @id + 8;
UPDATE `ps_product`CROSS JOIN (SELECT @id := 7) as a SET `price` = 25, `wholesale_price`=25 WHERE `id_product`=@id AND @id:= @id + 8;
UPDATE `ps_product`CROSS JOIN (SELECT @id := 8) as a SET `price` = 30, `wholesale_price`=30 WHERE `id_product`=@id AND @id:= @id + 8;

-- actualizar order details - product price

UPDATE `ps_order_detail` a
INNER JOIN `ps_product` b ON a.`product_id` = b.`id_product` 
SET a.`product_price` = b.`price`, 
a.`reduction_percent`=0, 
a.`product_quantity_discount`=0,
a.`total_price_tax_incl`= b.`price`* a.`product_quantity`,
a.`total_price_tax_excl`= b.`price`* a.`product_quantity`,
a.`unit_price_tax_incl` = b.`price`,
a.`unit_price_tax_excl` = b.`price`,
a.`original_product_price` = b.`price`,
a.`original_wholesale_price`= b.`price`;

-- actualizar order - total paid

UPDATE `ps_orders` AS b1, 
	(SELECT a.`id_order`, SUM(a.`total_price_tax_incl`) as TOTAL_ORDER FROM `ps_order_detail` a 
	INNER JOIN `ps_orders` b WHERE a.`id_order`= b.`id_order` GROUP BY a.`id_order`) AS b2
SET 
    b1.`total_paid` = b2.TOTAL_ORDER + b1.`total_shipping`,
    b1.`total_paid_tax_incl` = b2.TOTAL_ORDER + b1.`total_shipping`,
    b1.`total_paid_tax_excl` = b2.TOTAL_ORDER + b1.`total_shipping`,
    b1.`total_paid_real` = b2.TOTAL_ORDER + b1.`total_shipping`,
    b1.`total_products` = b2.TOTAL_ORDER,
    b1.`total_products_wt` = b2.TOTAL_ORDER
WHERE b1.`id_order` = b2.`id_order`;


-- actualizar fechas de transacciones, estado actual y deliveries ps_orders


UPDATE `ps_orders` AS A
INNER JOIN (
	SELECT id_order, 
	(TIMESTAMP '2021-04-02 00:00:00' + INTERVAL @n := @n + 8 MINUTE + INTERVAL @m := @m + 38 SECOND) AS TRANSACTION_DATE,
	(TIMESTAMP '2021-04-03 00:00:00' + INTERVAL @o := @o + 8 MINUTE + INTERVAL @p := @p + 38 SECOND) AS INVOICE_DATE,
	(TIMESTAMP '2021-04-03 00:00:00' + INTERVAL @q := @q + 8 MINUTE + INTERVAL @r := @r + 38 SECOND) AS DELIVERY_DATE,
	(TIMESTAMP '2021-04-03 00:00:00' + INTERVAL @s := @s + 8 MINUTE + INTERVAL @t := @t + 38 SECOND) AS UPDATE_DATE 
	FROM ps_orders
	CROSS JOIN (SELECT @m := 0) as a
	CROSS JOIN (SELECT @n := 0) as b
	CROSS JOIN (SELECT @o := 0) as c
	CROSS JOIN (SELECT @p := 0) as d 
	CROSS JOIN (SELECT @q := 0) as e
	CROSS JOIN (SELECT @r := 0) as f 
	CROSS JOIN (SELECT @s := 0) as g
	CROSS JOIN (SELECT @t := 0) as h   
	ORDER BY `ps_orders`.`id_order`  ASC
) AS B 
	
ON A.`id_order` = B.`id_order` 
SET A.`date_add` = B.TRANSACTION_DATE,
A.`invoice_date` = B.INVOICE_DATE,
A.`delivery_date` = B.DELIVERY_DATE,
A.`date_upd` = B.UPDATE_DATE,
A.`current_state` = 5;



-- actualizar historias - order history

UPDATE `ps_order_history` AS A
INNER JOIN (
    SELECT `id_order_history`, IF(@id<5,@id := @id + 1,@id:=1) AS COUNTER 
    FROM `ps_order_history` 
    CROSS JOIN (SELECT @id := 0) as a) AS B
ON A.`id_order_history` = B.`id_order_history` 
SET A.`id_order_state`= B.COUNTER;



-- actualizar stock a 9999999

UPDATE `ps_stock_available` SET `quantity`=9999999,`physical_quantity`=9999999;

```
