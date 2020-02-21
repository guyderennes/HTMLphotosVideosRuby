Ce progarmme génère du html s'il trouve des fichiers de type jpg, png, gif, webp, audios, vidéos, pdf et zip dans la hierrarchie du dossier.
On peut ainsi visualiser ces fichiers précédents via un navigateur web.

runHtmlPhotos.rb contient le programme principal.

Il s'agit d'un petit utilitaire ruby, qui appelle à un moment donné des fonctions shell Unix/Linux.

Il faudra décompresser Icones.tar.gz et copier ". Icones" dans le dossier de ses photos ou mettre ce dossier ". Icones" sur un serveur web, ce qui nécessitera de modifier ce programme Ruby en conséquence, car le serveur Orange, mis dans ce programme, ne fonctionne plus. 

Les répertoires .VIGNETTES et .CALIBRAGE sont d'abord éventuellemnt effacés selon la configuration inscrite dans Reglages.rb, soit par exemple :
		DELETE_CALIBRAGE = true
		DELETE_VIGNETTES = false
		REP_AVANT_IMAGES = false
