#!/usr/bin/ruby -wU

module Reglages
	# Dans Calibrage.rb
	LARGEUR_VIGNETTES = 147
	HAUTEUR_VIGNETTES = 147
	
	# Dans Index.rb
	MODULO = 4
	
	# Fonction du fond d'écran. Mais pas très spectaculaire, le plus souvent laisser false.
	ECRITURES_ADAPTATIVES = false
	
	# Dans Index.rb la teinte de fond de la page web était par défaut 339999. => BGCOLOR='#339999'
	# Voir http://www.code-couleur.com/dictionnaire/couleur-j.html
	COULEUR = "DD985C"
	
	# Affichage de (numéro photo en cours d'affichage) / (Nombre total de photos du répertoire en cours)
	AFFICHE_NUMERO = true
	
	# S'il n'y a pas un .Icones/ à l'endroit où on lance ce générateur de code, on cherche les icones sur le web
	# ICONES_SUR_LE_WEB = "https://www.guyderennes.fr/Photos/"
	ICONES_SUR_LE_WEB = "http://guyvac.pagesperso-orange.fr/"

	# Pour faire apparaître ou non les répertoires avant les images dans les index.html : true ou false
	REP_AVANT_IMAGES = false
	
	# runHtmlPhotos.rb selon true ou false, efface ou non les répertoires .CALIBRAGE
	# ATTENTION si false, risque d'affichages incohérents d'1 photo à l'autre, si modifs
	DELETE_CALIBRAGE = true
	
	# runHtmlPhotos.rb selon true ou false, efface ou non les répertoires .VIGNETTES
	DELETE_VIGNETTES = false
	
	# Utilisé dans Calibrage.rb pour afficher au mieux l'image sur l'écran.
	# La valeur 1.6 se rapproche le plus souvent du rapport Largeur/Hauteur des écrans actuels
	COEFF_RAPPORT_HAUTEUR_LARGEUR_ECRAN = 1.6
	
	# Dans index.html du 2eme serveur, ce paramètre pointe le 1er serveur à la ligne où il y a "Départ"
	# Seules les syntaxes   URL_DISK_DEPART = "http://serveur/chemin/"   ou  URL_DISK_DEPART = ""  sont autorisées
	# Quand URL_DISK_DEPART = "" et  URL_AUTRE_DISK = "" alors le site est sur le même ordinateur
	URL_DISK_DEPART = ""

	# Dans index.html du 1er serveur rempli, ce param aide à parfaire le pointage vers des vignettes du 2eme serveur. 
	# Seules les syntaxes URL_AUTRE_DISK = "http://autreDisque/chemin2/"  ou  URL_AUTRE_DISK = ""  sont autorisées
	# Quand URL_DISK_DEPART = "" et  URL_AUTRE_DISK = "" alors le site est sur le même ordinateur
	# Si 2me serveur est Google Drive, je me mets sur le rép à afficher. Je récupère le lien de partage :
	# https://drive.google.com/folderview?id=0BwnePHI2YFZ1flBBX3lyLVNTMEhZR0VHUEh6VnFEa2gxRlowdGdkZXhBeEY2RzcxQ2tfaFU&usp=sharing
	# d'où URL_AUTRE_DISK = "https://www.googledrive.com/host/0BwnePHI2YFZ1flBBX3lyLVNTMEhZR0VHUEh6VnFEa2gxRlowdGdkZXhBeEY2RzcxQ2tfaFU/"
	URL_AUTRE_DISK = ""

	# Non du répertoire local où sont mis les icônes. Dans la version actuelle, doit commencer obligatoirement par un point "."
	ICONE_NAME_LOCAL = ".Icones"

	# Non du répertoire distant où sont mis les icônes. Peut commencer par un "." mais pas pour le serveur ORANGE en 2018
	ICONE_NAME_SERVER = "ICONES"
end
