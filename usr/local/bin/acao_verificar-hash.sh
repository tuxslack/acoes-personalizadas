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


# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-scripts-atualizados-02-7-adicionado-mais-3/75870


# Trocado o kdialog por yad


clear



# ==== Verifica dependências ====

# ----------------------------------------------------------------------------------------

# Verifica se yad está instalado

if ! command -v yad &> /dev/null; then

    echo -e "\nErro: yad não está instalado. \n" >&2

    exit 1
fi

# ----------------------------------------------------------------------------------------

comandos=("md5sum" "sha256sum" "sha512sum")

for cmd in "${comandos[@]}"; do

    if ! command -v "$cmd" >/dev/null 2>&1; then

        yad --center \
            --error \
            --title="Erro de dependência" \
            --text="O comando <b>$cmd</b> não está instalado ou não está disponível no PATH." \
            --buttons-layout=center \
            --button=OK:0 \
            2>/dev/null

        exit 1

    fi

done


# ----------------------------------------------------------------------------------------


# ==== Escolhe o tipo de hash ====

hash=$(yad \
  --center \
  --list \
  --title="Selecione o hash a verificar:" \
  --radiolist \
  --column="" --column="Hash" \
  TRUE sha256sum FALSE md5sum FALSE sha512sum \
  --separator=" " \
  --buttons-layout=center \
  --button=OK:0  \
  --height="200" --width="400" \
  2>/dev/null | awk '{print $1}')

if [ -z "$hash" ]; then

    exit 0  # Cancelado

fi

# ----------------------------------------------------------------------------------------

# ==== Nome do arquivo ISO (passado como argumento) ====

if [ -z "$1" ]; then

    yad --center --error --title="Erro" --text="Nenhum arquivo ISO foi passado como argumento." --buttons-layout=center --button=OK:0 2>/dev/null

    exit 1
fi

# ----------------------------------------------------------------------------------------

nomearquivo=$(basename "$1")


# ==== Seleciona arquivo de hash ====

arquivoselecionado=$(yad --file --title="Selecione o arquivo de hash" --buttons-layout=center --button=OK:0 2>/dev/null)

if [ -z "$arquivoselecionado" ]; then

    exit 0  # Cancelado

fi

# ----------------------------------------------------------------------------------------

# ==== Salva conteúdo em arquivo temporário ====

cat "$arquivoselecionado" | tee /tmp/arquivohash.txt >/dev/null


# ==== Verifica hash ====

"$hash" --ignore-missing -c /tmp/arquivohash.txt | grep -i "$nomearquivo" | tee /tmp/saída.txt >/dev/null


# ==== Mostra o resultado ====

if [ ! -s /tmp/saída.txt ]; then

    yad --center \
        --text-info \
        --title="Erro na verificação" \
        --text="Aconteceu algo errado.\nVerifique se o arquivo é compatível com a imagem ISO." \
        --buttons-layout=center \
        --button=OK:0 \
        --width="500" --height="200" \
        2>/dev/null
else

    yad --center \
        --text-info \
        --title="Resultado da verificação" \
        --filename=/tmp/saída.txt \
        --buttons-layout=center \
        --button=OK:0 \
        --width="512" --height="200" \
        2>/dev/null

fi

# ----------------------------------------------------------------------------------------

# ==== Limpeza ====

rm -f /tmp/arquivohash.txt /tmp/saída.txt

# ----------------------------------------------------------------------------------------


exit 0

