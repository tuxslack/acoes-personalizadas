#!/bin/bash
#
# Autor:       Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Colaboração: Adriano        - https://plus.diolinux.com.br/u/swatquest
# Data:        02/08/2025 as 16:54:24
# Homepage:    https://github.com/tuxslack/acoes-personalizadas
# Licença:     MIT
#
# Usa no menu de service do Thunar.
#
# ~/.config/Thunar/uca.xml


# Trocado o kdialog por yad

# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-scripts-atualizados-02-7-adicionado-mais-3/75870


clear

# ----------------------------------------------------------------------------------------

# Verifica se o yad está instalado

if ! command -v yad &> /dev/null; then

    echo -e "\nErro: yad não está instalado. \n"

    exit 1
fi

# ----------------------------------------------------------------------------------------

# Gera uma lista com os hashes informados

hash=("md5sum" "sha256sum" "sha512sum")

for i in "${hash[@]}"; do

    echo "#####################[ $i ]#####################" | tr '[a-z]' '[A-Z]'

    $i "$@"

done > /tmp/khash.txt

# ----------------------------------------------------------------------------------------

# Exibe o resultado em uma janela com yad

yad --center \
    --text-info \
    --title="Resultado dos Hashes" \
    --filename="/tmp/khash.txt" \
    --buttons-layout=center \
    --button=Fechar:0 \
    --width="1024" --height="600" \
    2>/dev/null

# ----------------------------------------------------------------------------------------

# Apaga os arquivos temporários criados

rm -f /tmp/khash.txt

# ----------------------------------------------------------------------------------------

exit 0

