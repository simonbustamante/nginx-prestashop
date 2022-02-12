#!/usr/bin/env bash
if [ -d "db/" ]; then
  echo -e "\n \033[0;32m introducir contraseña para permisos de sudo de ser requerido"
  sudo rm -rf db/
  echo -e "\n \033[0;32m Borrando directorio de BD de instalación previa"
fi
if [ -d "prestashop/" ]; then
  echo -e "\n \033[0;32m introducir contraseña para permisos de sudo de ser requerido"
  sudo rm -rf prestashop/
  echo -e "\n \033[0;32m Borrando directorio de instalación previa PRESTASHOP"
fi

if [ -f "prestashop.sql" ]; then
  echo -e "\n \033[0;32m introducir contraseña para permisos de sudo de ser requerido"
  sudo rm -rf prestashop.sql
  echo -e "\n \033[0;32m Borrando dump BD de instalación previa"
fi

if [ -d "node_modules" ]; then
  echo -e "\n \033[0;32m introducir contraseña para permisos de sudo de ser requerido"
  sudo rm -rf node_modules/
  echo -e "\n \033[0;32m Borrando node_modules"
fi

# Descarga del código fuente de prestashop
echo -e "\n \033[0;32m Descargando Prestashop del sitio oficial"
wget https://www.prestashop.com/download/old/prestashop_1.7.8.3.zip

# Se descomprime el instalador de prestashop
echo -e "\n \033[0;32m Descomprimiendo archivo"
unzip prestashop_1.7.8.3.zip

# se crea directorio de prestashop
echo -e "\n \033[0;32m Instalando prestashop"
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

# se mueve zip  a pretashop
mv prestashop.zip prestashop

# se mueve index.php a prestashop 
mv index.php prestashop

unzip -o prestashop/prestashop.zip -d prestashop/

#asignación de grupos
echo -e "\n \033[0;32m introducir contraseña para permisos de sudo de ser requerido"
sudo chown -R www-data:www-data prestashop/

# remover algunos archvos de instalación
rm prestashop_1.7.8.3.zip Install_PrestaShop.html

# levanta contenedores de docker
echo -e "\n \033[0;32m Levantando contenedores"
docker-compose up -d --no-deps --build


#puppeteer
##configurando repositorios de node + instalacion
sudo apt update
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install nodejs
sudo apt -y  install gcc g++ make
node --version
npm --version
npm install
echo -e "\n \033[0;33m Instalando \033[0;34m'node_modules'\033[0;33m para puppeteer"

if [ -d "generated_data/" ]; then
  echo -e "\n \033[0;33m COPIANDO \033[0;34m'generated_data' \033[0;33m a la raiz"
  sudo cp -rf  generated_data/* prestashop/install/fixtures/fashion
else
  echo -e "\n \033[0;33m INSTALACION GRÁFICA EN PROGRESO \n"
  node instalacion-grafica.js
  echo -e "\n \033[0;31m SI DESEA CARGAR UNA DATA NUEVA DEBE COPIAR EL DIRECTORIO  \033[0;34m'generated_data' \033[0;31m en la raiz"
  echo -e "\n \033[0;31m NO ES NECESARIO COPIAR EL DIRECTORIO DATA \033[0;34m'generated_data' \033[0;31m YA QUE SE CUENTA CON UN EXPORT DE DB CON DATA CONTROLADA"
  echo -e "\n \033[0;33m ELIMINANDO DIRECTORIO DE INSTALACION \n"
  sudo rm -rf prestashop/install
  
  # descomprimir la data controlada
  echo -e "\n \033[0;33m DESCOMPRIMIENDO DUMP BD \n"
  unzip docker-images/mysql/prestashop.zip
  echo -e "\n \033[0;33m COPIANDO DUMP A CONTENEDOR MYSQL \n"
  docker cp prestashop.sql nginx-prestashop_mysql_1:/

  echo -e "\n \033[0;33m INSTALANDO MYSQL CLIENT \n"
  sudo apt-get install mysql-community-client mysql-common-5.6
  echo -e "\n \033[0;33m IMPORTANDO DUMP - ESPERE UNOS MINUTOS \n"
  mysql -u root -h 127.0.0.1 -pmysql-root-pwd prestashop < prestashop.sql

  ## Siguientes pasos
  echo -e "\n \033[0;31m EN CASO DE FALLAR EL DUMP SE DEBEN EJECUTAR LOS SIGUIENTES COMANDOS: \n"
  echo -e "\n \033[0;33m 1. docker exec -it nginx-prestashop_mysql_1 bash"
  echo -e "\n \033[0;33m 2. mysql -u root -h 127.0.0.1 -pmysql-root-pwd prestashop < prestashop.sql"
  echo -e "\n \033[0;33m 3. Opcionalmente puede acceder a la ruta de \033[0;34m localhost/admin \033[0;33m con el  \033[0;34musuario: 'admin@admin.com', contraseña: 'abcd1234' \n"
fi