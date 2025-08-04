#!/bin/bash

# Data: 13/04/2025 as 01:50:17


# Quando você clicar com o botão direito em um arquivo no Thunar, verá a opção 
# "Verificar Hashes" e ela abrirá uma janela com os hashes calculados.

# Selecione vários arquivos no Thunar com Ctrl ou Shift → clique com o botão direito → Verificar Hashes.

# Ele:

#     Calcula todos os hashes,

#     Exibe tudo em uma janela,

#     E salva o resultado em ~/hash_resultados_YYYY-MM-DD_HH-MM-SS.txt

# ----------------------------------------------------------------------------------------

clear


# Verifica se yad está instalado

if ! command -v yad &> /dev/null; then

    # yad --center --error --text="O YAD não está instalado. Instale com:\nsudo apt install yad"

    echo "O YAD não está instalado."

    exit 1
fi

# Verifica se ao menos um arquivo foi passado

if [[ $# -eq 0 ]]; then

    yad --center --error --text="Nenhum arquivo foi selecionado."

    exit 1
fi

# Arquivo de saída (pode mudar o caminho se quiser salvar em outro lugar)

DATA=$(date +"%Y-%m-%d_%H-%M-%S")
OUTFILE="$HOME/hash_resultados_$DATA.txt"

# Início do conteúdo do resultado

RESULTADOS=""

for ARQUIVO in "$@"; do
    if [[ -f "$ARQUIVO" ]]; then

        # Calcula os hashes

        MD5=$(md5sum "$ARQUIVO" | awk '{print $1}')
        SHA1=$(sha1sum "$ARQUIVO" | awk '{print $1}')
        SHA224=$(sha224sum "$ARQUIVO" | awk '{print $1}')
        SHA256=$(sha256sum "$ARQUIVO" | awk '{print $1}')
        SHA384=$(sha384sum "$ARQUIVO" | awk '{print $1}')
        SHA512=$(sha512sum "$ARQUIVO" | awk '{print $1}')

        RESULTADOS+="\nArquivo: $ARQUIVO\n\n"
        RESULTADOS+="MD5:    $MD5\n"
        RESULTADOS+="SHA1:   $SHA1\n"
        RESULTADOS+="SHA224: $SHA224\n"
        RESULTADOS+="SHA256: $SHA256\n"
        RESULTADOS+="SHA384: $SHA384\n"
        RESULTADOS+="SHA512: $SHA512\n\n"
    else
        RESULTADOS+="[ERRO] Arquivo inválido ou não encontrado: $ARQUIVO\n\n"
    fi
done



# Do jeito que está, mesmo se você fechar a janela no "X", o script ainda salva o arquivo, 
# porque o echo roda logo depois da janela do YAD, sem verificar a ação do usuário.

# Ajustado: agora só salvar o .txt se o usuário clicar no botão "Salvar". Se ele 
# fechar no "X", nada será salvo.


# Exibe os resultados com YAD

yad --center --title="Resultados dos Hashes" --width="1200" --height="700" \
--text-info --filename=<(echo -e "$RESULTADOS") --button="Salvar em $OUTFILE":0


RETORNO=$?

# Se clicou no botão "Salvar", salva o arquivo

if [[ "$RETORNO" -eq 0 ]]; then

    # Salva no arquivo .txt

    echo -e "$RESULTADOS" > "$OUTFILE"
fi


exit 0

