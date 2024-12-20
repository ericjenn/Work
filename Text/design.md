
*Je ne distingue pas la nature de la fonction, qu'elle relève du service rendu par le système ou des contraintes que le système doit assurer. Je m'intéresse à une fonction racine (fonction "mère") quelconque. Il faudrait sans doute raffiner tout cela en fonction de la natur de la fonction.*

*Je n'ai pas appliqué de méthode particulière (méthode d'analyse classique) car je n'en ai pas en tête. J'ai simplement retranscrit quelques idées et principes. Je pense qu'il faudrait à terme présenter les choses de façon plus ordonnée et rigoureuse, mais (i) les questions qui suivent sont à mon sens toutes pertinentes et (ii) c'est un travail de réorganisation que l'on pourra faire dans une deuxième phase.*  

# Activités préliminaires

*Je mentionne ici les activités préalables à la réalisation du travail d'analyse fonctionnelle proprement dit.*

## 1.a - Validation des données du problème

- **L'exigence est-elle bien formulée?** (cf. section "validation d'exigence" plus bas)
- **L'exigence prend-elle explicitement en compte les situations de défaillance, de conditions environnementales hors limites?**
- **Les conditions de début et de fin de la fonction sont-elles définies?**
  > Quand est-ce que commence le tracking du visiteur?
- **Si la réalisation de la fonction dépend intrinsèquement de propriétés de l'environnement, ces propriétés sont-elles exprimées?**\
  - *Par exemple, la fonction de suivi d'une personne dépend directement de la personne, de sa présence, de son mouvement. A-t-on caractérisé cette personne du point de vue de sa vitesse de déplacement (qui est directement liée à la capacité de tracking puisque "tracker" la personne revient à maintenir une distance en faisant varier la vitesse relative du robot et du visiteur...).*
- **L'ensemble des contraintes non fonctionnelles applicables au système qui réalisera la fonction ou au processus de développement de ce système est-il complètement défini?**\
*Certaines de ces contraintes peuvent déterminer le choix de la décomposition fonctionnelle...*
    - **Quelles sont les contraintes de développement applicables?** (choix de technologies, de méthodes, de langages, etc.)
    - **Quels sont les référentiels internes applicables?**
    - **Quelles sont les contraintes règlementaires, de certification, applicables?**
    - **Quels sont les normes applicables (DO, ARP, ECSS, ISO, etc.)?**
      - **Quel est le niveau de certification (par ex. DAL) requis?**\
        *Ce niveau va imposer ou éliminer certaines solutions... Par ex. si on parle d'un système DAL A, cela éliminera les algos à base d'IA. Si le système est DAL C, cela autorisera l'usage des algorithme d'IA, mais cette IA ne pourra pas s'exécuter sur un GPU, par ex.
        Plus généralement, il va déterminer certains objectifs à atteindre et activités à mener. Ainsi, un niveau de développement "DAL A" en aéronautique va pratiquement éiminer la possibilité d'utiliser des composants logiciels sur étagère  et, dans tous les cas, va conduire à utiliser des solutions "simples" pour pouvoir réaliser ces activités à un coût raisonnable. Par exemple, certaines méthodes formelles qui permettent d'assurer un très haut niveau d'assurance ne peuvent être appliquées sur du logiciel trop complexe... ou, à l'inverse, certaines méthodes formelles imposent des langages informatiques particulier (par ex. SCADE) qui ne sont vraiment applicables que pour certains types d'algorithmes.*
  - **Le domaine opérationnel est-il bien défini?**\
    *Le domaine opérationnel (les conditions dans lesquelles le système va opérer) peut imposer ou éliminer certaines solutions (par ex. via les conditions environnementale telle que niveau de vibration, niveau de radiation, etc.)*
    - **Les exigences de sûreté de fonctionnement (fiabilité, disponibilité, etc.) sont-elles exprimées?** 
- **Les pré-conditions sur l'état du système pour que la spécification s'applique sont-elles exprimées?**

*Ces contraintes rejoignent l'ensemble de contraintes qui sera "consulté" dans toutes les phases de conception. D'autre contraintes seront ajoutées au fur et à mesure du déroulement des activités d'ingénierie.*

*On ne s'attend pas à ce  que les choses soient complètes et parfaites au départ de l'activité. Des questions vont nécessairement se poser au cours du développement, des précisions vont être requises, etc. C'est normal. Le processus de conception est un processus plutôt itératif ou la "boucle d'asservissement" qui cherche à faire converger le système de développement vers la meilleure solution doit être la plus courte possible. On ne doit pas attendre que tout soit parfait pour débuter le travail car certaines exigences "amont" peuvent significativement changer lors des premières phases de conception.*


## 1.b - Assurance de la bonne compréhension de la spécification

- **Ai-je bien compris les termes (les "mots") de la spécification?**
  - **Le sens que je donne aux termes de la spécification est-il bien celui voulu par le rédacteur de la spécification?**\
    Par exemple : 
    > REQ.: "The tracking function shall control the robot movement to maintain a distance of less than 2m from the visitor."
    >> Qu'appelez-vous "visiteur"?\
    >> Qu'est-ce qui permet de distinguer un "visiteur" d'un "non-visiteur"?
  - **Suis-je capable de reformuler la spécification en utilisant des termes différents?**
