#!/bin/bash
# install-framework.sh
# Ultra-guided installation script for Claude Agent Framework
# Version: 1.0.0
#
# This script installs the Claude Agent Framework into your project using Git subtree.
# It guides you through every step with clear explanations and shows what will happen.

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Framework repository URL (update this when hosting on GitHub)
FRAMEWORK_REPO="${FRAMEWORK_REPO:-https://github.com/yourusername/claude-agent-framework.git}"
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
        print_error "Installazione annullata dall'utente."
        exit 1
    fi
}

# Step 1: Verify environment
print_header "STEP 1/8: Verifica Ambiente"
print_doing "Controllo che il tuo progetto sia pronto per l'installazione..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "ERRORE: Non sei in una repository Git!"
    echo ""
    echo "COSA SIGNIFICA:"
    echo "  Il framework richiede che il tuo progetto sia una repository Git."
    echo ""
    echo "COME RISOLVERE:"
    echo "  1. Inizializza Git: git init"
    echo "  2. Oppure spostati nella directory corretta del tuo progetto"
    echo ""
    exit 1
fi

print_success "Ambiente verificato: sei in una repository Git valida."

# Step 2: Check for existing framework
print_header "STEP 2/8: Controllo Framework Esistente"
print_doing "Verifico se il framework è già installato..."

if [ -d "$FRAMEWORK_DIR" ]; then
    print_warning "ATTENZIONE: Il framework sembra già installato!"
    echo ""
    echo "Trovata directory: $FRAMEWORK_DIR"
    echo ""
    echo "OPZIONI:"
    echo "  1. Annulla l'installazione e usa 'update-framework.sh' per aggiornare"
    echo "  2. Rimuovi la directory esistente e reinstalla (PERDERAI PERSONALIZZAZIONI!)"
    echo ""
    read -p "Vuoi rimuovere e reinstallare? (s/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_error "Installazione annullata. Usa 'update-framework.sh' per aggiornare."
        exit 1
    fi
    print_warning "Rimuovo framework esistente..."
    rm -rf "$FRAMEWORK_DIR"
fi

print_success "Nessun framework esistente trovato. Pronto per l'installazione."

# Step 3: Detailed explanation
print_header "STEP 3/8: Spiegazione Dettagliata"

cat << EOF
${CYAN}CHE COSA INSTALLEREMO:${NC}

Il Claude Agent Framework fornisce:

1. ${GREEN}AGENTS.md${NC}
   Protocollo di coordinamento per agenti (umani e AI)
   Regole MUST/SHOULD per workflow sicuri

2. ${GREEN}agents/index.md${NC} + 17 moduli
   Routing per documentazione e best practices
   Moduli: architecture, coding-standards, workflows, testing, etc.

3. ${GREEN}.claude/agents/${NC} (9 agenti AI)
   - codebase-architect: Comprensione codebase (OBBLIGATORIO prima di coding)
   - coder: Implementazione codice produzione
   - code-reviewer: Review qualità codice
   - doc-reviewer: Review/scrittura documentazione
   - prd: Creazione PRD e backlog cards
   - plan-auditor: Audit piani implementazione
   - senior-researcher: Ricerca e analisi tecnologica
   - api-perf-cost-auditor: Analisi performance/costi API

4. ${GREEN}.claude/commands/${NC} (3 comandi)
   - /new: Orchestratore batch per backlog cards
   - /design-review: Review UI/UX
   - /issue-review: Analisi GitHub issues

5. ${GREEN}.claude/hooks/${NC}
   - lint-before-commit.sh: Hook pre-commit (template da personalizzare)

6. ${GREEN}docs/references/${NC}
   - ui-guidelines.template.md: Template linee guida UI
   - brand-guidelines.md: Template brand identity

7. ${GREEN}templates/${NC}
   - feature-card.template.yml: Template backlog card
   - spec.template.md: Template spec tecniche
   - breaking-change-checklist.md: Checklist breaking changes

${CYAN}COME FUNZIONA L'INSTALLAZIONE (Git Subtree):${NC}

Git subtree copia il framework nella directory '$FRAMEWORK_DIR' del tuo progetto.
Il framework diventa parte del tuo repository ma rimane aggiornabile.

