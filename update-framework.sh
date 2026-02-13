#!/bin/bash
# update-framework.sh
# Ultra-guided update script for Claude Agent Framework
# Version: 1.0.0
#
# This script updates the Claude Agent Framework from the remote repository.
# It shows you what changed, creates backups, and handles conflicts.

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

# Helper functions (same as install-framework.sh)
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
        print_error "Aggiornamento annullato dall'utente."
        exit 1
    fi
}

# Step 1: Verify installation
print_header "STEP 1/7: Verifica Installazione"

print_doing "Controllo che il framework sia installato..."

if [ ! -d "$FRAMEWORK_DIR" ]; then
    print_error "ERRORE: Framework non trovato!"
    echo ""
    echo "COSA SIGNIFICA:"
    echo "  La directory $FRAMEWORK_DIR non esiste."
    echo "  Il framework non è stato installato."
    echo ""
    echo "COME RISOLVERE:"
    echo "  Esegui prima: ./install-framework.sh"
    echo ""
    exit 1
fi

if [ ! -d "$FRAMEWORK_DIR/.git" ]; then
    print_error "ERRORE: Framework installato in modo non corretto!"
    echo ""
    echo "COSA SIGNIFICA:"
    echo "  La directory $FRAMEWORK_DIR esiste ma non è un subtree Git."
    echo "  Non posso aggiornarla automaticamente."
    echo ""
    echo "COME RISOLVERE:"
    echo "  1. Backup della directory: mv $FRAMEWORK_DIR ${FRAMEWORK_DIR}.backup"
    echo "  2. Reinstalla: ./install-framework.sh"
    echo ""
    exit 1
fi

# Get current version
CURRENT_VERSION=$(cat "$FRAMEWORK_DIR/VERSION" 2>/dev/null || echo "unknown")
print_success "Framework installato. Versione corrente: $CURRENT_VERSION"

# Step 2: Check for updates
print_header "STEP 2/7: Controllo Aggiornamenti"

explain_command \
    "Connetto al repository remoto per controllare aggiornamenti" \
    "git fetch $FRAMEWORK_REPO" \
    "Git fetch scarica le informazioni sulle nuove versioni dal repository remoto
     senza modificare i tuoi files. È un'operazione sicura che non cambia nulla."

print_doing "Connessione al repository..."
git fetch "$FRAMEWORK_REPO" 2>&1 || {
    print_error "Impossibile connettersi al repository remoto!"
    echo ""
    echo "POSSIBILI CAUSE:"
    echo "  1. Nessuna connessione internet"
    echo "  2. URL repository errato: $FRAMEWORK_REPO"
    echo "  3. Repository remoto non accessibile"
    echo ""
    echo "COME RISOLVERE:"
    echo "  1. Verifica connessione internet"
    echo "  2. Verifica URL: git remote -v"
    echo "  3. Riprova più tardi"
    echo ""
    exit 1
}

# Check if updates available by comparing current HEAD with remote
REMOTE_VERSION=$(git show FETCH_HEAD:VERSION 2>/dev/null || echo "unknown")

if [ "$CURRENT_VERSION" = "$REMOTE_VERSION" ]; then
    print_success "Sei già all'ultima versione: $CURRENT_VERSION"
    echo ""
    echo "Non ci sono aggiornamenti disponibili."
    exit 0
fi

print_warning "Nuovo aggiornamento disponibile!"
echo ""
echo "  Versione corrente:  $CURRENT_VERSION"
echo "  Versione disponibile: $REMOTE_VERSION"
echo ""

# Step 3: Show changelog
print_header "STEP 3/7: Mostra Changelog"

print_doing "Ecco cosa è cambiato nella nuova versione..."

