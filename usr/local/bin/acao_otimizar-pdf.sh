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


# Objetivo:

# Converter arquivos PDF para uma versão mais compacta/otimizada (ideal para leitura em 
# ebook readers), salvando-os em uma pasta chamada otimizado.


# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-scripts-atualizados-02-7-adicionado-mais-3/75870


# Trocado o kdialog por yad


clear

# ----------------------------------------------------------------------------------------

# Verificar se yad está instalado

if ! command -v yad &> /dev/null
then

    echo -e "\nErro: yad não está instalado. \n" >&2

    exit 1
fi

# ----------------------------------------------------------------------------------------

# Verificar se ps2pdf está instalado

if ! command -v ps2pdf &> /dev/null
then

    yad --center --error --title="Erro" --text="ps2pdf não está instalado.\n" --buttons-layout=center --button=OK:0 2>/dev/null

    exit 2
fi

# ----------------------------------------------------------------------------------------

# Cria um diretório chamado otimizado, se ele ainda não existir (-p impede erro se a 
# pasta já existe).

mkdir -p otimizado

# ----------------------------------------------------------------------------------------

# arq=(`basename -a "$@"`)

# for j in "$arq" ; do ps2pdf -dPDFSETTINGS=/ebook "$j" otimizado/"$j"; done




# Loop para otimizar os arquivos passados como argumentos

for arquivo in "$@"; do

    base=$(basename "$arquivo")

    destino=otimizado/"$base"

    # Otimizar com ps2pdf

    ps2pdf -dPDFSETTINGS=/ebook "$arquivo" "$destino"

done

# ----------------------------------------------------------------------------------------

# Mostrar mensagem de sucesso com yad

yad --center --info --title="Otimização PDF" --text="Arquivos otimizados e salvos em:\n\n $PWD/otimizado" --buttons-layout=center --button=OK:0 2>/dev/null


# ----------------------------------------------------------------------------------------

exit 0