${CYAN}VANTAGGI:${NC}
  ✓ Bidirezionale: puoi PULLARE aggiornamenti E PUSHARE miglioramenti
  ✓ Versionato: il framework è tracciato nella tua history Git
  ✓ Offline: funziona senza connessione al repo remoto
  ✓ Semplice: i collaboratori non devono fare setup speciali

${CYAN}STRUTTURA FINALE:${NC}

Il tuo progetto avrà:
  • $FRAMEWORK_DIR/            (framework originale, aggiornabile via Git)
  • AGENTS.md                  (symlink → $FRAMEWORK_DIR/AGENTS.md)
  • agents/                    (symlink → $FRAMEWORK_DIR/agents/)
  • .claude/agents/           (symlink → $FRAMEWORK_DIR/.claude/agents/)
  • .claude/commands/         (symlink → $FRAMEWORK_DIR/.claude/commands/)
  • .claude/hooks/            (copia personalizzabile)
  • docs/references/ui-*      (copia personalizzabile)
  • templates/                (copia personalizzabile)

${CYAN}PERCHÉ SYMLINK VS COPIE:${NC}
  • Symlink: Files che NON devi personalizzare (aggiornabili automaticamente)
  • Copie: Files da personalizzare per il tuo progetto (UI, hooks, templates)

EOF

confirm_proceed "Hai capito cosa verrà installato?"

# Step 4: Download framework
print_header "STEP 4/8: Download Framework"

explain_command \
    "Scarico il framework dal repository remoto" \
    "git subtree add --prefix=$FRAMEWORK_DIR $FRAMEWORK_REPO main --squash" \
    "Git subtree copia tutti i files del framework nella directory $FRAMEWORK_DIR.
     Il flag --squash crea un singolo commit invece di importare tutta la history.
     Il framework diventa parte del tuo repo ma rimane aggiornabile."

print_doing "Download in corso..."
git subtree add --prefix="$FRAMEWORK_DIR" "$FRAMEWORK_REPO" main --squash

print_success "Framework scaricato in $FRAMEWORK_DIR"

# Step 5: Create directory structure
print_header "STEP 5/8: Creazione Struttura"

print_doing "Creo le directory necessarie per symlink e copie..."

# Create directories that don't exist yet
mkdir -p .claude/agents .claude/commands .claude/hooks docs/references templates backlog

print_success "Struttura directory creata."

# Step 6: Create symlinks
print_header "STEP 6/8: Creazione Symlink"

cat << EOF
${CYAN}PERCHÉ SYMLINK?${NC}

I symlink (symbolic links) sono collegamenti ai files nel framework.
Quando il framework viene aggiornato, i symlink puntano automaticamente
alle nuove versioni. Non devi copiare manualmente i files.

${YELLOW}IMPORTANTE:${NC}
Se personalizzi un file con symlink, le modifiche saranno perse al prossimo update!
Usa symlink SOLO per files che NON personalizzerai.

EOF

print_doing "Creo symlink per files del framework..."

# Function to create symlink with backup
create_symlink() {
    local target=$1
    local link_name=$2

    # Backup existing file/directory
    if [ -e "$link_name" ] && [ ! -L "$link_name" ]; then
        print_warning "Backup: $link_name → ${link_name}.backup"
        mv "$link_name" "${link_name}.backup"
    fi

    # Remove existing symlink
    [ -L "$link_name" ] && rm "$link_name"

    # Create symlink
    ln -s "$target" "$link_name"
    print_success "Symlink: $link_name → $target"
}

# Create symlinks
create_symlink "$FRAMEWORK_DIR/AGENTS.md" "AGENTS.md"
create_symlink "$FRAMEWORK_DIR/agents" "agents"
create_symlink "../$FRAMEWORK_DIR/.claude/agents" ".claude/agents"
create_symlink "../$FRAMEWORK_DIR/.claude/commands" ".claude/commands"

echo ""
print_success "Symlink creati."

# Step 7: Copy customizable files
print_header "STEP 7/8: Preparazione Template"

cat << EOF
${CYAN}FILES DA PERSONALIZZARE:${NC}

Questi files vengono COPIATI (non symlink) perché li personalizzerai:

1. ${GREEN}.claude/hooks/lint-before-commit.sh${NC}
   Personalizza i comandi lint/build per il tuo progetto.
   Esempio: sostituisci 'npm run lint' con il tuo comando.

2. ${GREEN}docs/references/ui-guidelines.template.md${NC}
   Definisci brand colors, typography, spacing, component patterns.

