# [Radio Londres 2.0](https://freddy.linuxtribe.fr/radio-londres/)
Radio Londres 2.0 est un projet citoyen visant à faire connaître le programme "Les Jours Heureux" adopté par le Conseil National de la Résistance au sortir de la 2eme guerre mondiale. Il s'agit d'une webradio qui va diffuser des archives audios.

Radio Londres 2.0 est aussi un projet citoyen visant à faire connaître les luttes sociales peu ou mal médiatisées par les médias traditionnels. Dans notre cas, c'est la lutte des #GiletsJaunes dont certains évênements, interviews seront intégrés à la playlist.

#CivicTech #FrenchTech

## Prérequis
Afin de pouvoir utiliser les données présentées dans ce document pour mettre en place votre propre instance "Radio Londres 2.0" vous avez besoin de disposer d'un équipement muni :
+ d'un [Système d'Exploitation GNU/Linux](https://fr.wikipedia.org/wiki/Liste_des_distributions_GNU/Linux)
+ d'un accès à internet :
- ADSL attention au canal remontant qui limitera le nombre d'accès simultanés à moins de dégrader la qualité audio)
- VDSL ou Fibre sont un bon compris pour une diffusion limitée
+ pas d'indication particulière concernant la capacité de calcul et la mémoire vive à prévoir (audit en cours)

## [Installation](install.md)

# Architecture fonctionnelle

## Composants applicatifs

### [MPD - Music Player Daemon](https://www.musicpd.org/)
Ce composant applicatif s'occupe de générer un flux audio continu sur la base d'une playlist.

### [MPC - Music Player Client](https://www.musicpd.org/clients/mpc/)
Ce composant applicatif sera utilisé pour manipuler la playslit à chaud (insertions, suppressions)

### [Icecast2](http://icecast.org/)
Ce composant applicatif s'occupe de la diffusion du flux audio

### Serveur web
Ce composant applicatif a pour fonction de donner accès au service de diffusion et de permettre de protéger le serveur de diffusion en cas d'attaque de type DDoS.
Il permettra également de présenter le projet: [Radio Londres 2.0](https://freddy.linuxtribe.fr/radio-londres)

On pourra utiliser différents composants ayant déjà fait preuve de leur robustesse dans ce domaine :
+ [Apache2](http://httpd.apache.org/)
+ [Nginx](https://nginx.org/en/)

## Source de données
L'idée est d'avoir un moyen industrialisé pour peupler la webradio avec les données recherchées.

### Youtube
La plateforme youtube offre l'énorme avantage de contenir une masse assez impressionnante de données. Dans le cadre du projet "Radio Londres 2.0" elle permet de constituer l'ensemble de la playlist. La playlist sera initialisée au moyen de l'utilitaire [youtube-dl](https://ytdl-org.github.io/youtube-dl/index.html).

## Gestion des programmes
Une webradio doit offrir des mécanismes de base : insertion de programmes à heures fixes, jingle de début et de fin pour encadrer des programmes, modification de la playlist, etc. Un petit script shell appelé en crontab nous permettra de répondre à ce besoin.

### Script shell
Disponible dans tous les environnements GNU/Linux, bash sera utilisé.

### [Crontab](https://fr.wikipedia.org/wiki/Cron)
La crontab permet d'appeler des commandes à heure fixe en environnement GNU/Linux. Elle sera utilisée pour constituer la grille des programmes.
