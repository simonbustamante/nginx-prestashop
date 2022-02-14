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
    