3. ${GREEN}docs/references/brand-guidelines.md${NC}
   Logo, brand voice, imagery guidelines.

4. ${GREEN}templates/*.yml${NC}
   Template per backlog cards e specs.

${YELLOW}DOPO L'INSTALLAZIONE:${NC}
  1. Apri .claude/hooks/lint-before-commit.sh.template
  2. Personalizza i comandi per il tuo progetto
  3. Rinomina in lint-before-commit.sh
  4. Rendi eseguibile: chmod +x .claude/hooks/lint-before-commit.sh

EOF

print_doing "Copio template personalizzabili..."

# Copy customizable files
cp "$FRAMEWORK_DIR/.claude/hooks/lint-before-commit.sh.template" ".claude/hooks/lint-before-commit.sh.template"
cp "$FRAMEWORK_DIR/docs/references/ui-guidelines.template.md" "docs/references/ui-guidelines.template.md"
cp "$FRAMEWORK_DIR/docs/references/brand-guidelines.md" "docs/references/brand-guidelines.md"

# Copy templates if they don't exist (don't overwrite existing)
for template in "$FRAMEWORK_DIR"/templates/*; do
    filename=$(basename "$template")
    if [ ! -f "templates/$filename" ]; then
        cp "$template" "templates/$filename"
        print_success "Copiato: templates/$filename"
    else
        print_warning "Saltato (esiste già): templates/$filename"
    fi
done

print_success "Template copiati."

# Step 8: Configure Git aliases
print_header "STEP 8/8: Configurazione Comandi Rapidi"

cat << EOF
${CYAN}COMANDI RAPIDI (Git Aliases):${NC}

Per facilitare l'uso del framework, creo questi comandi Git:

${GREEN}git fw-version${NC}
  Mostra la versione del framework installata

${GREEN}git fw-update${NC}
  Esegue update-framework.sh per aggiornare il framework

${GREEN}git fw-push${NC}
  Esegue push-improvements.sh per condividere i tuoi miglioramenti

Questi comandi saranno disponibili solo in questo repository (local git config).

EOF

confirm_proceed "Vuoi creare questi alias Git?"

git config alias.fw-version "!cat $FRAMEWORK_DIR/VERSION"
git config alias.fw-update "!bash ./update-framework.sh"
git config alias.fw-push "!bash ./push-improvements.sh"

print_success "Alias Git configurati."

# Final summary
print_header "✓ INSTALLAZIONE COMPLETATA"

cat << EOF
${GREEN}Framework installato con successo!${NC}

${CYAN}COSA È STATO FATTO:${NC}
  ✓ Framework scaricato in $FRAMEWORK_DIR
  ✓ Symlink creati per files auto-aggiornabili
  ✓ Template copiati per personalizzazione
  ✓ Alias Git configurati

${CYAN}PROSSIMI PASSI:${NC}

1. ${YELLOW}Personalizza hook pre-commit:${NC}
   - Apri .claude/hooks/lint-before-commit.sh.template
   - Sostituisci 'npm run lint' e 'npm run build' con i tuoi comandi
   - Rinomina in lint-before-commit.sh
   - chmod +x .claude/hooks/lint-before-commit.sh

2. ${YELLOW}Personalizza UI guidelines:${NC}
   - Apri docs/references/ui-guidelines.template.md
   - Definisci brand colors, typography, spacing
   - Salva come docs/references/ui-guidelines.md

3. ${YELLOW}Personalizza brand guidelines:${NC}
   - Apri docs/references/brand-guidelines.md
   - Aggiungi logo, brand voice, imagery

4. ${YELLOW}Crea backlog directory:${NC}
   - mkdir backlog
   - Copia templates/feature-card.template.yml per nuove cards

5. ${YELLOW}Leggi AGENTS.md:${NC}
   - cat AGENTS.md
   - Familiarizza con le regole MUST/SHOULD

${CYAN}COMANDI DISPONIBILI:${NC}
  ${GREEN}git fw-version${NC}   - Mostra versione framework
  ${GREEN}git fw-update${NC}    - Aggiorna framework
  ${GREEN}git fw-push${NC}      - Condividi miglioramenti

${CYAN}HELP:${NC}
  Per aiuto: cat $FRAMEWORK_DIR/README.md

${GREEN}Buon lavoro!${NC}
EOF
