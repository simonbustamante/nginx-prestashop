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
docker-compose up -d

#selenium


if [ -d "generated_data/" ]; then
  echo -e "\n \033[0;33m COPIANDO \033[0;34m'generated_data' \033[0;33m a la raiz"
  sudo cp -rf  generated_data/* prestashop/install/fixtures/fashion
else
  echo -e "\n \033[0;31m SI DESEA CARGAR UNA DATA NUEVA DEBE COPIAR EL DIRECTORIO  \033[0;34m'generated_data' \033[0;31m en la raiz"
  echo -e "\n \033[0;31m NO ES NECESARIO COPIAR EL DIRECTORIO DATA \033[0;34m'generated_data' \033[0;31m YA QUE SE CUENTA CON UN EXPORT DE DB CON DATA CONTROLADA"
  # descomprimir la data controlada
  echo -e "\n \033[0;33m DESCOMPRIMIENDO DUMP BD"
  unzip docker-images/mysql/prestashop.zip
  ## Siguientes pasos
  echo -e "\n \033[0;33m SIGUIENTES PASOS: \n"
  echo -e "\n  1. Abra un navegador y escriba en la URL \033[0;34m'http://localhost' \033[0;33m para hacer el proceso de instalación"
  echo -e "\n  2. Introduzca los datos de instalación de acuerdo con el archivo README"
  echo -e "\n  3. Abra un navegador en \033[0;34m 'http://localhost/admin'"
  echo -e "\n \033[0;33m 4. Tome nota de la nueva ruta de administración, \033[0;34m (Ejemplo: 'http://localhost/admin0wrff34')"
  echo -e "\n \033[0;33m 5. Borre por línea de comandos el directorio \033[0;34m 'install' \033[0;33m con el siguiente comando \033[0;34m 'sudo rm -rf prestashop/install'"
  echo -e "\n \033[0;33m 6. Refresque el navegador en la nueva ruta de administración, \033[0;34m (Ejemplo: 'http://localhost/admin0wrff34')"
  echo -e "\n \033[0;33m 7. Vuelva a la línea de comandos y ejecute \033[0;34m 'mysql -u root -h 127.0.0.1 -p prestashop < prestashop.sql'"
  echo -e "\n \033[0;33m 8. INGRESAR LA CONTRASEÑA => \033[0;34m 'mysql-root-pwd' \033[0;33m y espere un momento mientras se ejecuta el proceso de import"
  echo -e "\n \033[0;33m 9. Opcionalmente puede acceder a la ruta de administracion con el \033[0;34m  usuario: 'admin@admin.com', contraseña: 'abcd1234' \n"
fi



