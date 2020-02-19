#!/usr/bin/ruby -wU

class Calibrage
# Cette classe sert à fabriquer tous les fichiers html des répertoires .CALIBRAGE ainsi que les vignettes des photos dans .VIGNETTES
# invocation : generateurFichCALIBRAGE = Calibrage.new(cheminPhotos,pathRelatifDesIcones)
# cheminPhotos est par exemple un/deux/trois/ qui va servir à s'occuper des ./un/deux/trois/.CALIBRAGE/photo.htm

# Guy Béchet gabechet@gmail.com : V1 : 30/10/2013
# V2 Ajout de choixLargeurOuHauteur(picture) pour que l'affichage soit optimisé sur un écran rectangulaire en corrélation avec les dimensions hauteur, largeur de l'image

# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
	def initialize(pathDir, iconePath, dimEcran, largeur_Vignettes, hauteur_Vignettes, afficheNum, iconeName)
	
  	# J'ai pathDir du style : Vacances2014/   Vacances2014/camping/   Vacances2014/camping/mer/
  	# Pour avoir @pathDir avec des chemins du style ./   ./camping/   ./camping/mer/
  	# J'utilise la méthode slice(start, length) : "abcdefghijklm".slice(5,3) => "fgh"
  	@pathDir = "." + pathDir.slice(pathDir.split('/')[0].length, pathDir.length)
		@infos = RecupList.new(@pathDir)
		@nbPhotos = @infos.nbPhotos
		@listePhotos = @infos.listeDesPhotos
		@iconePath = iconePath
		@rapportDimEcran = dimEcran
		@largeurVignettes = largeur_Vignettes
		@hauteurVignettes = hauteur_Vignettes
		@afficheNum = afficheNum
		@iconeName = iconeName

		if @nbPhotos > 0
			Dir.mkdir(@pathDir + ".VIGNETTES") unless Dir.exist?(@pathDir + ".VIGNETTES")
  		Dir.mkdir(@pathDir + ".CALIBRAGE") unless Dir.exist?(@pathDir + ".CALIBRAGE")
		end
	end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
