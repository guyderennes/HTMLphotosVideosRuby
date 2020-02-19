#!/usr/bin/ruby -wU

class String
 # Cette classe spécifie la classe String "officielle".
 # Elle utilise des instances de mes autres classes pour fabriquer tous les fichiers html dont j'ai besoin pour mes photos et vidéo
 # invocation : Par exemple "./".genereHTML : C'est grâce à l'héritage que l'on peut faire cette invocation.
 # Guy Béchet gabechet@gmail.com : 02/11/2013

 def genereHTML(webIcon)

	d = Dir.glob(self + "**/")
	# Donne par exemple 	["/home/guy/Desktop/Photos/", "/home/guy/Desktop/Photos/Rep01/", "/home/guy/Desktop/Photos/Rep01/Rep02/"]
	# À partir de là je veux : 	["Photos/", "Photos/Rep01/", "Photos/Rep01/Rep02/"]

	# lengthToDel sera 18 pour l'exemple ci-dessus de Photos
	lengthToDel = d[0].length - Dir.pwd.split('/')[Dir.pwd.split('/').length - 1].length - 1

	repAvantImages = Reglages::REP_AVANT_IMAGES
	modulo = Reglages::MODULO
	largeurVignettes = Reglages::LARGEUR_VIGNETTES
	hauteurVignettes = Reglages::HAUTEUR_VIGNETTES
	rapportHauteurLargeur = Reglages::COEFF_RAPPORT_HAUTEUR_LARGEUR_ECRAN
	afficheNum = Reglages::AFFICHE_NUMERO
	pageColor = Reglages::COULEUR
	urlDisqueDepart = Reglages::URL_DISK_DEPART
	urlAutreDisk = Reglages::URL_AUTRE_DISK
	iconeNameLocal = Reglages::ICONE_NAME_LOCAL 
	iconeNameDistant = Reglages::ICONE_NAME_SERVER

	# repertoireAbsolu sera "/home/guy/Desktop/Photos/" puis "/home/guy/Desktop/Photos/Rep01/" puis ...
	d.each { |repertoireAbsolu|
		# repertoireAvecSonCheminRelatif sera "Photos/" puis "Photos/Rep01/" puis "Photos/Rep01/Rep02/"
		repertoireAvecSonCheminRelatif = repertoireAbsolu[lengthToDel..lengthToDel + repertoireAbsolu.length]
		nbSlash = repertoireAvecSonCheminRelatif.count "/"
		pathRelatifDesIconesSave = "../" * (nbSlash - 1)

		# Duplication du code pour n'avoir qu'un seul if
		if webIcon.empty?
			pathRelatifDesIcones = "../" * (nbSlash - 1)

			# Fabrication de l'ensemble des .indexN.html pour ce répertoire
			generateurIndexN = IndexN.new(repertoireAvecSonCheminRelatif, pathRelatifDesIcones, iconeNameLocal)
			generateurIndexN.genere_code
			generateurIndexN = nil	# Pour libérer de la mémoire (si le GC ne le fait pas assez vite ?)

			# Fabrication de l'index.html pour ce répertoire
			generateurIndex = Index.new(repertoireAvecSonCheminRelatif, pathRelatifDesIconesSave, repAvantImages, modulo, webIcon, pageColor, urlDisqueDepart, urlAutreDisk, iconeNameLocal)
			generateurIndex.genere_code
			generateurIndex = nil

			# Fabrication des fichiers htm dans .CALIBRAGE et des vignettes des photos dans .VIGNETTES
			generateurCalibrageEtVignettes = Calibrage.new(repertoireAvecSonCheminRelatif, pathRelatifDesIcones, rapportHauteurLargeur, largeurVignettes, hauteurVignettes, afficheNum, iconeNameLocal)
			generateurCalibrageEtVignettes.genereVignettesEtCodeHtmlDansCalibrage
			generateurCalibrageEtVignettes = nil
		else 	# les icônes sont référencés sur le serveur Web de ORANGE
			pathRelatifDesIcones = webIcon

			# Fabrication de l'ensemble des .indexN.html pour ce répertoire
			generateurIndexN = IndexN.new(repertoireAvecSonCheminRelatif, pathRelatifDesIcones, iconeNameDistant)
			generateurIndexN.genere_code
			generateurIndexN = nil	# Pour libérer de la mémoire (si le GC ne le fait pas assez vite ?)

			# Fabrication de l'index.html pour ce répertoire
			generateurIndex = Index.new(repertoireAvecSonCheminRelatif, pathRelatifDesIconesSave, repAvantImages, modulo, webIcon, pageColor, urlDisqueDepart, urlAutreDisk, iconeNameDistant)
			generateurIndex.genere_code
			generateurIndex = nil

			# Fabrication des fichiers htm dans .CALIBRAGE et des vignettes des photos dans .VIGNETTES
			generateurCalibrageEtVignettes = Calibrage.new(repertoireAvecSonCheminRelatif, pathRelatifDesIcones, 	rapportHauteurLargeur, largeurVignettes, hauteurVignettes, afficheNum, iconeNameDistant)
			generateurCalibrageEtVignettes.genereVignettesEtCodeHtmlDansCalibrageWeb
			generateurCalibrageEtVignettes = nil
		end
	}
 end
end
# ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
