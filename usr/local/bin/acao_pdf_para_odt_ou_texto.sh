#!/bin/bash
#
# Autor:       Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Colaboração: Adriano        - https://plus.diolinux.com.br/u/swatquest
# Data:        06/08/2025 as 03:58:05
# Homepage:    https://github.com/tuxslack/acoes-personalizadas
# Licença:     MIT
#
# Usa no menu de service do Thunar.
#
# ~/.config/Thunar/uca.xml


# Trocado o kdialog por yad

# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-atualizados-02-7-adicionado-mais-1-ocr-pdf-total-9/75870/20


logo=""

clear



# ----------------------------------------------------------------------------------------

# Verifica se o yad está instalado

if ! command -v yad &> /dev/null; then

    echo -e "\nErro: yad não está instalado. \n"

    exit 1
fi

# ----------------------------------------------------------------------------------------


# Verifica se os comandos necessários estão disponíveis

for cmd in notify-send pdftotext libreoffice iconv; do

    if ! command -v "$cmd" > /dev/null 2>&1; then

        yad --center --error --title="Erro" --text="O comando $cmd não está instalado ou não está no PATH.\n" --buttons-layout=center --button=OK:0 2>/dev/null

        exit 2

    fi

done

# ----------------------------------------------------------------------------------------

# Usa YAD para criar uma radiolist com duas opções

# O padrão é "Tipo odt" (pré-selecionado com TRUE).

tipoarquivo=$(yad \
  --center \
  --list \
  --title="Selecione o tipo de arquivo" \
  --radiolist \
  --column="Selecionado" --column="ID" --column="Tipo" \
  TRUE 2 'Converter para ODT' \
  FALSE 1 'Extrair texto' \
  --separator=" " \
  --buttons-layout=center \
  --button=OK:0  \
  --height="200" --width="400" \
  2>/dev/null | awk '{print $2}')



# Se o usuário cancelar ou fechar a janela, sai

if [ $? -ne 0 ]; then

    exit 3

fi


# ----------------------------------------------------------------------------------------


# Processa os arquivos conforme a escolha:


# Conta o total de arquivos
total=$#
atual=0

# Função para atualizar a barra de progresso
(
for arquivo in "$@"; do
    atual=$((atual + 1))
    progresso=$((atual * 100 / total))

    echo "# Processando: $arquivo"



if [ "$tipoarquivo" = "1" ]; then


    # Converte o PDF em texto usando pdftotext.


# Estava extraindo texto de PDF, com caracteres estranhos ou "?" no lugar de letras 
# acentuadas, como ç, ã, é etc.
# 
# 🧠 Causa do problema
# 
# Isso geralmente acontece por:
# 
#     Problemas de codificação de caracteres (ex: o PDF está em UTF-8, mas o terminal ou 
# o visualizador espera ISO-8859-1, ou vice-versa).
# 
#     PDFs que usam fontes incorporadas personalizadas ou protegidas, que dificultam a 
# extração correta.
# 
#     Limitações do pdftotext em interpretar certos layouts ou idiomas.


        pdftotext -enc Latin1 "$arquivo" > /dev/null 2>&1

        # pdftotext -enc UTF-8 "$arquivo" > /dev/null 2>&1



        # Adicionar tratamento de erro com yad torna o script mais amigável e informativo.

        if [ $? -ne 0 ]; then

            echo -e "\nErro ao extrair texto de: $arquivo \n"

            yad --center --title="Erro ao extrair texto" --text="Falha ao processar o arquivo:\n$arquivo" --buttons-layout=center --button=OK:0 2>/dev/null

        fi



# Usar iconv para converter o encoding (se necessário)

# Se o arquivo .txt já foi gerado, mas com acentuação errada, tente converter:

# iconv -f ISO-8859-1 -t UTF-8 "$arquivo" -o "$arquivo"_corrigido.txt

# Ou o inverso:

# iconv -f UTF-8 -t ISO-8859-1 "$arquivo" -o "$arquivo"_corrigido.txt

# Você pode experimentar para ver qual combina com a codificação original.




elif [ "$tipoarquivo" = "2" ]; then


    # Para cada arquivo:

    #    Usa o LibreOffice em modo headless (sem interface gráfica).

    #    Converte o PDF para ODT.


        libreoffice --headless --infilter="writer_pdf_import" \
        --convert-to odt "$arquivo" --outdir . > /dev/null 2>&1


        # Adicionar tratamento de erro com yad torna o script mais amigável e informativo.

        if [ $? -ne 0 ]; then

            echo -e "\nErro ao converter: $arquivo \n"

            yad --center --title="Erro na conversão" --text="Falha ao converter o arquivo:\n$arquivo" --buttons-layout=center --button=OK:0 2>/dev/null

        fi



fi



    echo $progresso

    sleep 0.2  # pequena pausa para suavizar a barra

done
) | yad --center --progress --title="Processando arquivos" \
    --text="Aguarde enquanto os arquivos são processados..." \
    --buttons-layout=center --button=OK:0 2>/dev/null \
    --percentage=0 --auto-close --auto-kill



# 🧠 Como funciona
# 
#     A barra de progresso é alimentada por um bloco entre parênteses (...) que envia dados via echo.
# 
#     echo "# texto" atualiza a mensagem exibida.
# 
#     echo número atualiza a porcentagem da barra.
# 
#     --auto-close fecha a janela ao atingir 100%.
# 
#     --auto-kill encerra o processo se a janela for fechada manualmente.


# ----------------------------------------------------------------------------------------


# Mensagem final

# yad --center --title="Concluído" --text="Todos os arquivos foram processados." --buttons-layout=center --button=OK:0 2>/dev/null



# Notificação final

notify-send \
-i "$logo"   \
-t 200000 "Concluído" "
Processamento finalizado.
"

# ----------------------------------------------------------------------------------------


exit 0

