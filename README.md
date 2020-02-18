# HTMLphotosVideosRuby
Pour regarder mes photos locales dans un navigateur web. Langage Ruby
Ce programme génère automatiquement hiérarchiquement le code html à partir de fichiers de type :
	o Images ayant les suffixes jpg, jpeg et png en majuscules ou minuscules.
	o PDF avec les suffixes pdf en majuscules ou minuscules.
	o Archives avec les suffixes zip en majuscules ou minuscules.
	o Audio ou vidéo avec n'importe quelle type d'extension car c'est l'entête qui est lue. 
Le code généré pour les fichiers multimédias audio/video est du html5, ce qui signifie en 2014 que seuls les containers webm et mpeg4 sont pris en compte ; ils permettent le streaming, c'est-à-dire la visualisation directe.
