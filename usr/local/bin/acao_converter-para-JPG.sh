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
# Converter PDF para JPG
# 
#
# Objetivo:
#
# Extrair imagens (no formato JPEG) das páginas de arquivos PDF passados como argumentos, 
# salvando-as em uma pasta chamada "Imagens exportadas".
#
#
# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-scripts-atualizados-02-7-adicionado-mais-3/75870


clear


# ----------------------------------------------------------------------------------------

# Função para verificar se um comando existe

verificar_comando() {

    if ! command -v "$1" &> /dev/null; then

        yad --center \
            --title="Dependência ausente" \
            --error \
            --text="O programa <b>$1</b> não está instalado.\n\n" \
            --buttons-layout=center \
            --button="OK" \
            --width="400" \
            2>/dev/null

        exit 1
    fi
}


# Verifica dependências

verificar_comando "yad"

verificar_comando "pdftoppm" 



# poppler-utils é um pacote que contém um conjunto de ferramentas de linha de comando para 
# manipular arquivos PDF, baseadas na biblioteca Poppler (uma biblioteca para renderização 
# de PDF).


# No Void Linux, o pacote equivalente ao poppler-utils é chamado poppler.

# sudo xbps-install -S poppler

#  xbps-query -l | grep poppler
# ii libpoppler-25.06.0_1                             PDF rendering library - poppler runtime library
# ii poppler-25.06.0_1                                PDF rendering library
# ii poppler-cpp-25.06.0_1                            PDF rendering library - C++ bindings
# ii poppler-data-0.4.12_1                            Encoding data for the poppler PDF rendering library
# ii poppler-glib-25.06.0_1                           PDF rendering library - GLib bindings
# ii poppler-qt6-25.06.0_1                            PDF rendering library - Qt6 bindings

# O comando que precisa verificar é pdftoppm, que pertence ao pacote poppler no Void Linux.

# O pacote instalado poppler traz vários binários, como pdftoppm, pdftotext, pdfinfo etc., 
# mas não existe um comando chamado poppler.



# Debian

# verificar_comando "poppler-utils"



# ----------------------------------------------------------------------------------------


# Cria a pasta de saída, se não existir

output_dir="Imagens exportadas"

mkdir -p "$output_dir"


# ----------------------------------------------------------------------------------------

# Verifica se ao menos um argumento foi passado

if [ "$#" -eq 0 ]; then

    yad --center \
        --title="Erro" \
        --error \
        --text="Nenhum arquivo PDF foi fornecido.\n\nUso: $0 arquivo1.pdf [arquivo2.pdf ...]" \
        --buttons-layout=center \
        --button="OK" \
        --width="400" \
        2>/dev/null

    exit 1

fi

# ----------------------------------------------------------------------------------------

# Loop sobre todos os PDFs passados como argumento

for pdf in "$@"; do


    # Verifica se o arquivo existe

    if [ ! -f "$pdf" ]; then

        yad --center \
            --title="Arquivo não encontrado" \
            --error \
            --text="O arquivo não foi encontrado:\n<b>$pdf</b>" \
            --buttons-layout=center \
            --button="OK" \
            --width="400" \
            2>/dev/null

        continue

    fi


    # Extrai o nome base (sem extensão e caminho)

    nome_base=$(basename "$pdf" .pdf)

    # Executa a conversão

    pdftoppm -jpeg "$pdf" "$output_dir/${nome_base}"


    # Verifica se a conversão foi bem-sucedida

    if [ $? -eq 0 ]; then

        yad --center \
            --title="Conversão bem-sucedida" \
            --info \
            --text="✔ Imagens salvas em:\n<b>$output_dir/${nome_base}-*.jpg</b>" \
            --buttons-layout=center \
            --button="OK" \
            --width="400" \
            2>/dev/null


    else

        yad --center \
            --title="Erro na conversão" \
            --error \
            --text="❌ Falha ao converter o arquivo:\n<b>$pdf</b>" \
            --buttons-layout=center \
            --button="OK" \
            --width="400" \
            2>/dev/null

    fi

done


# ----------------------------------------------------------------------------------------


exit 0

