# servidor-samba-cli
Instala y administra SAMBA como servidor independiente desde la interfaz de línea de comando.

## Lenguaje
Shell script (Bourne Shell)

## Prerequisitos
Ultima versión de Ubuntu, Debian o derivados.
No tener instalado samba como servidor o borrar el fichero: sudo rm /etc/samba/smb.conf y copiar el nuevo: sudo cp /usr/samba/smb.conf /etc/samba/
## Instalación
git clone https://github.com/joseafon/servidor-samba-cli.git

## Configuración
cd servidor-samba-cli && sudo chmod 700 admin.sh
Los archivos se almacenan en la ruta /etc/media/samba

## Uso
sudo sh admin.sh
## Capturas
![pic1](https://user-images.githubusercontent.com/57175463/73186956-84210b00-4118-11ea-9266-5ce117310dd3.jpg)
