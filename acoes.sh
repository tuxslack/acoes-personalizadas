#!/usr/bin/env bash
#
# Autor:       Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Colaboração: 
# Data:        09/08/2025 as 20:40:02
# Homepage:    https://github.com/tuxslack/acoes-personalizadas
# Licença:     MIT


ZIP="acoes-personalizadas-master.zip"

# ----------------------------------------------------------------------------------------

# Uso de cores para destacar

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# ------------------------------------------------------------------------

# 🔧 Função de remoção automatizada

remover() {

  clear
  
  echo -e "\n${GREEN}🧹 Iniciando remoção... ${RESET} \n"


BASE="${ZIP%.zip}"

unzip -Z1 "$ZIP" | grep -v '/$' | grep -vE "^$BASE/[^/]+$" | while IFS= read -r arquivo; do

    caminho="${arquivo#acoes-personalizadas-master/}"

    # Define destino com base no prefixo
    
    if [[ "$caminho" == config/* ]]; then
    
      destino="$HOME/.config/${caminho#config/}"
      
    elif [[ "$caminho" == usr/* ]]; then
    
      destino="/${caminho}"
      
    else
    
      destino="$HOME/.config/$caminho"
      
    fi

    # Verifica existência com sudo (para arquivos protegidos)
    
    if sudo test -e "$destino"; then
    
      echo -e "${GREEN}Removendo: $destino ${RESET}"
      
      sudo rm -rf "$destino"
      
      if sudo test ! -e "$destino"; then
      
        echo -e "\n${GREEN}✅ Removido com sucesso. ${RESET} \n"

      else
      
        echo -e "\n${RED}⚠️ Falha ao remover: $destino ${RESET} \n"
        
      fi
      

    else
    
      echo "ℹ️ Arquivo não encontrado: $destino"
      
    fi
    
  done

  

  echo -e "\n${GREEN}Removendo documentação /usr/share/doc/scripts para menu de contexto/... ${RESET} \n"

  sudo rm -Rf /usr/share/doc/scripts\ para\ menu\ de\ contexto/ && echo -e "\n${GREEN}✅ Pasta /usr/share/doc/scripts para menu de contexto/ removida com sucesso.${RESET} \n" || echo -e "\n${RED}❌ Falha ao remover /usr/share/doc/scripts para menu de contexto/. ${RESET} \n" >&2

  # sudo rm -Rf /usr/share/icons/extras/

  
  # Remove diretório ~/.config/Thunar se existir
  
if rm -rf ~/.config/Thunar; then

  if [ ! -d ~/.config/Thunar ]; then
  
    echo -e "\n${GREEN}✅ Pasta ~/.config/Thunar removida com sucesso. ${RESET} \n"

  else
  
    echo -e "\n${RED}⚠️ Pasta ainda existe após tentativa de remoção. ${RESET} \n"

  fi
  

else

  echo -e "\n${RED}❌ Erro ao tentar remover ~/.config/Thunar. ${RESET} \n" >&2
  
fi






        
# Função para verificar e remover diretório vazio

verifica_e_remove() {

    local dir="$1"
    
    # Verifica se o diretório existe
    
    if [ -d "$dir" ]; then
    
        # Verifica se o diretório está vazio
        
        if [ -z "$(ls -A "$dir")" ]; then

    echo -e "${RED}       

⚠️  Cuidado: 

Use rm -rf apenas se tiver certeza absoluta de que os arquivos não são necessários. Esse comando não 
pede confirmação e pode causar problemas se usado incorretamente.

${RESET}"
       
            # Pergunta ao usuário se deseja remover
            
            read -p "O diretório $dir está vazio. Deseja removê-lo? (s/n): " resposta
            
            if [[ "$resposta" =~ ^[Ss]$ ]]; then
            
                sudo rm -rf "$dir"
                
                echo -e "\n${GREEN}✅ Diretório $dir removido com sucesso. ${RESET} \n"

            else
            
                echo -e "\n${RED}❎ Remoção de $dir cancelada pelo usuário. ${RESET} \n"
            fi
            
        else

            echo -e "\n${RED}📁 O diretório $dir não está vazio. Não será removido. ${RESET} \n"
        fi

    else

        echo -e "\n${RED}ℹ️ O diretório $dir não existe. ${RESET} \n"

    fi
}


# Verifica se há processos KDE ativos


# Se o KDE estiver em execução, você pode ver processos como:

# plasmashell – interface do KDE Plasma

# kwin_x11 ou kwin_wayland – gerenciador de janelas do KDE

# kded5 – daemon de serviços do KDE

# ksmserver – gerenciador de sessão

# klauncher – inicializador de aplicativos

# krunner – lançador de comandos



if ps aux | grep -E 'kde|plasma|kwin|kded|klauncher|ksmserver' | grep -v grep > /dev/null; then

   echo -e "\n${RED}⚠️ Processos KDE estão em execução. Diretório /usr/share/kservices5 não será removido. ${RESET} \n"

else

   echo -e "\n${GREEN}Nenhum processo KDE encontrado. ${RESET} \n"


# Se você não estiver usando o ambiente gráfico KDE, o diretório 
# /usr/share/kservices5 pode conter arquivos desnecessários 
# relacionados a serviços do KDE.

    verifica_e_remove "/usr/share/kservices5"
        
fi


# Verifica os outros diretórios

verifica_e_remove "/usr/share/icons/extras"
verifica_e_remove "/usr/share/doc"


# ------------------------------------------------------------------------

ARQUIVO="/etc/xdg/Thunar/modelo-uca.xml"

# Verifica se o arquivo existe

if [ -f "$ARQUIVO" ]; then

    echo "📄 O arquivo $ARQUIVO existe."
    
    sudo rm -rf "$ARQUIVO"
  
    echo -e "\n${GREEN}✅ Arquivo removido com sucesso. ${RESET} \n"

else

    echo -e "\nℹ️ O arquivo $ARQUIVO não existe. \n"
    
fi

# ------------------------------------------------------------------------

verifica_e_remove "/etc/xdg/Thunar"


  echo -e "\n${GREEN}✅ Remoção concluída. ${RESET} \n"

  
}

# ------------------------------------------------------------------------

# 📦 Função de instalação

instalar() {

  clear
  
  echo -e "\n${GREEN}📦 Iniciando instalação... ${RESET} \n"

  sleep 1

  remover

  # Remove diretório antigo se existir
  
  rm -rf acoes-personalizadas-master


  echo -e "\n${GREEN}📁 Extraindo arquivos... ${RESET} \n"

  unzip -d . "$ZIP" || { echo -e "\n${RED}❌ Falha ao extrair o ZIP. ${RESET} \n"; exit 1; }

  cd acoes-personalizadas-master || { echo -e "\n${RED}❌ Erro ao acessar diretório extraído. ${RESET} \n"; exit 1; }

  # Instalando...
  
  echo -e "\n${GREEN}🚀 Instalando arquivos... ${RESET} \n"

  # Com tratamento de erro
  
  mkdir -p ~/.config
  
  mv config/* ~/.config/ && echo -e "\n${GREEN}✅ Configurações movidas para ~/.config ${RESET} \n" || { echo -e "\n${RED}\n❌ Erro ao mover configurações ${RESET} \n" >&2; exit 1; }

  
  sudo cp -r usr/* /usr/ && echo -e "\n${GREEN}✅ Arquivos copiados para /usr ${RESET} \n" || { echo -e "\n${RED}❌ Erro ao copiar arquivos ${RESET} \n" >&2; exit 1; }




# 🌐 Ações personalizadas globais - Thunar
  
# Embora a maioria das configurações seja por usuário.

# Se você quiser definir ações disponíveis para todos os usuários, pode colocar o arquivo 
# uca.xml em /etc/xdg/Thunar/ (se suportado pela distro).


UCA_GLOBAL="/etc/xdg/Thunar/uca.xml"

# Verifica se o arquivo existe

if [ -f "$UCA_GLOBAL" ]; then

    echo -e "\n📄 O arquivo $UCA_GLOBAL existe. \n"

    read -p "Deseja atualizar esse arquivo? (s/n): " resposta
    
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
    
        echo -e "\n${GREEN}Copiando $HOME/.config/Thunar/uca.xml  para /etc/xdg/Thunar/modelo-uca.xml ${RESET} \n"
        
        sudo mkdir -p /etc/xdg/Thunar/
        
        sudo cp -r  $HOME/.config/Thunar/uca.xml /etc/xdg/Thunar/modelo-uca.xml
        
        echo -e "${YELLOW}
        🛠️ Como usar:
        
        Para instalação em novos usuários:
        
        $ cp -r /etc/xdg/Thunar/modelo-uca.xml ~/.config/Thunar/uca.xml
        
        ${RESET}"


        
    else
    
        echo -e "\n${RED}❎ Atualização cancelada pelo usuário. ${RESET} \n"
        
    fi
    
else

        echo -e "\nℹ️ O arquivo $UCA_GLOBAL não existe. \n"
      
        echo -e "\n${GREEN}Copiando $HOME/.config/Thunar/uca.xml  para /etc/xdg/Thunar/modelo-uca.xml ${RESET} \n"
        
        sudo mkdir -p /etc/xdg/Thunar/
        
        sudo cp -r  $HOME/.config/Thunar/uca.xml /etc/xdg/Thunar/modelo-uca.xml

        
        echo -e "${YELLOW}
        🛠️ Como usar:
        
        Para instalação em novos usuários:
        
        $ cp -r /etc/xdg/Thunar/modelo-uca.xml ~/.config/Thunar/uca.xml
        
        ${RESET}"
        
fi


echo -e "\n\n"

          
  # Configurando...
  
  sudo chmod +x /usr/local/bin/*.sh && echo -e "\n${GREEN}✅ Scripts tornados executáveis. ${RESET} \n"

  echo -e "\n${GREEN}✅ Instalação concluída! ${RESET}\n"
  
}

# ------------------------------------------------------------------------

# 🧭 Menu de controle

case "$1" in

  instalar)
    instalar
    ;;
    
  remover)
    remover
    ;;
    
  *)
  
    clear
    
    echo -e "\n${RED}❓ Uso: $0 {instalar|remover} ${RESET} \n"

    exit 1

    ;;
    
esac

# ------------------------------------------------------------------------

exit 0

