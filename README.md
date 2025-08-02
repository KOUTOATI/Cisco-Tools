IPCalc
IPCalc est une application mobile développée avec Flutter, conçue pour simplifier et résoudre divers problèmes liés au réseau, notamment l'analyse d'adresses IP, la gestion des plages d'adresses, la génération d'ID d'interface IPv6 et le sous-réseautage (VLSM), ainsi que la recherche d'informations DNS.

🚀 Fonctionnalités
Cette application offre des outils essentiels pour les professionnels et les étudiants en réseau :

Analyseur IP (IPv4 & IPv6) : Déterminez rapidement le masque de sous-réseau, l'adresse de diffusion (broadcast), les plages d'adresses utilisables pour IPv4, et l'adresse réseau, la première/dernière adresse utilisable ainsi que le nombre total d'adresses pour IPv6, à partir d'une adresse IP donnée avec sa longueur de préfixe.

Génération d'ID d'interface IPv6 (EUI-64) : Convertissez une adresse MAC en un ID d'interface IPv6 en utilisant la méthode EUI-64, avec la possibilité de générer une adresse IPv6 complète en y ajoutant un préfixe.

Sous-réseautage (VLSM & Classique) : Effectuez des calculs de Variable Length Subnet Masking (VLSM) pour optimiser l'utilisation de vos adresses IP en fonction des besoins spécifiques de chaque sous-réseau, ou utilisez le calculateur classique pour des sous-réseaux de taille égale.

Recherche DNS : Effectuez des recherches d'enregistrements DNS (A, AAAA, MX, NS, TXT) pour un nom de domaine donné. (Note : La fonctionnalité de recherche DNS réelle peut être limitée en environnement web/Canvas pour des raisons de sécurité du navigateur et nécessiterait une application native pour un fonctionnement complet).

📱 Installation
L'application IPCalc est disponible sur le Google Play Store. Pour l'installer, il vous suffit de :

Ouvrir l'application Google Play Store sur votre appareil Android.

Rechercher "IPCalc".

Cliquer sur "Installer" et suivre les instructions à l'écran.

Une fois téléchargée, l'application s'installera comme n'importe quelle autre application mobile.

💡 Utilisation
L'interface de IPCalc est intuitive et facile à utiliser :

Pour l'Analyseur IP (IPv4 & IPv6) :

Sélectionnez le type d'adresse IP (IPv4 ou IPv6).

Entrez l'adresse IP et sa longueur de préfixe CIDR (ex: 172.158.1.0/24 pour IPv4 ou 2001:db8::1/64 pour IPv6).

Cliquez sur "Analyser" pour obtenir les détails du sous-réseau.

Pour le Générateur EUI-64 :

Saisissez une adresse MAC dans le champ approprié.

(Optionnel) Entrez un préfixe IPv6 si vous souhaitez générer une adresse IPv6 complète.

Cliquez sur "Générer" pour obtenir l'ID d'interface et les étapes du processus.

Pour le Sous-réseautage (VLSM & Classique) :

Accédez à la section du calculateur de sous-réseaux.

Choisissez entre le calcul VLSM (en spécifiant les besoins en hôtes pour chaque sous-réseau) ou le calcul classique (en spécifiant le nombre de sous-réseaux).

Entrez l'adresse réseau de départ et les informations requises, puis lancez le calcul.

Pour la Recherche DNS :

Accédez à l'écran "Recherche DNS".

Entrez le nom de domaine que vous souhaitez interroger (ex: google.com, github.com).

Cliquez sur "Rechercher" pour afficher les enregistrements DNS simulés ou réels (sur une application native).

🤝 Contribution
Ce projet n'est pas ouvert aux contributions externes pour le moment.

📄 Licence
Ce projet n'est soumis à aucune licence spécifique.