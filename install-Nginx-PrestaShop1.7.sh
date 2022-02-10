#!/usr/bin/env bash
if [ -d "db/" ]; then
  sudo rm -rf db/
  echo "Removing DB previous folder"
fi
if [ -d "prestashop/" ]; then
  sudo rm -rf prestashop/
  echo "Removing PRESTASHOP"
fi

# Download the PrestaShop source
wget https://www.prestashop.com/download/old/prestashop_1.7.8.3.zip

# Unzip the PrestaShop archive
unzip prestashop_1.7.8.3.zip

# Create prestashop directory
mkdir prestashop

#EN CASO DE NECESITAR CARGAR UNA DATA GENERADA DESDE "prestashop-shop-creator" 
#se deben descomentar estas lines y compilar una nueva version de imagen co el siguiete comando
#docker-compose up -d --no-deps --build
############################################################################
#mkdir prestashop/install
#mkdir prestashop/install/fixtures
#mkdir prestashop/install/fixtures/fashion
#sudo cp -rf generated_data/* prestashop/install/fixtures/fashion/
############################################################################

# Move zip file with actual shop to prestashop prestashop directory
mv prestashop.zip prestashop

# Move index.php to prestashop directory
mv index.php prestashop


# unzip -o prestashop/prestashop.zip -d prestashop/

#Set the correct user and group ownership for the PrestaShop directory
sudo chown -R www-data:www-data prestashop/


# Remove zip and install file
rm prestashop_1.7.8.3.zip Install_PrestaShop.html





# run docker containers

docker-compose up -d


# Cargar data generada en "prestashop-shop-creator"
# adding prestashop backup - GENERATED DATA FROM prestashop-shop-creator
# echo "THE PASSWORD FOR MYSQL IS => 'mysql-root-pwd'"
#mysql -u root -h 127.0.0.1 -p prestashop < ./docker-images/mysql/prestashop.sql
