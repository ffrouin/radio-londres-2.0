# Initialisation des données applicatives de "Radio Londres 2.0"

## Téléchargement de la playlist

> # wget https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/RadioLondres.pl
> # chmod +x RadioLondres.pl
> # ./RadioLondres.pl

## Insertion de la playlist musicale

> # mpc ls chanson |mpc add
> # mpc ls accordeon |mpc add
> # mpc ls jazz |mpc add

Then run this a couple of time, in order to mix content

> # mpc shuffle

Verify result

> # mpc playlist

## Mise en place du script RadioLondres.sh

## Mise en place de la contrab

Insérer le contenu du fichier [crontab.txt](https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/crontab.txt) dans la crontab de l'usager retenu pour gérer la programmation de "Radio Londres 2.0"
