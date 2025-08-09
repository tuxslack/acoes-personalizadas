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
# Esse script pega um arquivo como argumento, mostra informações detalhadas sobre ele, 
# especialmente as permissões (tanto numéricas quanto em palavras fáceis de entender), e 
# apresenta isso numa janela gráfica para o usuário.
#
#
# https://plus.diolinux.com.br/t/scripts-criados-para-o-dolphin-kde-6-4-3-criou-algum-informe-aqui-scripts-atualizados-02-7-adicionado-mais-3/75870
#

# Trocado o kdialog por yad

clear

# ----------------------------------------------------------------------------------------

# Verifica se yad está instalado

if ! command -v yad &> /dev/null; then

    echo -e "\nErro: yad não está instalado. \n" >&2

    exit 1
fi

# ----------------------------------------------------------------------------------------

# Verifica se um arquivo foi passado

if [ -z "$1" ]; then

    yad --center --error --text="Nenhum arquivo fornecido!"  --buttons-layout=center --button=OK:0 2>/dev/null

    exit 1

elif [ ! -e "$1" ]; then

    yad --center --error --text="Arquivo não encontrado: $1" --buttons-layout=center --button=OK:0 2>/dev/null

    exit 1

fi

# ----------------------------------------------------------------------------------------

TMPFILE=$(mktemp)

# Informações básicas

stat --printf " tipo=(%F)\n arquivo=%n\n usuário=%U\n grupo=%G\n permissão=%a %A\n" "$1" > "$TMPFILE"

permissao_num=$(stat --printf "%a\n" "$1")
nproprietario="${permissao_num:0:1}"
ngrupos="${permissao_num:1:1}"
noutros="${permissao_num:2:1}"

nomepro=$(stat --printf "%U" "$1")
nomegrupo=$(stat --printf "%G" "$1")


# Função de descrição

perm_texto() {

    local nivel="$1"
    local valor="$2"
    local nome="$3"

    case "$valor" in

        7) echo "$nivel $nome pode ler, escrever e executar";;
        6) echo "$nivel $nome pode ler e escrever";;
        5) echo "$nivel $nome pode ler e executar";;
        4) echo "$nivel $nome pode ler";;
        3) echo "$nivel $nome pode escrever e executar";;
        2) echo "$nivel $nome pode escrever";;
        1) echo "$nivel $nome pode executar";;
        0) echo "$nivel $nome não tem permissão alguma";;

    esac
}


{
    echo -e "\n[[[[ Permissões legíveis para humanos ]]]]\n"
    perm_texto "O proprietário" "$nproprietario" "$nomepro"
    perm_texto "O grupo" "$ngrupos" "$nomegrupo"
    perm_texto "Os outros" "$noutros" ""

} >> "$TMPFILE"


# ----------------------------------------------------------------------------------------

# Exibe na interface gráfica

yad --center --title="Informações do Arquivo"  --text-info --filename="$TMPFILE" --buttons-layout=center --button=OK:0 --width="512" --height="400"  2>/dev/null

rm -f "$TMPFILE"

# ----------------------------------------------------------------------------------------

exit 0