- **Suis-je capable d'énoncer un ensemble de scénarios correspondant à la spécification ?** et **Ces scénarios sont-ils pertinents pour le rédacteur de la spécification?**\
Par exemple :
    > Le visiteur se présente devant le robot. Le robot reconnait qu'il s'agit d'un visiteur. Le robot l'invite à le suivre. Le robot se déplace vers la salle de réunion. Le visiteur le suit. Le robot accélère ou ralenti afin de maintenir une distance d'au plus 2m avec lui. 

## 1.c - Assurance de la disponibilité des informations nécessaires

- **Ai-je connaissance de l'existant?**
    - **Ai-je accès aux documents de conception de systèmes similaires?**
    - **Ai-je la liste des composants sur étagère déjà disponibles, réutilisables?**
    - **Suis-je capable d'exploiter ces informations avec mes propres connaissances ou ai-je besoin de l'aide d'un expert?**
  
- **A-t-on déjà une première idée de l'architecture cible?**
  - **Ces "premières idées" sont-elles des exigences, des recommandations ou de l'information?**

# Décomposition fonctionnnelle

*L'objectif de la décomposition fonctionnelle est de réduire le problème posé par l'exigence racine ("mère") en un ensemble de problèmes plus simples jusqu'à ce que chaque problème ait une solution. Ici, une "solution" est une réalisation (ou "implémentation") de la fonction qui satisfait ses contraintes fonctionnelles.* 

- **Comment la fonction mère se décompose-t-elle en fonctions filles?**
    - **Quels sont les résultats intermédiaires qui me permettraient de produire le résultat final?**
    - **Quelles sont les fonctions qui produiraient ces résultats intermédiaires?**
    - **Comment les fonctions filles se combinents-elles pour créer un chemin allant des entrées de la fonctions à ses sorties?**

- **Quelles sont les entrées et sorties (résultats) de chaque fonction?**
  - **La fonction est-elle réalisable ?** (c-à-d ai-je une idée de la méthode / algorithme à mettre en oeuvre? l'ai-je déjà fait? la méthod / algorithme est-il déjà disponible?)
  
- **Quelle est la spécification de la fonction?**
  - **Quelle est la spécification fonctionnelle de la fonction?** (la rlation entre les entrées et les sorties, voir section, "exigences")
  - **Quelles sont les contraintes "non fonctionnelles" de la fonction? (temps de réponse, etc.)**
    - **Ces contraintes sont-elles a priori atteignables à un coût / effort acceptable?**

### Sûreté de fonctionnement
- Quelles sont les conséquence de la défaillance d'une fonction fille sur la fonction mère?
  - Quels sont les modes de défaillances de la fonction fille?
  - Comment ces défaillances se propagent-elles sur les autres fonctions et, in fine, sur la foncton mère?
  - Quelles sont les probbailité de défaillance (approche très qualitative à un premier niveau)?
  - Est-ce compatible des exigences de plus haut niveau?
  - Quelles sont les redondances (monitoring, réplication,...) à mettre en oeuvre pour tenir les exigences de spureté de fonctionnement ?

## Performances
- **Quelles ressources matérielles seront approximativement nécessaires pour réaliser la fonction?**
  - **Ces ressources sont-elles a priori compatibles des contraintes de SWaP-C (Size, Weight, Power, Cost)?**
- **Le choix des données est-il compatible des canaux de communication entre fonctions?**


# Contraintes/principes
- Les fonctions filles doivent être plus "simples" que la fonction mère, c('est-à-dire que l'on doit se rapporcher progressivement d'une solution d'implémentation...)
  - Les fonctions filles ne doivent réaliser que les traitements nécessaire à la production des résultats intermédaires requis pour réaliser la fonction mère.
- Les fonctions filles doivent pouvoir être organisées en une chaine fonctionnelle.
  - Les entrées d'une fonction fille doivent être les entrées de la fonction mère ou les sorties d'une autre fonction fille.\
  *Le processus de conception est donc d'une certaine manière global, même si on peut commencer par une fonction fille (par ex. parce qu'elle est évidente) puis introduire progressivement les autres fonctions qui vont permettre de créer les entrées de celles-ci oiu transformer les sortis de celles-ci pour arriver au résultat attentdu pour la fonction mère. Dans tous les cas, les fonctions ne sont pas créées indépendamment les unes des autres.* 
- **Les fonctions filles de plus bas niveau doivent pouvoir être réalisées par un et un seule composant.**\
  *Cette  propriété ne peut pas être vérifiée avant que l'architecture du système soit défini, mais, en général, on a une petite idée des déploiement possibles sur la base de l'expérience ou de systèmes analogues*.
