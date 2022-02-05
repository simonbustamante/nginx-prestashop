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
#mkdir prestashop/install
#mkdir prestashop/install/fixtures
#mkdir prestashop/install/fixtures/fashion



# Move zip file with actual shop to prestashop prestashop directory
mv prestashop.zip prestashop

# Move index.php to prestashop directory
mv index.php prestashop


unzip -o prestashop/prestashop.zip -d prestashop/

#Set the correct user and group ownership for the PrestaShop directory
sudo chown -R www-data:www-data prestashop/
#sudo chown -R www-data:www-data generated_data/

# Remove zip and install file
rm prestashop_1.7.8.3.zip Install_PrestaShop.html


#copiando la data generada a la version
sudo cp -rf generated_data/* prestashop/install/fixtures/fashion/


# run docker containers

docker-compose up -d

# install prestashop from cli