if [ -f "$FRAMEWORK_DIR/CHANGELOG.md" ]; then
    # Show changelog for new version
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  CHANGELOG - Cosa è cambiato${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    git show FETCH_HEAD:CHANGELOG.md | head -100
    echo -e "${CYAN}═══════════════════════════════════════════════════${NC}"
    echo ""
else
    print_warning "CHANGELOG non disponibile nella nuova versione."
fi

confirm_proceed "Vuoi vedere le modifiche dettagliate ai files?"

# Step 4: Show detailed changes
print_header "STEP 4/7: Anteprima Modifiche"

explain_command \
    "Mostro le differenze tra la tua versione e la nuova" \
    "git diff HEAD FETCH_HEAD" \
    "Git diff confronta la versione corrente con quella nuova e mostra:
     - Files modificati
     - Righe aggiunte (verde, +)
     - Righe rimosse (rosso, -)
     Puoi scorrere con SPACE, uscire con Q."

echo ""
echo -e "${YELLOW}Premi SPACE per scorrere, Q per uscire${NC}"
echo ""
sleep 2

# Show diff (paginated)
git diff --color HEAD:$FRAMEWORK_DIR FETCH_HEAD || true

echo ""
confirm_proceed "Hai visto le modifiche. Vuoi procedere con l'aggiornamento?"

# Step 5: Create backup
print_header "STEP 5/7: Backup di Sicurezza"

cat << EOF
${CYAN}PERCHÉ UN BACKUP?${NC}

Prima di aggiornare, creo un backup di sicurezza usando Git tags.
Se qualcosa va storto, potrai tornare a questa versione.

${GREEN}VANTAGGI:${NC}
  ✓ Nessun file duplicato (usa Git internals)
  ✓ Rollback immediato se necessario
  ✓ Storia completa mantenuta

EOF

BACKUP_TAG="backup/$(date +%Y%m%d-%H%M%S)"

explain_command \
    "Creo tag di backup per rollback di emergenza" \
    "git tag $BACKUP_TAG" \
    "Un Git tag segna il commit corrente. Se l'update va male,
     puoi tornare a questo punto con: git checkout $BACKUP_TAG"

print_doing "Creo backup tag: $BACKUP_TAG"
git tag "$BACKUP_TAG"

print_success "Backup creato: $BACKUP_TAG"
echo ""
echo -e "${GREEN}COME FARE ROLLBACK (se necessario):${NC}"
echo -e "  git checkout $BACKUP_TAG"
echo -e "  git checkout -b recovery-branch"
echo -e "  ./update-framework.sh  # Riprova update"
echo ""

# Step 6: Pull update
print_header "STEP 6/7: Aggiornamento"

cat << EOF
${CYAN}COSA STA PER SUCCEDERE:${NC}

Git subtree pull aggiorna la directory $FRAMEWORK_DIR con le nuove versioni.

${YELLOW}IMPORTANTE:${NC}
  • Files con symlink: aggiornati automaticamente ✓
  • Files personalizzati (.claude/hooks, docs/references): NON toccati ✓
  • Backup disponibile in caso di problemi ✓

${GREEN}SE CI SONO CONFLITTI:${NC}
  Lo script si fermerà e ti mostrerà come risolverli.

EOF

confirm_proceed "Vuoi procedere con l'aggiornamento?"

explain_command \
    "Aggiorno il framework alla nuova versione" \
    "git subtree pull --prefix=$FRAMEWORK_DIR $FRAMEWORK_REPO main --squash" \
    "Git subtree pull scarica i nuovi files del framework e li unisce (merge)
     con la tua copia locale. Il flag --squash crea un singolo commit."

print_doing "Aggiornamento in corso..."

# Attempt update
if git subtree pull --prefix="$FRAMEWORK_DIR" "$FRAMEWORK_REPO" main --squash; then
    print_success "Aggiornamento completato!"
else
    print_error "CONFLITTI RILEVATI durante l'aggiornamento!"
    echo ""
    cat << EOF
${YELLOW}COSA SONO I CONFLITTI:${NC}

Git ha trovato files modificati sia da te che nel framework remoto.
Non sa quale versione mantenere.

${CYAN}COME RISOLVERE:${NC}

1. ${GREEN}Vedi quali files sono in conflitto:${NC}
   git status

2. ${GREEN}Per ogni file in conflitto, scegli:${NC}
   - Mantieni la tua versione: git checkout --ours <file>
   - Usa la nuova versione: git checkout --theirs <file>
   - Modifica manualmente: apri file e risolvi markers (<<<<, ====, >>>>)

3. ${GREEN}Dopo aver risolto tutti i conflitti:${NC}
   git add <files risolti>
   git commit -m "Risolti conflitti update framework"

4. ${GREEN}Riprova l'update:${NC}
   ./update-framework.sh

${RED}OPPURE - ROLLBACK:${NC}
   git checkout $BACKUP_TAG
   git checkout -b recovery-branch

EOF
    exit 1
fi

# Step 7: Post-update verification
print_header "STEP 7/7: Verifiche Post-Aggiornamento"

print_doing "Verifico che tutto funzioni..."

# Check version
NEW_VERSION=$(cat "$FRAMEWORK_DIR/VERSION" 2>/dev/null || echo "unknown")

if [ "$NEW_VERSION" != "$REMOTE_VERSION" ]; then
    print_warning "ATTENZIONE: Versione non corrispondente!"
    echo "  Attesa: $REMOTE_VERSION"
    echo "  Trovata: $NEW_VERSION"
fi

# Check symlinks still valid
print_doing "Verifico symlink..."
SYMLINK_OK=true
for link in "AGENTS.md" "agents" ".claude/agents" ".claude/commands"; do
    if [ ! -L "$link" ]; then
        print_warning "Symlink mancante: $link"
        SYMLINK_OK=false
    elif [ ! -e "$link" ]; then
        print_warning "Symlink rotto: $link"
        SYMLINK_OK=false
    else
        print_success "OK: $link"
    fi
done

if [ "$SYMLINK_OK" = false ]; then
    print_warning "Alcuni symlink hanno problemi. Ricrearli?"
    read -p "Ricreare symlink? (s/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        # Recreate symlinks
        ln -sf "$FRAMEWORK_DIR/AGENTS.md" "AGENTS.md"
        ln -sf "$FRAMEWORK_DIR/agents" "agents"
        ln -sf "../$FRAMEWORK_DIR/.claude/agents" ".claude/agents"
        ln -sf "../$FRAMEWORK_DIR/.claude/commands" ".claude/commands"
        print_success "Symlink ricreati."
    fi
fi

# Final summary
print_header "✓ AGGIORNAMENTO COMPLETATO"

cat << EOF
${GREEN}Framework aggiornato con successo!${NC}

${CYAN}VERSIONI:${NC}
  Prima: $CURRENT_VERSION
  Dopo:  $NEW_VERSION

${CYAN}BACKUP DISPONIBILE:${NC}
  Tag: $BACKUP_TAG
  Rollback: git checkout $BACKUP_TAG

${CYAN}COSA FARE DOPO:${NC}

1. ${YELLOW}Controlla modifiche ai template:${NC}
   - diff $FRAMEWORK_DIR/.claude/hooks/lint-before-commit.sh.template .claude/hooks/lint-before-commit.sh
   - Applica eventuali miglioramenti al tuo hook personalizzato

2. ${YELLOW}Leggi CHANGELOG:${NC}
   - cat $FRAMEWORK_DIR/CHANGELOG.md
   - Verifica se ci sono breaking changes

3. ${YELLOW}Testa il framework:${NC}
   - Verifica che i tuoi workflow funzionino
   - Controlla comandi /new, agenti, etc.

4. ${YELLOW}Rimuovi backup (quando sei sicuro):${NC}
   - git tag -d $BACKUP_TAG

${CYAN}IN CASO DI PROBLEMI:${NC}
  ${RED}Rollback:${NC} git checkout $BACKUP_TAG

${GREEN}Buon lavoro!${NC}
EOF
