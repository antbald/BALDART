#!/bin/bash
# push-improvements.sh
# Ultra-guided push script for Claude Agent Framework
# Version: 1.0.0
#
# This script helps you contribute improvements back to the framework.
# It guides you through change classification, VERSION updates, and push.

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Framework repository URL
FRAMEWORK_REPO="${FRAMEWORK_REPO:-https://github.com/antbald/BALDART.git}"
FRAMEWORK_DIR=".framework"

# Helper functions
print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}✓ STEP $1${NC}: $2"
}

print_doing() {
    echo -e "${BLUE}→ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

explain_command() {
    local title=$1
    local command=$2
    local explanation=$3

    echo ""
    echo -e "${CYAN}COSA STO FACENDO:${NC} $title"
    echo -e "${YELLOW}COMANDO TECNICO:${NC} $command"
    echo -e "${BLUE}SPIEGAZIONE:${NC} $explanation"
    echo ""
}

confirm_proceed() {
    local prompt=$1
    echo ""
    echo -e "${YELLOW}$prompt${NC}"
    read -p "Vuoi procedere? (s/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_error "Push annullato dall'utente."
        exit 1
    fi
}

# Step 1: Check for changes
print_header "STEP 1/8: Controllo Modifiche"

print_doing "Cerco modifiche nella directory $FRAMEWORK_DIR..."

cd "$FRAMEWORK_DIR" || {
    print_error "Directory $FRAMEWORK_DIR non trovata!"
    exit 1
}

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_warning "ATTENZIONE: Ci sono modifiche non committate in $FRAMEWORK_DIR!"
    echo ""
    echo "MODIFICHE TROVATE:"
    git status --short
    echo ""
    echo -e "${YELLOW}DEVI COMMITTARE PRIMA DI PUSHARE${NC}"
    echo ""
    echo "Le modifiche al framework devono essere committate nel repository"
    echo "principale del progetto, non in $FRAMEWORK_DIR."
    echo ""
    echo "OPZIONI:"
    echo "  1. Torna alla directory principale e commita: cd .. && git add $FRAMEWORK_DIR && git commit"
    echo "  2. Annulla le modifiche: git checkout ."
    echo ""
    cd ..
    exit 1
fi

# Check if there are changes to push
if [ -z "$(git log origin/main..HEAD 2>/dev/null)" ]; then
    print_warning "Nessuna modifica da pushare!"
    echo ""
    echo "La tua versione del framework è identica a quella remota."
    echo "Non ci sono miglioramenti da condividere."
    echo ""
    cd ..
    exit 0
fi

print_success "Modifiche trovate! Pronte per essere condivise."

# Go back to project root
cd ..

# Step 2: Review changes
print_header "STEP 2/8: Review Dettagliata"

cat << EOF
${CYAN}MODIFICHE DA PUSHARE:${NC}

Ecco le modifiche che hai fatto al framework e che puoi condividere
con il repository centrale.

${YELLOW}NOTA IMPORTANTE:${NC}
  Puoi pushare SOLO modifiche fatte ai files del framework in $FRAMEWORK_DIR.
  Modifiche ai tuoi files personalizzati (hooks, UI guidelines) NON saranno condivise.

EOF

explain_command \
    "Mostro le tue modifiche al framework" \
    "git log origin/main..HEAD --oneline -- $FRAMEWORK_DIR" \
    "Questo mostra i commit che hai fatto alla directory $FRAMEWORK_DIR
     che non sono ancora nel repository remoto."

echo ""
echo -e "${GREEN}COMMIT DA PUSHARE:${NC}"
git log origin/main..HEAD --oneline -- "$FRAMEWORK_DIR" 2>/dev/null || echo "(nessun commit)"
echo ""

explain_command \
    "Mostro i files modificati" \
    "git diff origin/main..HEAD --stat -- $FRAMEWORK_DIR" \
    "Questo mostra quali files sono stati modificati e quante righe cambiate."

echo ""
echo -e "${GREEN}FILES MODIFICATI:${NC}"
git diff origin/main..HEAD --stat -- "$FRAMEWORK_DIR" 2>/dev/null || echo "(nessuna modifica)"
echo ""

confirm_proceed "Vuoi vedere le modifiche dettagliate?"

echo ""
echo -e "${YELLOW}Premi SPACE per scorrere, Q per uscire${NC}"
echo ""
sleep 2

# Show detailed diff
git diff origin/main..HEAD -- "$FRAMEWORK_DIR" || true

echo ""
confirm_proceed "Hai visto le modifiche. Vuoi procedere con il push?"

# Step 3: Classify change type
print_header "STEP 3/8: Classificazione Tipo di Modifica"

cat << EOF
${CYAN}SEMANTIC VERSIONING:${NC}

Il framework usa Semantic Versioning: MAJOR.MINOR.PATCH

${GREEN}MAJOR (X.0.0):${NC} Breaking changes - modifiche non compatibili
  Esempi:
    • Rimozione di un agente
    • Cambio formato backlog cards
    • Rimozione di sezioni AGENTS.md
    • Cambio struttura directory

${GREEN}MINOR (0.X.0):${NC} Nuove funzionalità - aggiunte compatibili
  Esempi:
    • Nuovo agente
    • Nuovo comando
    • Nuovo modulo agents/
    • Miglioramento funzionalità esistente

${GREEN}PATCH (0.0.X):${NC} Bug fix - correzioni compatibili
  Esempi:
    • Fix typo in documentazione
    • Correzione bug in script
    • Miglioramento spiegazioni
    • Ottimizzazione codice esistente

${YELLOW}IN CASO DI DUBBIO:${NC}
  Se la tua modifica richiede che altri utenti cambino il loro setup,
  è probabilmente MAJOR. Altrimenti, è MINOR o PATCH.

EOF

echo "Che tipo di modifica hai fatto?"
echo ""
echo "  ${GREEN}1)${NC} MAJOR - Breaking change (incompatibile)"
echo "  ${GREEN}2)${NC} MINOR - Nuova funzionalità (compatibile)"
echo "  ${GREEN}3)${NC} PATCH - Bug fix (compatibile)"
echo ""
read -p "Scegli (1/2/3): " -n 1 -r CHANGE_TYPE
echo ""

case $CHANGE_TYPE in
    1)
        VERSION_TYPE="MAJOR"
        print_warning "ATTENZIONE: Breaking change! Gli utenti dovranno adattare il loro setup."
        ;;
    2)
        VERSION_TYPE="MINOR"
        print_success "Nuova funzionalità - compatibile con versioni esistenti."
        ;;
    3)
        VERSION_TYPE="PATCH"
        print_success "Bug fix - compatibile con versioni esistenti."
        ;;
    *)
        print_error "Scelta non valida!"
        exit 1
        ;;
