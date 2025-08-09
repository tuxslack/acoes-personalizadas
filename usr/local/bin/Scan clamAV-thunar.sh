#!/bin/bash

# Adaptado do nautilus-scripts do Yirt para o Thunar

# Verifique pasta ou arquivos selecionados em busca de vírus.


# O ClamAV possui uma ótima interface gráfica chamada ClamTK.

# ClamTk

# https://www.linuxquestions.org/questions/linux-newbie-8/using-clamscan-in-a-nemo-context-menu-4175724896/
# https://www.vivaolinux.com.br/topico/ClamAV/Como-saber-onde-esta-o-virus
# https://pt.linux-console.net/?p=11675


logo="/usr/share/icons/extras/clamav.png"

# ----------------------------------------------------------------------------------------


# Verificar se os programas estão instalados

clear



which yad             1> /dev/null 2> /dev/null || { echo "Programa Yad não esta instalado."      ; exit ; }




which clamscan        1> /dev/null 2> /dev/null || { yad \
--center \
--window-icon "$logo" \
--image=dialog-error \
--timeout="10" \
--no-buttons \
--title "Aviso" \
--text "Programa ClamAV não esta instalado." \
--width="450" --height="100" 2>/dev/null   ; exit ; }


which notify-send     1> /dev/null 2> /dev/null || { yad \
--center \
--window-icon "$logo" \
--image=dialog-error \
--timeout="10" \
--no-buttons \
--title "Aviso" \
--text "Programa notify-send não esta instalado." \
--width="450" --height="100" 2>/dev/null   ; exit ; }


# ----------------------------------------------------------------------------------------

# Navegue até o diretório do arquivo selecionado

cd "$PWD"


# Remove o arquivo temporário

rm -Rf /tmp/clamav.log

# Execute o Clamscan no(s) arquivo(s) selecionado(s) e envie os resultados para o arquivo temporário

# Seria $1 ou $@

# -i --bell


# Certifique-se de que o comando antes da | está retornando algum resultado para que o 
# yad possa exibir a barra de progresso pulsante corretamente.

clamscan --max-scansize=4000M --max-filesize=4000M -l /tmp/clamav.log -r -v   "$@" | \
        yad  \
        --center \
        --window-icon "$logo" \
        --progress \
        --title "ClamAV" \
        --height="100" --width="500" \
        --buttons-layout=center \
        --button=Cancelar:252 \
        --button=OK:0 \
        --progress-text="Escaneando arquivos..." \
        --pulsate  \
        --auto-close \
        --auto-kill


if [ $? -eq 252 ]; then

     exit
     
fi


# O sinalizador -i suprime tudo, exceto os arquivos infectados, mas eventualmente 
# imprimirá os resultados em seu terminal.

# O sinalizador -r torna a varredura recursiva.


# O sinalizador --max-scansize= define a quantidade máxima de dados que você deseja que o 
# ClamAV rastreie. O máximo é 4000M. Tenha em mente que estes são os dados reais que estão 
# sendo lidos, não o tamanho dos arquivos.

# O tamanho do arquivo é o próximo sinalizador. --max-filesize= define o tamanho máximo 
# dos arquivos que você deseja que o ClamAV verifique. Isto é para arquivos individuais. 
# Novamente, o limite é 4000M.



# Mostra os resultados da verificação em uma caixa de diálogo

cat /tmp/clamav.log | yad \
--center \
--window-icon "$logo" \
--title "Resultados da verificação do ClamAV" \
--text-info \
--fontname "mono 10" \
--buttons-layout=center \
--button=Cancelar:252 \
--button=OK:0 \
--width="1200" --height="900"  \
2> /dev/null


if [ $? -eq 252 ]; then

     exit
     
fi



# Remove o arquivo temporário

# rm -Rf /tmp/clamav.log



# gtk-dialog-info

notify-send \
-i "$logo"   \
-t 200000 "ClamAV" "
Arquivo de log em: 

/tmp/clamav.log
"

exit 0

