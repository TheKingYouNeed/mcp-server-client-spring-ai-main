# Projet MCP Server-Client

## Présentation du projet

Ce projet est une implémentation du protocole MCP (Model Context Protocol) qui permet la communication entre des modèles d'IA et des outils externes. L'application est composée de trois composants principaux:

1. **Serveur MCP Python** - Un serveur MCP léger écrit en Python utilisant la bibliothèque FastMCP
2. **Serveur MCP Spring Boot** - Un serveur MCP basé sur Spring Boot utilisant le protocole SSE (Server-Sent Events)
3. **Client MCP Spring Boot** - Un client qui se connecte aux serveurs MCP et utilise l'API Anthropic Claude pour les fonctionnalités d'IA

## Structure du projet

```
mcp-server-client-spring-ai-main/
│
├── python-mcp-server/            # Serveur MCP Python
│   ├── server.py                 # Point d'entrée du serveur MCP Python
│   └── main.py                   # Fichier Python principal
│
├── sse-mcp-server/               # Serveur MCP Spring Boot
│   ├── pom.xml                   # Configuration Maven
│   └── src/                      # Code source Java
│
├── mcp-client/                   # Client MCP Spring Boot
│   ├── pom.xml                   # Configuration Maven
│   ├── src/                      # Code source Java
│   └── resources/                # Fichiers de configuration
│       ├── application.properties        # Configuration principale
│       ├── application-secrets.properties # Clés API (non versionnées)
│       └── mcp-servers.json              # Configuration des serveurs MCP
│
└── run-all.bat                   # Script pour démarrer tous les composants
```

## Prérequis

- Java 21 ou supérieur
- Python 3.10 ou supérieur
- Maven (inclus via les wrappers mvnw)
- Clé API Anthropic Claude

## Installation

1. **Installation des dépendances Python**

```bash
cd python-mcp-server
pip install fastmcp
```

2. **Configuration de la clé API Anthropic (OBLIGATOIRE)**

L'application nécessite une clé API Anthropic Claude valide pour fonctionner. Sans cette clé, vous recevrez une erreur d'authentification (`HTTP 401 - invalid x-api-key`).

Voici comment configurer la clé API:

a) Créez un fichier `application-secrets.properties` dans le dossier `mcp-client/src/main/resources/` basé sur le modèle fourni:

```properties
# Clé API Anthropic
spring.ai.anthropic.api-key=sk-ant-api03-VOTRE_CLÉ_API_ICI
```

b) Alternativement, vous pouvez définir une variable d'environnement système nommée `CLAUDE_API_KEY` avec votre clé API comme valeur.

> **IMPORTANT**: Ne partagez jamais votre clé API et ne la publiez pas sur GitHub ou tout autre dépôt public. Le fichier `application-secrets.properties` est automatiquement ignoré par Git pour protéger votre clé.

## Démarrage de l'application

### Prérequis avant démarrage

1. Assurez-vous que vous avez bien configuré votre clé API Anthropic (voir section précédente)
2. Vérifiez que Python est installé et que la bibliothèque FastMCP est disponible
3. Si vous utilisez le serveur filesystem, vérifiez que Node.js est installé et accessible

### Méthode 1: Démarrage automatisé (recommandée)

Utilisez le script batch qui lance tous les composants dans l'ordre correct avec les délais appropriés:

```bash
run-all.bat
```

Ce script:
- Démarre d'abord le serveur MCP Python dans une fenêtre séparée
- Attend 3 secondes pour l'initialisation
- Démarre le serveur MCP Spring Boot dans une deuxième fenêtre
- Attend 5 secondes pour l'initialisation
- Lance le client MCP dans la fenêtre actuelle

### Méthode 2: Démarrage manuel des composants

Si vous préférez un contrôle plus précis, vous pouvez démarrer chaque composant manuellement **dans cet ordre**:

1. **Démarrer le serveur MCP Python**

```bash
cd python-mcp-server
python server.py
```

2. **Démarrer le serveur MCP Spring Boot**

```bash
cd sse-mcp-server
./mvnw spring-boot:run  # Sous Windows: mvnw.cmd spring-boot:run
```

3. **Démarrer le client MCP**

```bash
cd mcp-client
./mvnw spring-boot:run  # Sous Windows: mvnw.cmd spring-boot:run
```

### Accès à l'application

Une fois démarrée, l'application client est accessible à:
- URL: `http://localhost:8080`
- Le serveur Python MCP s'exécute sur le port 8878
- Le serveur Spring Boot MCP s'exécute sur le port 8877

## Architecture

Le système utilise le protocole MCP (Model Context Protocol) pour permettre la communication entre différents composants:

- Le **Serveur MCP Python** fournit des outils simples comme la récupération d'informations sur les employés
- Le **Serveur MCP Spring Boot** fournit des services supplémentaires via Spring Boot
- Le **Client MCP** se connecte à ces serveurs pour accéder à leurs outils et les expose à travers une interface web

## Configuration

### Configuration du client MCP

Le fichier `application.properties` contient la configuration principale:

```properties
# Configuration du client MCP
spring.ai.mcp.client.type=sync
spring.ai.mcp.client.connection-timeout=60000
spring.ai.mcp.client.read-timeout=60000
spring.ai.mcp.client.sse.connections.server1.url=http://localhost:8877
```

### Configuration des serveurs MCP

Le fichier `mcp-servers.json` définit les serveurs MCP disponibles:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "C:/Program Files/nodejs/npx.cmd",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "chemin/vers/dossier"
      ]
    },
    "Python-MCP-Server": {
      "command": "python",
      "args": [
        "chemin/vers/server.py"
      ]
    }
  }
}
```

## Sécurité

Les clés API sensibles sont stockées dans un fichier `application-secrets.properties` qui est exclu du contrôle de version Git. Ne partagez jamais ce fichier et ne l'incluez pas dans vos commits.

## Dépannage

1. **Erreur "Invalid x-api-key"**
   - Vérifiez que votre clé API Anthropic est correctement configurée dans `application-secrets.properties`

2. **Erreur "Cannot run program 'npx'"**
   - Vérifiez que Node.js est installé ou désactivez le serveur filesystem en ajoutant:
   - `spring.ai.mcp.client.stdio.filesystem.auto-initialization.enabled=false` dans `application.properties`

3. **Problèmes de connexion au serveur MCP**
   - Vérifiez que les serveurs MCP sont en cours d'exécution
   - Vérifiez les paramètres de timeout dans `application.properties`

## Contribution

Pour contribuer à ce projet, veuillez:

1. Forker le dépôt
2. Créer une branche pour votre fonctionnalité (`git checkout -b nouvelle-fonctionnalite`)
3. Valider vos modifications (`git commit -am 'Ajouter une nouvelle fonctionnalité'`)
4. Pousser vers la branche (`git push origin nouvelle-fonctionnalite`)
5. Créer une Pull Request

## Licence

Ce projet est distribué sous licence MIT.
