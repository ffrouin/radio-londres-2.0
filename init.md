# Initialisation des données applicatives de "Radio Londres 2.0"

## Téléchargement de la playlist

```
  # wget https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/RadioLondres.pl
  # chmod +x RadioLondres.pl
  # ./RadioLondres.pl
```

## Insertion de la playlist musicale
```
 # mpc ls chanson |mpc add
 # mpc ls accordeon |mpc add
 # mpc ls jazz |mpc add
```

Lancez plusieurs fois la commande suivante pour mélanger le contenu
```
  # mpc shuffle
```
Vérifiez le résultat
```
  # mpc playlist
```

## Démarrez la radio
```
  # mpc play
```

## Vérifier l'accès au service webradio
```
https://VOTRE_NOM_D_HOTE:8080/RadioLondres.ogg
```
## Mise en place du script RadioLondres.sh
```
  # wget https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/RadioLondres.sh
  # chmod +x RadioLondres.sh
```

## Mise en place de la contrab

Insérer le contenu du fichier [crontab.txt](https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/crontab.txt) dans la crontab de l'usager retenu pour gérer la programmation de "Radio Londres 2.0"
