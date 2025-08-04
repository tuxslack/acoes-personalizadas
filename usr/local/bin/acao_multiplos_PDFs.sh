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
# Multiplas imagens para multiplos PDFs
#
# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-scripts-atualizados-02-7-adicionado-mais-3/75870


# Trocado o kdialog por yad


clear


# ----------------------------------------------------------------------------------------

# Verifica se o 'yad' está instalado

if ! command -v yad &> /dev/null; then

  echo -e "\nyad não está instalado. \n"

  exit 1

fi

# ----------------------------------------------------------------------------------------

# Verifica se o 'mogrify' (ImageMagick) está instalado

if ! command -v mogrify &> /dev/null; then

  yad --center --error --title="Erro" --text="mogrify' (ImageMagick) não está instalado. \n" --buttons-layout=center  --button=OK:0  2>/dev/null

  exit 1

fi

# ----------------------------------------------------------------------------------------

# Exibe aviso de segurança usando yad

yad --center \
    --title="⚠️ Atenção: Cuidado ao usar 'mogrify'" \
    --buttons-layout=center \
    --button="Entendi e Continuar":0 \
    --button="Cancelar":1 \
    --width="500" --height="200" \
    2>/dev/null \
    --text="⚠️ *CUIDADOS AO USAR 'mogrify'* ⚠️

- O comando 'mogrify' sobrescreve arquivos de saída se já existirem com o mesmo nome e extensão.
- Ele modifica os arquivos diretamente no diretório atual.
- Diferente de 'convert', que permite salvar com outro nome ou em outra pasta.
  
👉 Certifique-se de estar em um diretório seguro ou de ter backup dos arquivos antes de continuar."


# Se o usuário clicar em "Cancelar", o código de saída será 1

if [[ $? -ne 0 ]]; then

    echo "Operação cancelada pelo usuário."

    exit 1

fi

# ----------------------------------------------------------------------------------------

# O comando mogrify é parte do pacote ImageMagick

mogrify -format pdf "$@"


# Converte os arquivos de imagem especificados para o formato PDF.

# O original não é removido, a não ser que você adicione opções para isso.


# ⚠️ Cuidados:

#    O mogrify sobrescreve arquivos de saída se já existirem com o mesmo nome e extensão.

#    Ele modifica os arquivos diretamente no diretório atual — diferente do convert, que 
# gera saída em outro nome.


# ----------------------------------------------------------------------------------------

exit 0

