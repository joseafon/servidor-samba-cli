#########################################################################
#                                                                       #
#       Nombre del Script: samba-server-cli                             #
#       Descripcion: Administración del Servidor Samba                  #
#       Autor: Jose Manuel Afonso Santana                               #
#       Alias: joseafon                                                 #
#       Email: jmasantana@linuxmail.org                                 #
#                                                                       #
#########################################################################


#!/bin/sh

clear

which apt > /dev/null 2>&1 || which dpkg > /dev/null 2>&1

if [ $? -ne 0 ]
then

    echo "\e[5m"
    echo  "\e[31mTu sistema operativo no es compatible con este script\e[0m"

    exit 1

fi

if [ $USER != 'root' ]
then

echo "\e[5m"
echo "\e[31mNo tienes privilegios de administrador\e[0m"

    exit 2
fi

echo  "\e[92m
███████╗███████╗██████╗ ██╗   ██╗██╗██████╗  ██████╗ ██████╗ 
██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔══██╗██╔═══██╗██╔══██╗
███████╗█████╗  ██████╔╝██║   ██║██║██║  ██║██║   ██║██████╔╝
╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║  ██║██║   ██║██╔══██╗
███████║███████╗██║  ██║ ╚████╔╝ ██║██████╔╝╚██████╔╝██║  ██║
╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝
    ███████╗ █████╗ ███╗   ███╗██████╗  █████╗
    ██╔════╝██╔══██╗████╗ ████║██╔══██╗██╔══██╗
    ███████╗███████║██╔████╔██║██████╔╝███████║
    ╚════██║██╔══██║██║╚██╔╝██║██╔══██╗██╔══██║
    ███████║██║  ██║██║ ╚═╝ ██║██████╔╝██║  ██║
    ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚═╝  ╚═╝
         ██████╗██╗     ██╗
        ██╔════╝██║     ██║
        ██║     ██║     ██║
        ██║     ██║     ██║
        ╚██████╗███████╗██║
         ╚═════╝╚══════╝╚═╝
