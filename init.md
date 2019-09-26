# Initialisation des données applicatives de "Radio Londres 2.0"

Avec l'installation précedemment réalisée, tous les usagers du poste VOTRE_NOM_D_HOTE peuvent manipuler le daemon MPD.

Si vous souhaitez restreindre cet accès, vous pouvez le protéger avec un login et mot de passe ([voir documentation MPD](https://www.musicpd.org/doc/html/user.html#permissions-and-passwords)). Dans ce cas, il faudra modifier le script RadioLondres.sh afin que la commande mpc utilise l'authentification.

Vous pouvez donc choisir un utilisateur existant ou en créer un nouveau pour ce besoin.

Mettez-vous dans l'environnement de cet usager :

```
  # sudo su - mon_usager
```

## Téléchargement de la playlist

```
  # wget https://raw.githubusercontent.com/ffrouin/radio-londres-2.0/master/RadioLondres.pl
  # chmod +x RadioLondres.pl
  # mkdir youtube
  # ./RadioLondres.pl init youtube
  # sudo mv youtube/* /var/lib/mpd/music/
  # rmdir youtube
  # mpc update
```

## Insertion de la playlist musicale
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

```
  # crontab -e
```