esac

# Step 4: Describe change
print_header "STEP 4/8: Descrizione Modifica"

cat << EOF
${CYAN}DESCRIVI LA TUA MODIFICA:${NC}

Scrivi una breve descrizione (1-2 righe) della tua modifica.
Questa verrà aggiunta al CHANGELOG.

${GREEN}ESEMPI BUONI:${NC}
  • "Aggiunto agente ml-optimizer per ottimizzazione modelli ML"
  • "Fix: script install-framework.sh falliva su macOS"
  • "Migliorato AGENTS.md con esempi chiari per testing protocol"

${RED}ESEMPI CATTIVI:${NC}
  • "Update" (troppo vago)
  • "Fixed stuff" (non spiega cosa)
  • "Changes" (inutile)

EOF

read -p "Descrizione: " CHANGE_DESC

if [ -z "$CHANGE_DESC" ]; then
    print_error "Descrizione vuota! Riprova."
    exit 1
fi

print_success "Descrizione registrata: $CHANGE_DESC"

# Step 5: Commit changes
print_header "STEP 5/8: Commit Locale"

cat << EOF
${CYAN}CREO COMMIT PER IL PUSH:${NC}

Il push richiede che le modifiche siano committate.
Se non l'hai già fatto, lo faccio ora.

${YELLOW}MESSAGGIO DI COMMIT:${NC}
  [$VERSION_TYPE] $CHANGE_DESC

EOF

# Check if changes are already committed
if git diff-index --quiet HEAD -- "$FRAMEWORK_DIR"; then
    print_success "Modifiche già committate."
else
    print_doing "Committo le modifiche..."

    git add "$FRAMEWORK_DIR"
    git commit -m "[$VERSION_TYPE] $CHANGE_DESC"

    print_success "Commit creato."
fi

# Step 6: Pre-push verification
print_header "STEP 6/8: Verifiche Pre-Push"

cat << EOF
${CYAN}VERIFICO CONNESSIONE E PERMESSI:${NC}

Prima di pushare, controllo:
  1. Connessione al repository remoto
  2. Permessi di scrittura
  3. Stato sincronizzazione

EOF

print_doing "Verifico connessione al repository..."

# Test connection
if git ls-remote "$FRAMEWORK_REPO" &>/dev/null; then
    print_success "Connessione OK: repository raggiungibile"
else
    print_error "Impossibile connettersi al repository!"
    echo ""
    echo "POSSIBILI CAUSE:"
    echo "  1. Nessuna connessione internet"
    echo "  2. URL repository errato: $FRAMEWORK_REPO"
    echo "  3. Mancano permessi di accesso"
    echo ""
    echo "COME RISOLVERE:"
    echo "  1. Verifica connessione internet"
    echo "  2. Verifica URL: git remote -v"
    echo "  3. Configura autenticazione GitHub (SSH key o PAT)"
    echo ""
    exit 1
fi

# Check for conflicts with remote
print_doing "Verifico conflitti con versione remota..."

git fetch "$FRAMEWORK_REPO" main