\e[0m"
echo

echo  "\e[96mComprobando la conexion de red...\e[0m"

	ping -c 3 8.8.8.8 > /dev/null 2>&1

	if [ $? -ne 0 ]
	then

        echo "\e[5m"
		echo  "\e[31mLa conexion de red ha fallado, intentando conectar con la pasarela...\e[0m"

		gateway=$(ip route show | sed -n 1p | awk '{print $3}')

		ping -c 3 $gateway > /dev/null 2>&1

			if [ $? -ne 0 ]
			then

				echo "\e[5m"
				echo  "\e[31mNo se ha podido conectar con la pasarela, revise la tarjeta de red y cableado si lo hubiere\e[0m"
				sleep 3
                clear

				exit 3

			fi

	else
        echo
        echo  "\e[96mHecho\e[0m"
        echo
        echo  "\e[96mInstalando actualizaciones del sistema, espere por favor...\e[0m"

        apt-get update -y 
        apt-get upgrade -y 
        dpkg --configure -a
        apt-get autoremove -y 

        echo
		echo  "\e[96mHecho\e[0m"

		sleep 3

	fi

echo

	which smbd > /dev/null 2>&1

	if [ $? -ne 0 ]
	then
        clear

		echo  "\e[96mRealizando la instalacion de Samba, esto puede tardar un tiempo...\e[0m"

        apt-get install -y samba > /dev/null 2>&1
		apt-get install -y smbclient > /dev/null 2>&1
		apt-get clean

        # Habilita servidor de nombres para NetBIOS
        # Guarda en la variable el número de línea donde se encuentra wins support
        wins_linea=$(sed -n '/wins support =/=' /etc/samba/smb.conf)

        # Elimina la línea y la sustituye por el nuevo valor
        sed -i ''$wins_linea'd' /etc/samba/smb.conf
        sed -i ''$wins_linea'i\wins support = yes\' /etc/samba/smb.conf

        # Copia del fichero original
        cp /etc/samba/smb.conf /etc/samba/smb.conf.original

        # Creación de los directorios para almacenar los datos de las carpetas compartidas
        mkdir -p /etc/media/samba/privado /etc/media/samba/publico

        # Directorio que guarda la configuración de la carpeta compartida
        mkdir -p /etc/samba/recursos

        # Directorio que guarda los grupos a los que pertenece el usuario
        mkdir -p /etc/samba/grupos

        else
            echo
            echo  "\e[96mSamba esta instalado\e[0m"

	fi

	while :
	do
		clear
		echo  "\e[92m

    ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
    ████╗ ████║██╔════╝████╗  ██║██║   ██║
    ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
    ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
    ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
    ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝
██████╗ ██████╗ ██╗███╗   ██╗ ██████╗██╗██████╗  █████╗ ██╗
██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██║██╔══██╗██╔══██╗██║
██████╔╝██████╔╝██║██╔██╗ ██║██║     ██║██████╔╝███████║██║
██╔═══╝ ██╔══██╗██║██║╚██╗██║██║     ██║██╔═══╝ ██╔══██║██║
██║     ██║  ██║██║██║ ╚████║╚██████╗██║██║     ██║  ██║███████╗
╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝╚═╝     ╚═╝  ╚═╝╚══════╝
\e[0m"

echo "\e[96mIP SERVER:\e[0m  \e[92m$(hostname -I)\e[0m"

echo "\e[93mELIJE UNA OPCION DE CONFIGURACION\e[0m"

echo "\e[96m
#############################################
#                                           #
# [1] CARPETAS PUBLICAS                     #
#                                           #
# [2] CARPETAS PRIVADAS                     #
#                                           #
# [3] USUARIOS                              #
#                                           #
# [4] RECURSOS SAMBA                        #
#                                           #
# [0] SALIR                                 #
#                                           #
#############################################
\e[0m"

echo
	read opcion1

        case $opcion1 in

            1) while :
            do
                clear
                echo  "\e[92m
+------------------------------------------------------+
|                                                      |
|                  CARPETAS PUBLICAS                   |
|                                                      |
+------------------------------------------------------+
|                                                      |
| Pulsa [1] para crear carpeta publica                 |
|                                                      |
| Pulsa [2] para eliminar carpeta publica              |
|                                                      |
| Pulsa [0] para regresar al menu principal            |
|                                                      |
+------------------------------------------------------+
\e[0m"
                echo

                read opcion2

	                case $opcion2 in

		                1) clear
                                echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|               CREAR CARPETA PUBLICA              |
|                                                  |
+--------------------------------------------------+
\e[0m"
                                echo
                                echo  "\e[96mESTAS SON LAS CARPETAS PUBLICAS CREADAS\e[0m"
                                echo  "\e[96m------------------------------------------------------------\e[0m"
                                echo

                                    ls /etc/media/samba/publico 1>&2

                                echo
                                echo  "\e[96m------------------------------------------------------------\e[0m"

                                echo  "\e[96mIntroduce el nombre de la carpeta a compartir\e[0m"
                                echo
			                        read directorio

			                        if [ -d /etc/media/samba/publico/"$directorio" ]
			                        then

                                    echo "\e[5m"
				                    echo  "\e[31mLa carpeta $directorio ya existe\e[0m"
				                    sleep 2

			                        else
				                        mkdir -p /etc/media/samba/publico/"$directorio" 
				                        chmod 777 /etc/media/samba/publico/"$directorio"

				                        echo "
["$directorio"]
path = /etc/media/samba/publico/"$directorio"
comment = Carpeta Publica
browseable = yes
writable = yes
guest ok = yes
create mode 0777
directory mode = 0777
" >> /etc/samba/smb.conf

                                        # Crea fichero donde se almacena la configuración del recurso compartido
                                        touch /etc/samba/recursos/"$directorio".conf

                                        echo "
["$directorio"]
path = /etc/media/samba/publico/"$directorio"
comment = Carpeta Publica
browseable = yes
writable = yes
guest ok = yes
create mode 0777
directory mode = 0777
" >> /etc/samba/recursos/"$directorio".conf

                                        echo
				                        echo  "\e[96mLa carpeta $directorio ha sido creada\e[0m"
				                        sleep 2
                                        systemctl restart smbd
			                        fi
			                        ;;



                    2) clear
                            echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|             ELIMINAR CARPETA PUBLICA             |
|                                                  |
+--------------------------------------------------+
\e[0m"
                        echo
                        echo  "\e[96mESTAS SON LAS CARPETAS PUBLICAS CREADAS\e[0m"
                        echo "\e[96m------------------------------------------------------------\e[0m"
                        echo

                       		 ls /etc/media/samba/publico 1>&2

                        echo
                        echo  "\e[96m------------------------------------------------------------\e[0m"
                        echo
		                echo  "\e[96mIntroduce el nombre de la carpeta a eliminar\e[0m"
		                echo

		                read directorio

		                if [ -d /etc/media/samba/publico/"$directorio" ]
		                then

			                echo
                                # Borra la carpeta publica
				                rm -r /etc/media/samba/publico/"$directorio"

                                # Guarda en la variable el número de línea del GRUPO DE TRABAJO
                                linea=$(sed -n '/workgroup =/=' /etc/samba/smb.conf)

                                # Guarda el nombre del GRUPO DE TRABAJO actual
                                workgroup=$(sed -n ''$linea'p' /etc/samba/smb.conf | awk '{print $3}')

                                # Borra el fichero de configuración de Samba
                                rm /etc/samba/smb.conf

                                # Borra el registro del recurso compartido
                                rm /etc/samba/recursos/"$directorio".conf

                                # Copia el fichero original de Samba
                                cp /etc/samba/smb.conf.original /etc/samba/smb.conf

                                # Borra la línea donde se encuentra el GRUPO DE TRABAJO del fichero original
                                sed -i ''$linea'd' /etc/samba/smb.conf

                                # Sustituye el nombre del GRUPO DE TRABAJO que viene por defecto por el que había antes, almacenado en la variable workgroup
                                sed -i ''$linea'i\workgroup = '$workgroup'\' /etc/samba/smb.conf

                                # Guarda la salida de todas las configuraciones de los recursos compartidos en el nuevo fichero de Samba
                                cat /etc/samba/recursos/*.conf >> /etc/samba/smb.conf 2>&1

                                echo
				                echo  "\e[96mLa carpeta $directorio ha sido eliminada\e[0m"
				                sleep 2

                                systemctl restart smbd
		                else

			                echo "\e[5m"
				            echo  "\e[31mLa carpeta $directorio no existe\e[0m"
				            sleep 2

		                fi
		                ;;

                    0) clear
                        echo  "\e[96mREGRESAS AL MENU PRINCIPAL\e[0m"
                        sleep 2
                        break
                        ;;

                    *) clear
                        echo "\e[5m"
                        echo  "\e[31mOPCION NO VALIDA\e[0m"
                        sleep 2
                        ;;

                    esac

                done
            ;;

            2) while :
                do
                    clear

                         echo  "\e[92m
+----------------------------------------------------+
|                                                    |
|                 CARPETAS PRIVADAS                  |
|                                                    |
+----------------------------------------------------+
|                                                    |
| Pulsa [1] para crear carpeta privada               |
|                                                    |
| Pulsa [2] para eliminar carpeta privada            |
|                                                    |
| Pulsa [3] para mostrar los usuarios de las carpetas|
|                                                    |
| Pulsa [0] para regresar al menu principal          |
|                                                    |
+----------------------------------------------------+
\e[0m"
                        read opcion2

                        clear

                        case $opcion2 in

	                    1) clear
                                echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|               CREAR CARPETA PRIVADA              |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                    echo
                            echo  "\e[96mESTAS SON LAS CARPETAS PRIVADAS CREADAS\e[0m"
                            echo  "\e[96m------------------------------------------------------------\e[0m"
                            echo

                                ls /etc/media/samba/privado 1>&2

                            echo
                            echo  "\e[96m------------------------------------------------------------\e[0m"
                            echo
                            echo  "\e[93mRECUERDA QUE NECESITAS CREAR UN USUARIO Y AGREGARLO A ESTA CARPETA PARA ACCEDER A ESTE RECURSO\e[0m"
                            echo
			                echo  "\e[96mIntroduce el nombre de la carpeta privada a crear\e[0m"
			                echo

			                read directorio

			                if [ -d /etc/media/samba/privado/"$directorio" ]
			                then

				                echo "\e[5m"
					            echo  "\e[31mLa carpeta $directorio ya existe\e[0m"
					            sleep 2

			                else

				                groupadd $directorio > /dev/null 2>&1

                                if [ $? -ne 0 ]
                                then

                                    echo
                                    echo  "\e[93mNo use espacios para crear carpetas\e[0m"
                                    sleep 2

                                else

                                    echo
                                    echo  "\e[96mIntroduce un comentario para definir el recurso compartido. Ejemplo: DPTO de Informatica\e[0m"
                                    echo

                                    read comentario

				                    mkdir -p /etc/media/samba/privado/$directorio

				                    chgrp $directorio /etc/media/samba/privado/$directorio

				                    chmod 770 /etc/media/samba/privado/$directorio

                                    # Crea el fichero donde el usuario guarda los grupos a los que pertenece
                                    touch /etc/samba/grupos/$directorio

				                    echo "
[$directorio]
path = /etc/media/samba/privado/$directorio
comment = $comentario
browseable = yes
guest ok = no
writable = yes
create mode = 0770
directory mode = 0770
write list = @$directorio" >> /etc/samba/smb.conf

                                # Crea el fichero donde se almacena la configuración del recurso compartido
                                touch /etc/samba/recursos/$directorio.conf

                                echo "
[$directorio]
path = /etc/media/samba/privado/$directorio
comment = $comentario
browseable = yes
guest ok = no
writable = yes
create mode = 0770
directory mode = 0770
write list = @$directorio" >> /etc/samba/recursos/$directorio.conf

                                echo
	                            echo  "\e[96mLa carpeta privada $directorio ha sido creada\e[0m"
	                            sleep 2
                                systemctl restart smbd

			                    fi

                            fi
			                ;;

	                    2) clear
                                echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|               ELIMINAR CARPETA PRIVADA           |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                        echo
                                echo  "\e[96mESTAS SON LAS CARPETAS PRIVADAS CREADAS\e[0m"
                                echo  "\e[96m------------------------------------------------------------\e[0m"
                                echo

                                ls /etc/media/samba/privado 1>&2

                                echo
                                echo  "\e[96m------------------------------------------------------------\e[0m"
                                echo
			                    echo  "\e[96mIntroduce el nombre de la carpeta que quiere eliminar\e[0m"
			                    echo

		                        read directorio

			                    if [ -d /etc/media/samba/privado/$directorio ]
			                    then

                                    delgroup $directorio > /dev/null 2>&1

				                    rm -r /etc/media/samba/privado/$directorio

                                    # Guarda en la variable el número de línea del GRUPO DE TRABAJO
                                    linea=$(sed -n '/workgroup =/=' /etc/samba/smb.conf)

                                    # Guarda el nombre del GRUPO DE TRABAJO actual
                                    workgroup=$(sed -n ''$linea'p' /etc/samba/smb.conf | awk '{print $3}')

                                    # Borra el fichero de configuración de Samba
                                    rm /etc/samba/smb.conf

                                    # Borra el registro del recurso compartido
                                    rm /etc/samba/recursos/"$directorio".conf

                                    # Copia el fichero original de Samba
                                    cp /etc/samba/smb.conf.original /etc/samba/smb.conf

                                    # Borra la línea donde se encuentra el GRUPO DE TRABAJO del fichero original
                                    sed -i ''$linea'd' /etc/samba/smb.conf

                                    # Sustituye el nombre del GRUPO DE TRABAJO que viene por defecto por el que había antes, almacenado en la variable workgroup
                                    sed -i ''$linea'i\workgroup = '$workgroup'\' /etc/samba/smb.conf

                                    # Guarda la salida de todas las configuraciones de los recursos compartidos en el nuevo fichero de Samba
                                    cat /etc/samba/recursos/*.conf >> /etc/samba/smb.conf 2>&1

                                    # Elimina el registro que almacena los nombres de los usuarios pertenecientes al mismo
                                    rm -r /etc/samba/grupos/$directorio

				                    echo
				                    echo  "\e[96mLa carpeta  $directorio ha sido eliminada\e[0m"
				                    sleep 2

                                    systemctl restart smbd

			                    else

				                    echo "\e[5m"
					                echo  "\e[31mLa carpeta $directorio no existe\e[0m"
					                sleep 2

			                    fi
			            ;;


                        3) clear
                                echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|          USUARIOS DE CARPETAS PRIVADAS           |
|                                                  |
+--------------------------------------------------+
\e[0m"
                                echo
                                echo  "\e[96mESTAS SON LAS CARPETAS PRIVADAS CREADAS\e[0m"
                                echo  "\e[96m------------------------------------------------------------\e[0m"
                                echo

                                    ls /etc/media/samba/privado 1>&2

                                echo
                                echo  "\e[96m------------------------------------------------------------\e[0m"

                                echo  "\e[96mIntroduce el nombre de la carpeta\e[0m"
                                echo

                                read directorio

                                if [ -f /etc/samba/grupos/$directorio ]
                                then

                                    clear
                                    echo  "\e[93mPULSA Q PARA SALIR\e[0m"
                                    echo
                                    echo  "\e[96mUsuarios de la carpeta $directorio\e[0m"
                                    echo  "\e[96m---------------------------------------------------------\e[0m"
                                    echo
                                        less /etc/samba/grupos/$directorio

                                else

                                    echo "\e[5m"
                                    echo  "\e[31mLa carpeta $directorio no tiene usuarios o no existe\e[0m"
                                    sleep 2

                                fi
                        ;;

                        0) clear
                                echo  "\e[96mREGRESAS AL MENU PRINCIPAL\e[0m"
                                sleep 2
                                break
                                ;;

                        *) clear
                                echo "\e[5m"
                                echo  "\e[31mOPCION NO VALIDA\e[0m"
                                sleep 2
                                ;;

                        esac

                    done
                ;;

            3) while :
                do

                    clear
                    echo  "\e[92m
+---------------------------------------------------+
|                                                   |
|                  USUARIOS SAMBA                   |
|                                                   |
+---------------------------------------------------+
|                                                   |
| Pulsa [1] para listar usuarios samba              |
|                                                   |
| Pulsa [2] para crear usuario samba                |
|                                                   |
| Pulsa [3] para eliminar usuario samba             |
|                                                   |
| Pulsa [4] para agregar usuario a carpeta privada  |
|                                                   |
| Pulsa [5] para eliminar usuario de carpeta privada|
|                                                   |
| Pulsa [0] para regresar al menu principal         |
|                                                   |
+---------------------------------------------------+
\e[0m"
                        echo

                        read opcion2

                        echo

                            case $opcion2 in

		                    1) clear
                                    echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|              LISTAR USUARIOS SAMBA               |
|                                                  |
+--------------------------------------------------+
\e[0m"
			                    echo
                                echo  "\e[93mPULSA Q PARA SALIR\e[0m"
                                echo

                                # Lista usuario samba
				                pdbedit -L | less
			                    ;;

	                        2) clear
                                    echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|               CREAR USUARIO SAMBA                |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                         echo
			                     echo  "\e[93mIntroduce el nombre del usuario sin espacios\e[0m"
			                     echo

			                     read usuario

                                 # Filtra el nombre de usuario del fichero shadow
                                 cut -d : -f 1 /etc/shadow | grep -w $usuario > /dev/null 2>&1

					             if [ $? -eq 0 ]
					             then

                                     # Lista usuario samba
                                     pdbedit $usuario > /dev/null 2>&1

                                        if [ $? -eq 0 ]
                                        then

                                            echo "\e[5m"
                                            echo  "\e[31mEl usuario $usuario ya existe\e[0m"
                                            sleep 2

                                        else

                                            echo
                                            echo  "\e[96mIntroduce la contraseña del usuario $usuario\e[0m"
                                            echo

                                            smbpasswd -a $usuario 

                                            sleep 2
                                            systemctl restart smbd

                                        fi

                                  else

                                        # Crea usuario sin posiblidad de login en el sistema
						                useradd -s /usr/sbin/nologin $usuario > /dev/null 2>&1

                                        if [ $? -ne 0 ]
                                        then

                                            echo
                                            echo  "\e[93mNo use espacios en el nombre de usuario\e[0m"
                                            sleep 2

                                        else

                                            echo
							                echo  "\e[96mIntroduce la contraseña del usuario $usuario\e[0m"
							                echo

                                            # Crea usuario samba
								            smbpasswd -a $usuario

                                            sleep 2
                                            systemctl restart smbd

                                        fi

					              fi
					             ;;

	                        3) clear
                                    echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|              ELIMINAR USUARIO SAMBA              |
|                                                  |
+--------------------------------------------------+
\e[0m"
		                         echo
			                     echo  "\e[96mIntroduce el nombre del usuario que quiere eliminar\e[0m"
			                     echo

				                 read usuario

                                 # Lista usuario samba
				                 pdbedit $usuario > /dev/null 2>&1

					                if [ $? -eq 0 ]
					                then

                                        # Borra usuario de la base de datos de Samba
						                smbpasswd -x $usuario

                                        # Elimina usuario del sistema
						                userdel $usuario > /dev/null

							            echo
								        echo  "\e[96mEl usuario $usuario ha sido eliminado\e[0m"
								        sleep 2
                                        systemctl restart smbd

					                else

						                echo "\e[5m"
							            echo  "\e[31mEl usuario $usuario no existe\e[0m"
							            sleep 2

					                fi
					                ;;

		                    4) clear
                                     echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|               AGREGAR USUARIO SAMBA              |
|                         A                        |
|                  CARPETA PRIVADA                 |
|                                                  |
+--------------------------------------------------+
\e[0m"
                                 echo
			                     echo  "\e[93mEL USUARIO Y LA CARPETA PRIVADA DEBEN EXISTIR\e[0m"
                                 echo

				                 echo  "\e[96mIntroduce el nombre del usuario que quieres añadir a la carpeta privada\e[0m"
				                 echo

				                 read usuario

                                 # Lista usuario samba
				                 pdbedit $usuario > /dev/null 2>&1

				                    if [ $? -eq 0 ]
				                    then

					                     echo
                                         echo  "\e[96mESTAS SON LAS CARPETAS PRIVADAS CREADAS\e[0m"
                                         echo  "\e[96m------------------------------------------------------------\e[0m"
                                         echo

                                            ls /etc/media/samba/privado 1>&2

                                         echo
                                         echo  "\e[96m------------------------------------------------------------\e[0m"
                                         echo

					                     echo  "\e[96mIntroduce el nombre de la carpeta privada\e[0m"
                                         echo

					                    read directorio

						                    if [ -d /etc/media/privado/$directorio ]
						                    then

                                                # Añade nuevo grupo al usuario
							                    usermod -a -G $directorio $usuario > /dev/null 2>&1

                                                if [ $? -eq 0 ]
                                                then

							                        echo
								                    echo  "\e[96mEl usuario $usuario ha sido añadido a la carpeta privada $directorio\e[0m"

                                                    # Añade el nombre del usuario al fichero de la carpeta compartida
                                                    echo "$usuario" >> /etc/samba/grupos/$directorio

								                    sleep 2
                                                            systemctl restart smbd
                                                else

                                                    echo "\e[5m"
                                                    echo  "\e[31mEl nombre de usuario no es correcto, revise bien el nombre\e[0m"
                                                    sleep 2

                                                fi

                                            else

                                                echo "\e[5m"
                                                echo  "\e[31mLa carpeta $directorio no existe\e[0m"
                                                sleep 2

						                    fi

				                    else

                                        echo "\e[5m"
					                    echo  "\e[31mel usuario $usuario no existe\e[0m"
					                    sleep 2

                                    fi
				                    ;;

		                    5) clear
                                     echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|             ELIMINAR USUARIO SAMBA               |
|                       DE                         |
|                CARPETA PRIVADA                   |
|                                                  |
+--------------------------------------------------+
\e[0m"
				                echo  "\e[96mIntroduce el nombre del usuario que quieres eliminar de la carpeta privada\e[0m"
                                echo

				                read usuario

                                # Lista usuario samba
					            pdbedit $usuario > /dev/null 2>&1

						        if [ $? -eq 0 ]
						        then

							         echo
                                     echo  "\e[96mESTAS SON LAS CARPETAS PRIVADAS CREADAS\e[0m"
                                     echo  "\e[96m------------------------------------------------------------\e[0m"
                                     echo

                                        ls /etc/media/samba/privado 1>&2

                                     echo
                                     echo  "\e[96m------------------------------------------------------------\e[0m"
                                     echo
							         echo  "\e[96mIntroduce el nombre de la carpeta privada\e[0m"
                                     echo

							         read directorio

							         if [ -d /etc/media/samba/privado/$directorio ]
							         then

                                         # Filtra el nombre de usuario del fichero
                                         grep -w $usuario /etc/samba/grupos/$directorio > /dev/null 2>&1

                                         if [ $? -eq 0 ]
                                         then

                                             # Borra grupo al que pertenecía el usuario
								             deluser $usuario $directorio > /dev/null 2>&1

                                            echo
                                            echo  "\e[96mEl usuario $usuario ha sido eliminado de la carpeta privada $directorio\e[0m"

                                            # Guarda el número de línea que coincide con el usuario
                                            linea=$(sed -n '/'$usuario'/=' /etc/samba/grupos/$directorio)

                                            # Borra la línea donde se encuentra el valor de la variable $línea
                                            sed -i ''$linea'd' /etc/samba/grupos/$directorio

                                            sleep 2
                                            systemctl restart smbd

                                         else

                                             echo "\e[5m"
                                             echo  "\e[31mEl usuario no pertenece no este recurso compartido\e[0m"
                                             sleep 2

                                         fi



                                     else

                                        echo "\e[5m"
                                        echo  "\e[31mLa carpeta privada $directorio no existe\e[0m"
                                        sleep 2

							         fi

						        else

							        echo "\e[5m"
							        echo  "\e[31mEl usuario $usuario no existe\e[0m"
							        sleep 2

						        fi
						        ;;

                          0) clear
                                echo
                                     echo  "\e[96mREGRESAS AL MENU PRINCIPAL\e[0m"
                                     sleep 2
                                     break
                                     ;;

                          *) clear
                                echo "\e[5m"
                                echo  "\e[31mOPCION NO VALIDA\e[0m"
                                sleep 2
                                ;;

                        esac

                    done
                ;;

            4) while :
                do
                    clear

                    echo  "\e[92m
+--------------------------------------------------------+
|                                                        |
|                    RECURSOS SAMBA                      |
|                                                        |
+--------------------------------------------------------+
|                                                        |
| Pulsa [1] para ver recursos compartidos                |
|                                                        |
| Pulsa [2] para ver las conexiones actuales             |
|                                                        |
| Pulsa [3] para cambiar el GRUPO DE TRABAJO             |
|                                                        |
| Pulsa [0] para regresar al menu principal              |
|                                                        |
+--------------------------------------------------------+
\e[0m"
                    echo

                    read opcion2

                    case $opcion2 in

		            1) clear
                            echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|               RECURSOS COMPARTIDOS               |
|                                                  |
+--------------------------------------------------+
\e[0m"
                            echo
                            echo  "\e[93mPULSA Q PARA SALIR\e[0m"
                            echo
                            # Muestra los recursos compartidos del servidor
				            smbtree | less
				            ;;


                    2) clear
                            echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|               CONEXIONES ACTUALES                |
|                                                  |
+--------------------------------------------------+
\e[0m"
                            echo
                            echo  "\e[93mPULSA Q PARA SALIR\e[0m"
                            echo
                            # Muestra los clientes que se encuentran conectados al servidor
                            smbstatus | less
                            ;;

                    3) clear
                            echo  "\e[92m
+--------------------------------------------------+
|                                                  |
|                 CAMBIAR NOMBRE                   |
|                       DEL                        |
|                GRUPO DE TRABAJO                  |
|                                                  |
+--------------------------------------------------+
\e[0m"
                            echo
                            # Guarda el valor de la línea
                            linea=$(sed -n '/workgroup =/=' /etc/samba/smb.conf)

                            # Guarda el nombre del actual GRUPO DE TRABAJO
                            workgroup=$(sed -n ''$linea'p' /etc/samba/smb.conf | awk '{print $3}')

		                    echo  "\e[96mEL nombre del GRUPO DE TRABAJO es $workgroup\e[0m"
		                    echo
                            echo  "\e[96mIntroduce el nuevo nombre para el GRUPO DE TRABAJO\e[0m"
                            echo

			                read nuevo

                            # Pasa el valor de la variable $nuevo a mayúsculas
                            mayus=$(echo $nuevo | awk '{print toupper ($0)}')

			                echo

                            # Cambia el nuevo nombre de GRUPO DE TRABAJO en el fichero de configuración de Samba
                            sed -i 's/'$workgroup'/'$mayus'/' /etc/samba/smb.conf

                            echo
			                echo  "\e[96mEl GRUPO DE TRABAJO anterior era $workgroup y ha sido sustituido por $mayus\e[0m"
			                sleep 4
                                    systemctl restart smbd
			                ;;

                    0) clear
			                echo  "\e[96mREGRESAS AL MENU PRINCIPAL\e[0m"
		                    sleep 2
			                break
			                ;;

		            *) clear
			                echo "\e[5m"
			                echo  "\e[31mOPCION NO VALIDA\e[0m"
			                sleep 2
			                ;;

	                esac

                done
            ;;

            0) clear
                    echo  "\e[96mHASTA LA PROXIMA\e[0m"
                    sleep 2
                    break
                    ;;

            *) clear
                    echo "\e[5m"
                    echo  "\e[31mOPCION NO VALIDA\e[0m"
                    sleep 2
                    ;;

        esac

    done
clear

systemctl restart smbd

exit 0