#def choixLargeurOuHauteur(picture)
#	if MiniMagick::Image.read(picture).first.rows*@rapportDimEcran > MiniMagick::Image.read(picture).first.columns
#		return "height"
#	else
#		return "width"
#	end
#end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def choixLargeurOuHauteur(picture)
	if MiniMagick::Image.open(picture).height*@rapportDimEcran > MiniMagick::Image.open(picture).width
		return "height"
	else
		return "width"
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def genereVignettesEtCodeHtmlDansCalibrage
	@nbPhotos.times do |i|
		if not File.exist?(@pathDir + ".VIGNETTES/" + @listePhotos[i]) then vignettes(i) end 
		if not File.exist?(@pathDir + ".CALIBRAGE/" + @listePhotos[i].split('.')[0] + ".htm") then calibrages(i) end	
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def genereVignettesEtCodeHtmlDansCalibrageWeb
	@nbPhotos.times do |i|
		if not File.exist?(@pathDir + ".VIGNETTES/" + @listePhotos[i]) then vignettes(i) end 
		if not File.exist?(@pathDir + ".CALIBRAGE/" + @listePhotos[i].split('.')[0] + ".htm") then calibragesWeb(i) end	
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
private
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
#def vignettes(i)	
#	# Fabrication de .VIGNETTES/@listePhotos[i]
#	img = ImageList.new(@pathDir + @listePhotos[i])
#	thumb = img.resize_to_fit(@largeurVignettes, @hauteurVignettes)
#	thumb.write @pathDir + ".VIGNETTES/" + @listePhotos[i]
#	img = nil	
#end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def vignettes(i)
	# Fabrication de .VIGNETTES/@listePhotos[i] Utilisation de MiniMagick car Magick prend trop de place mémoire
	MiniMagick::Tool::Convert.new do |convert|
  		convert << @pathDir + @listePhotos[i]  # Image d'entrée à convertir en vignette
  		convert.merge! ["-resize", @largeurVignettes.to_s+"x"+@hauteurVignettes.to_s]
  		convert << @pathDir + ".VIGNETTES/" + @listePhotos[i] # la vignette
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def calibrages(i)
	# Fabrication de .CALIBRAGE/@listePhotos[i].htm en y insèrant le code html
  fich = File.new(@pathDir + ".CALIBRAGE/" + @listePhotos[i].split('.')[0] + ".htm", "a+")
  fich.puts "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>"
  fich.puts "<HTML>"
  fich.puts "	<HEAD>"
  fich.puts "		<TITLE>" + @listePhotos[i] + "</TITLE>"
  fich.puts "	</HEAD>"
  fich.puts "	<BODY BGCOLOR='#000000' TEXT='#ffffff'>"
  x = (i+1).to_s + "/" + @nbPhotos.to_s
  if @afficheNum
  	fich.puts x
  end
  fich.puts "		<CENTER>"
  if i != @nbPhotos - 1
    fich.puts "			<A HREF='./" + @listePhotos[i+1].split('.')[0] + ".htm" + "'><IMG SRC='../" + @listePhotos[i] + "' " + choixLargeurOuHauteur(@pathDir + @listePhotos[i]) + "='100%' ALT='" + @listePhotos[i] + "'></A>"
    fich.puts "			<A HREF='../index.html'><IMG SRC='../#{@iconePath}#{@iconeName}/Prev.svg' ALIGN=LEFT ALT='Up'></A>"
  else
    fich.puts "			<A HREF='../index.html'><IMG SRC='../" + @listePhotos[i] + "' " + choixLargeurOuHauteur(@pathDir + @listePhotos[i]) + "='100%' ALT='" + @listePhotos[i] + "'></A>"
  end
    	
  if i >= 1
    # Ajout flèche pour revenir sur la photo précédente
    fich.puts "			<A HREF='./" + @listePhotos[i-1].split('.')[0] + ".htm" + "'><IMG SRC='../#{@iconePath}#{@iconeName}/Back.svg' ALIGN=LEFT ALT='Up'></A>"
  end
    	
  fich.puts "		</CENTER>"
  fich.puts "	</BODY>"
  fich.puts "</HTML>"
  fich.close	
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def calibragesWeb(i)
	# Fabrication de .CALIBRAGE/@listePhotos[i].htm en y insèrant le code html
  fich = File.new(@pathDir + ".CALIBRAGE/" + @listePhotos[i].split('.')[0] + ".htm", "a+")
  fich.puts "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>"
  fich.puts "<HTML>"
  fich.puts "	<HEAD>"
  fich.puts "		<TITLE>" + @listePhotos[i] + "</TITLE>"
  fich.puts "	</HEAD>"
  fich.puts "	<BODY BGCOLOR='#000000' TEXT='#ffffff'>"
  x = (i+1).to_s + "/" + @nbPhotos.to_s
  if @afficheNum
  	fich.puts x
  end
  fich.puts "		<CENTER>"
  if i != @nbPhotos - 1
    fich.puts "			<A HREF='./" + @listePhotos[i+1].split('.')[0] + ".htm" + "'><IMG SRC='../" + @listePhotos[i] + "' " + choixLargeurOuHauteur(@pathDir + @listePhotos[i]) + "='100%' ALT='" + @listePhotos[i] + "'></A>"
    fich.puts "			<A HREF='../index.html'><IMG SRC='#{@iconePath}#{@iconeName}/Prev.svg' ALIGN=LEFT ALT='Up'></A>"
  else
    fich.puts "			<A HREF='../index.html'><IMG SRC='../" + @listePhotos[i] + "' " + choixLargeurOuHauteur(@pathDir + @listePhotos[i]) + "='100%' ALT='" + @listePhotos[i] + "'></A>"
  end
    	
  if i >= 1
    # Ajout flèche pour revenir sur la photo précédente
    fich.puts "			<A HREF='./" + @listePhotos[i-1].split('.')[0] + ".htm" + "'><IMG SRC='#{@iconePath}#{@iconeName}/Back.svg' ALIGN=LEFT ALT='Up'></A>"
  end
    	
  fich.puts "		</CENTER>"
  fich.puts "	</BODY>"
  fich.puts "</HTML>"
  fich.close	
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
end