- S'il existe un composant  prédéveloppé (par ex. bibliothèque logiciel, outil,...) qui produit un résultat intermédiaire, je privilégie ce composant en utilisant une ou plusieurs fonctions filles réalisées par ce compsant. Dans ce cas, je privilégie 
  - les composants développés en interne (notamment s'ils viennent avec les documents ("dossiers") requis par les processus)
  - les composants ayant une grande maturité (stables, long retour d'expérience, grand nombre d'utilisateurs)
- Je privilégie les méthodes / algorithmes bien documentés
- Dans une première approche, je privilégie les solutions "directes", "simples". Je ne m'intéresse au problème de l'optimisation que dans une deuxième phase.
  - Je n'optimise que si cela est nécessaire (si toutes les contraintes sont satisfaites, je ne vais pas plus loin) 
- J'essaie de factoriser (réeutiliser) les fonctions.\
    Il se peut que cela conduise à complexifier un peut l'architecture, mais cela peut amener à réduire le cout, accroitre la qualité etc.
- Dans la mesure du possible, je privilégie une décomposition ou les fonctions n'ont pas d'état interne (ce sont alors des fonctions au sens mathématique du terme). Les états sont explicités (par des fonction du type "stockage des images")
- Si j'ai des contraintes dures en terme de temps de réponse, je privilégie une chaine fonctionnelle que je vais pouvoir paralléliser ou pipeliner.
- Je n'introduits des éléments de solution que le plus tard possible afin de laisser le plus large choix de solution possible?

- La spécification des fonctions filles se fait progressivcement : on spécifie les contraintes les plus importantes en premier (par ex. les contraintes qui déterminent la relation entre les entrées et les sorties de la fonction) puis on affine avec des contraintes de performance, des contraintes d'implémentation. 


## Validation des exigences

(Cette tâche s'applique à l'enselble des exigences d'entrée ainsi qu'à celles produites au cours deu procecssus de conception.

### Propriétés relevant d'une exigence unique

- **L'exigence est-elle clairement énoncée?**
  - **L'exigence définit-elle clairement la fonction à réaliser?**
  - **Les termes de l'exigences sont-ils bien définis?**
- **L'exigence laisse-t-elle la place à l'interprétation?**
  - **Les termes de l'exigences sont-ils précis?**
    - **L'exigence utilise-t-elle des termes naturellement imprécis (par ex "vite", "léger") alors qu'elle fait référence à des quantités physiques mesurables (la vitesse, le poids)?**
    - **Peut-on exhiber plusieurs interprétations de l'exigence?** ou **Certains termes peuvent-ils avoir plusieurs significations  (interprétation)?** 
  - **Les entrées et les sorties de la fonction sont-elle bien définies?**
- **L'exigence est-elle justifiée?** (C'est-à-dire : n'est-ce pas une sur-spécification?). Cela s'applique notamment aux exigences qui mentionnent le choix de solutions techniques.
- **L'exigence exprime-t-elle une propriété toujours vraie ou une propriété qui peut ponctuellement être non-satisfaite?**\
 Cela relève de l'imprécision...  Par exemple: 
  > Si le robot se trouve à une distance de 2m du visiteur et que celui-ci fait un pas en arrière, la distance va être supérieure à 2m pendant un instant (éventuellement très bref). Est-ce acceptable? 
- **L'exigence est-elle vérifiable?** C-à-d : puis-je imaginer un protocole (scénario de test, procédure de vérification formelle, etc.) qui me permette de répondre à la question "L'exigence est-elle satisfaite?"
- **L'exigence est-elle cohérente?**
  - **L'exigence est-elle incohérente ?** (c-à-d : demande-t-elle quelque chose de contradictoire, d'irréalisable du type "Je veux que l'objet soit totalement rouge et totalement bleu.")
  

### Propriétés relevant de plusieurs exigences pou rune même fonctions ou des fonctions différentes

- **Les exigences sont-elle compatibles (non contradictoires)?**
  - **Suis-je capable d'exhiber un modèle dans lequel toutes les exigences seraient satisfaites?**

- **Le jeu d'exigences est-il complet?**
    **Y a-t-il des exigences portant sur toutes les entrées et sorties de la fonctions?**
    **Y a-t-il au moins une exigence qui mette en relation entre les entrées et les sorties de la fonction?** 
    **Ai-je bien pris en compte les exigences des fonctions en aval / contraintes des fonctions en amont dans la chaîne fonctionnelle?**

### Propriété relevant du lien avec les exigences en amont (traçabilité)
    
- **Ai-je bien considéré l'ensemble des contraintes générales applicables ?**
- **L'exigence est-elle traçable vers une exigence en amont (fonction mère) ou vers une exigence générale?** 
- **L'ensemble des exigences en amont a-t-il bien été pris en compte pour élaborer les exigence de la fonction? (c-à-d "telle exigence de la fonction mère détermine-t-elle une ou plusieurs exigences sur la fonction fille, exigences non fonctionnelles y compris?**)
  - **Puis-je faire une préallocation des exigences de performance sur la chaine fonctionnelle afin de faciliter le processus de conception?**
  - **Cette préallocation est-elle raisonnable?**
  - **À l'inverse, les contraintes de conception détermine-t-elle de nouvelles contraintes applicables à la fonction mère?** et **Ces contraintes sont-elles acceptables?**