if git merge-base --is-ancestor FETCH_HEAD HEAD; then
    print_success "Nessun conflitto: la tua versione è più aggiornata"
elif git merge-base --is-ancestor HEAD FETCH_HEAD; then
    print_warning "ATTENZIONE: La versione remota è più recente della tua!"
    echo ""
    echo "Devi prima aggiornare il framework:"
    echo "  ./update-framework.sh"
    echo ""
    echo "Poi potrai pushare i tuoi miglioramenti."
    exit 1
else
    print_warning "ATTENZIONE: Divergenza rilevata!"
    echo ""
    echo "La tua versione e quella remota hanno entrambe nuovi commit."
    echo "Devi prima fare merge:"
    echo ""
    echo "  1. ./update-framework.sh"
    echo "  2. Risolvi eventuali conflitti"
    echo "  3. ./push-improvements.sh"
    echo ""
    exit 1
fi

# Step 7: Push to remote
print_header "STEP 7/8: Push al Repository Centrale"

cat << EOF
${CYAN}PRONTO PER IL PUSH:${NC}

Sto per pushare le tue modifiche al repository centrale.
Questo renderà i tuoi miglioramenti disponibili a tutti.

${GREEN}COSA SUCCEDERÀ:${NC}
  1. Git push invierà i commit al repository remoto
  2. Altri utenti potranno scaricare i tuoi miglioramenti
  3. Il tuo contributo sarà tracciato nella history Git

${YELLOW}DOPO IL PUSH:${NC}
  Dovrai aggiornare manualmente VERSION e CHANGELOG nel repository
  remoto con un secondo commit.

EOF

confirm_proceed "Vuoi pushare al repository centrale?"

explain_command \
    "Push delle modifiche al repository remoto" \
    "git subtree push --prefix=$FRAMEWORK_DIR $FRAMEWORK_REPO main" \
    "Git subtree push estrae i commit dalla directory $FRAMEWORK_DIR
     e li invia al repository framework come se fossero commit normali.
     Solo i cambiamenti in $FRAMEWORK_DIR vengono condivisi."

print_doing "Push in corso..."

if git subtree push --prefix="$FRAMEWORK_DIR" "$FRAMEWORK_REPO" main; then
    print_success "Push completato con successo!"
else
    print_error "Push fallito!"
    echo ""
    cat << EOF
${YELLOW}POSSIBILI CAUSE:${NC}

1. ${RED}Mancano permessi di scrittura${NC}
   Verifica di avere accesso push al repository.
   Configura SSH key o Personal Access Token.

2. ${RED}Branch protetto${NC}
   Il branch main potrebbe richiedere pull request.
   Apri una PR invece di pushare direttamente.

3. ${RED}Conflitti con versione remota${NC}
   Aggiorna prima: ./update-framework.sh

${GREEN}COME PROCEDERE:${NC}
  1. Risolvi la causa del fallimento
  2. Riprova: ./push-improvements.sh

EOF
    exit 1
fi

# Step 8: Next steps
print_header "STEP 8/8: Prossimi Passi"

cat << EOF
${GREEN}Push completato con successo!${NC}

${YELLOW}⚠ IMPORTANTE - AGGIORNA VERSION E CHANGELOG:${NC}

Le tue modifiche sono state pushate, ma devi ancora:

1. ${GREEN}Aggiorna VERSION:${NC}
   - Vai al repository: cd $FRAMEWORK_DIR
   - Determina nuova versione basata su tipo di modifica:
     * MAJOR: da 1.0.0 → 2.0.0
     * MINOR: da 1.0.0 → 1.1.0
     * PATCH: da 1.0.0 → 1.0.1
   - Edita VERSION manualmente
   - Commit: git commit -m "Bump version to X.Y.Z"
   - Push: git push

2. ${GREEN}Aggiorna CHANGELOG.md:${NC}
   - Aggiungi entry sotto [Unreleased]:
     * ## [X.Y.Z] - $(date +%Y-%m-%d)
     * ### $VERSION_TYPE
     * - $CHANGE_DESC
   - Commit: git commit -m "Update CHANGELOG for X.Y.Z"
   - Push: git push

3. ${GREEN}Crea Git Tag (opzionale ma raccomandato):${NC}
   - git tag -a vX.Y.Z -m "Release X.Y.Z"
   - git push --tags

${CYAN}RIEPILOGO MODIFICA:${NC}
  Tipo: $VERSION_TYPE
  Descrizione: $CHANGE_DESC

${CYAN}COMANDO RAPIDO (da eseguire in $FRAMEWORK_DIR):${NC}
  # Esempio per bump version 1.0.0 → 1.1.0 (MINOR)
  cd $FRAMEWORK_DIR
  echo "1.1.0" > VERSION
  git add VERSION
  git commit -m "Bump version to 1.1.0"
  git push

${GREEN}Grazie per il tuo contributo al framework!${NC}
EOF
