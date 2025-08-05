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
#
#
# Converter grupo imagens para PDF
#
# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-scripts-atualizados-02-7-adicionado-mais-3/75870

# Usar o yad em vez do kdialog

# ServiceMenu do Dolphin


clear

# ----------------------------------------------------------------------------------------

# Verifica se o 'yad' está instalado

if ! command -v yad &> /dev/null; then

  echo -e "\nyad não está instalado. \n"

  exit 1

fi

# ----------------------------------------------------------------------------------------

# Verifica se o 'convert' está disponível

if ! command -v convert &> /dev/null; then

  yad --center --error --title="Erro" --text="'convert' (ImageMagick) não está instalado.\n" --buttons-layout=center --button=OK:0 2>/dev/null

  exit 1

fi

# ----------------------------------------------------------------------------------------

# Solicita o nome do arquivo

nomedoarquivo=$(yad --center --entry --title="Input dialog" --text="Insira o nome do arquivo:" --entry-text "nomepadrão" 2>/dev/null)


# Define nome de saída

if [ -n "$nomedoarquivo" ]; then

  saida="${nomedoarquivo}.pdf"

else

  saida="nomepadrão.pdf"

fi

# Executa conversão

convert "$@" "$saida"


# ----------------------------------------------------------------------------------------

# Notifica conclusão

yad --center --info --title="Concluído" --text="Arquivo criado:\n$saida" --buttons-layout=center --button=OK:0  2>/dev/null  # --width="400"

# ----------------------------------------------------------------------------------------


exit 0

