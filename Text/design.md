


## 1.a - Validation des données du problème

- **L'exigence est-elle bien formulée** (cf. section "validation d'exigence" ci-après )
- **L'ensemble des contraintes est-il bien (complètement) défini?**
    **- Y a-t-il des contraintes de développement?** (choix de technologies, de méthodes, de langages, etc.)
    - **Quels sont les référentiels internes applicables?**
    - **Quelles sont les contraintes règlementaires, de certification, applicables?**
    - **Quels sont les référentiels applicables (DO, ARP, ECSS, ISO, etc.)?**
    - **Quel est le niveau de certification (par ex. DAL) requis?**\
        *Ce niveau va déterminer ou éliminer certaines solutions... Par ex. si on parle d'un système DAL A, cela éliminera les algos à base d'IA. Si le système est DAL C, cela autorisera l'usage des algorithme d'IA, mais cette IA ne pourra pas s'exécuter sur un GPU, par ex.
        Plus généralement, il va déterminer certains objectifs à atteindre et activités à mener. Ainsi, un niveau de développement "DAL A" en aéronautique va pratiquement éiminer la possibilité d'utiliser des composants logiciels sur étagère  et, dans tous les cas, va conduire à utiliser des solutions "simples" pour pouvoir réaliser ces activités à un coût raisonnable. Par exemple, certaines méthodes formelles qui permettent d'assurer un très haut niveau d'assurance ne peuvent être appliquées sur du logiciel trop complexe... ou, à l'inverse, certaines méthodes formelles imposent des langages informatiques particulier (par ex. SCADE) qui ne sont vraiment applicables que pour certains types d'algorithmes. *

*On ne s'attend pas à ce  que les choses soient complète et parfaite au départ de l'activité. Des questions vont nécessairement se poser au cours du développement, des précisions vont être requises, etc. C'est normal. On n'attend surtout pas que les choses soient "parfaites" avant de commencer le travail. Il s'agit d'un processus plutôt itératif ou la "boucle d'asservissement" qui cherche à faire converger le système de développement vers la meilleure solution doit être la plus courte possible.*

*Ces contraintes rejoignent l'ensemble de contraintes qui sera "consulté" dans toutes les phases de conception. D'autre contraintes seront ajoutées au fur et à mesure du déroulement des activités d'ingénierie.*


- **Le domaine opérationnel est-il bien défini?**\
  *Le domaine opérationnel (les conditions dans lesquelles le système va opérer) peut déterminer/éliminer certaines des solutions, par ex. via les conditions environnementale (nivceau de vibration, niveau de radiation, etc.)*
  - **Les exigences de sûreté de fonctionnement (fiabilité, disponibilité, etc.) sont-elles exprimées?** 
    	
## 1.b - Assurance de la bonne compréhension du problème

- **Ai-je bien compris les termes de la spécification?**\
    Par exemple: 
    > Qu'appelez-vous "visiteur"?\
    > Qu'est ce qui permet de distinguer un "visiteur" d'une personne "non-visiteur"?

- **Suis-je capable de reformuler le problème?**
- **Suis-je capable d'énoncer un ensemble de scénarios correspondant au problème?** et **ces scénarios sont-ils pertinents pour le Client?**

## 1.c - Assurance de la bonne compréhension du problème

- **Ai-je connaissance de l'existant?**
    - **Ai-je accès aux documents de conception de systèmes similaires?**
    - **Ai-je la liste des composants sur étagère déjà disponibles, réutilisables?**
  
- **A-t-on déjà une première idée de l'architecture cible?**

# Décomposition fonctionnnelle

*L'objectif de la décomposition fonctionnelle est de réduire le problème posé par l'exigence racine ("mère") en un ensemble de problèmes plus simples jusqu'à ce que chaque problème ait une solution. Ici, une "solution" est une réalisation (ou "implémentation") de la fonction qui satisfait ses contraintes fonctionnelles.* 

- **Comment la fonction mère se décompose-t-elle en fonctions filles?**
    - **Quels sont les résultats intermédiaires qui me permettraient de produire le résultat final?**
    - **Quelles sont les fonctions qui produiraient ces résultats intermédiaires?**
    - **Comment les fonctions filles se combinents-elles pour créer un chemin allant des entrées de la fonctons à ses sorties?**

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
  - **N'y a-t-il qu'une seule façon d'interpréter l'exigence?** 
  - **Les entrées et les sorties attendues de la fonction sont-elle bien définies?**
- **L'exigence est-elle justifiée?** (n'est-ce pas une sur-spécification). Cela s'applique notamment aux exigences qui mentionnent le choix de solutions techniques.

- **L'exigence est-elle vérifiable?** C-à-d : puis-je imaginer un protocole (scénario de test, procédure de vérification formelle, etc.) qui me permette de répondre à la question "L'exigence est-elle satisfaite?"
- **L'exigence est-elle cohérente?**
  - **L'exigence est-elle incohérente ?** (c-à-d : demande-t-elle quelque chose de contradictoire, d'irréalisable du type "Je veux que l'objet soit totalement rouge et totalement bleu.")
  

### Propriétés relevant de plusieurs exigences

- **Les exigences sont-elle compatibles (non contradictoires)?**
  - **Suis-je capable d'exhiber un modèle dans lequel l'ensemble des exigences seraient satisfaites?**

- **Le jeu d'exigences est-il complet?**
    **Y a-t-il des exigences sur toutes les entrée et les sorties de la fonctions?**
    **Ai-je bien pris en compte les exigences des fonctions en aval / contraintes des fonctions en amont dans la chaîne fonctionnelle?**

### Propriété relevant du lien avec les exigences en amont (traçabilité)
    
- **Ai-je bien considéré l'ensemble des contraintes générales applicables ?**
- **L'exigence est-elle traçable vers une exigence en amont (fonction mère) ou vers une exigence générale?** 
- **L'ensemble des exigences en amont a-t-il bien été pris en compte pour élaborer les exigence de la fonction? (c-à-d "telle exigence de la fonction mère détermine-t-elle une ou plusieurs exigences sur la fonction fille, exigences non fonctionnelles y compris?**)
  - **Puis-je faire une préallocation des exigences de performance sur la chaine fonctionnelle afin de faciliter le processus de conception?**
  - **Cette préallocation est-elle raisonnable?**
  - **À l'inverse, les contraintes de conception détermine-t-elle de nouvelles contraintes applicables à la fonction mère?** et **Ces contraintes sont-elles acceptables?**