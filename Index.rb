#!/usr/bin/ruby -wU

class Index

# Cette classe sert à fabriquer tous les fichiers index.html dont j'ai besoin pour mes photos.
# invocation : generateurIndex = Index.new("./", "../")
# Le 1er paramètre est l'endroit d'où est lancé le programme et le second le chemin relatif du répertoire des Icônes

# Guy Béchet gabechet@gmail.com : 28/10/2013
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def initialize(pathDir, iconePath, repAvantLesImages, moduloNbVignettes, webIcone, color, urlDisqueDepart, urlAutreDisk, iconeName)
	@repDuHaut = pathDir.split('/')[0]

  # J'ai pathDir du style : Vacances2014/   Vacances2014/camping/   Vacances2014/camping/mer/
  # Pour avoir @pathDir avec des chemins du style ./   ./camping/   ./camping/mer/
  # J'utilise la méthode slice(start, length) : "abcdefghijklm".slice(5,3) => "fgh"
  @pathDir = "." + pathDir.slice(pathDir.split('/')[0].length, pathDir.length)
  	
	@urlDisqueDepart = urlDisqueDepart
	@urlAutreDisk = urlAutreDisk
  @iconePathSave = iconePath
	@infos = RecupList.new(@pathDir)
	@nbPhotos = @infos.nbPhotos
	@nbRep = @infos.nbRep
  @listePhotos = @infos.listeDesPhotos
  @listeRep = @infos.listeRep
  @listeAudioVideo = @infos.listeAudioVideo
	@nbMultimedias = @infos.nbAudioVideo
	@listeDesPDF = @infos.listeDesPDF
	@nbPDF = @infos.nbPDF
	@repAvant_Images = repAvantLesImages
	@modulo = moduloNbVignettes
	@max = @nbPhotos + @nbRep
	webIcone.empty? ? @iconePath = iconePath : @iconePath = webIcone
	@listeDesZIP = @infos.listeDesZIP
  @nbZIP = @infos.nbZIP
  @couleur = color
  @iconeName = iconeName

	if Reglages::ECRITURES_ADAPTATIVES
  	# Mise du complément de la couleur de fond pour les écritures et liens afin de voir les écritures
		@couleur != "777777" ? @linkColor = (0xFFFFFF - @couleur.to_i(16)).to_s(16) : @linkColor = "000000"
	else
		@linkColor = "000000"
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def genere_code
  # Si besoin appelle toutes les autres méthodes privées de cette classe.

		#if @nbPhotos + @nbRep + @nbMultimedias + @nbPDF > 0  # Génère index.html dans répertoire vide
		@fich = File.new(@pathDir + "index.html", "a+")
		insere_enteteSimple
		insere_codeRelatif_Multimedias
		insere_codeRelatif_PDF
		insere_codeRelatif_ZIP
			
		if @repAvant_Images
			# Pour un répertoire donné s'il y a des sous-répertoires, on insère le code html relatif à un tableau
			insere_refTableauPourPhotos if @nbRep > 0
			insere_codeRelatif_repertoires
				
			# Pour ce même répertoire donné, s'il n'y a que des photos, on insère le code html relatif à un tableau
			insere_refTableauPourPhotos if !(@nbRep > 0) && @nbPhotos > 0
			insere_codeRelatif_photos
		else
			# Pour un répertoire donné, s'il y a des photos, on insère le code html relatif à un tableau
			insere_refTableauPourPhotos if @nbPhotos > 0
			insere_codeRelatif_photos
				
			# Pour ce même rep donné, s'il n'y a que des sous-rep, on insère le code html relatif à un tableau
			insere_refTableauPourPhotos if !(@nbPhotos > 0) && @nbRep > 0
			insere_codeRelatif_repertoires
		end
			# Insertion du code de fin de tableau s'il y a des photos ou des répertoires
			insere_FinRefTableau if (@nbRep + @nbPhotos) > 0
			
			insere_codeFinal
			@fich.close
		#end
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
private
  def insere_enteteSimple
   # Entête classique du code html quand il n'y a ni vidéo ni audio
   repCourant = dirCourantCorrespondant
   if not repCourant.eql?(".")
   	@fich.puts "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>"
   	@fich.puts "<HTML>"
   	@fich.puts "	<HEAD>"
   	@fich.puts "		<TITLE>" + repCourant + "</TITLE>"
   	@fich.puts "	</HEAD>"
   	@fich.puts "	<BODY TEXT='#000000' BGCOLOR='##{@couleur}' LINK='##{@linkColor}' VLINK='##{@linkColor}' ALINK='##{@linkColor}'>"
   	@fich.puts "		<font size='+2'>" + repCourant + "</font><hr>"
   	if @urlDisqueDepart.empty?
   		@fich.puts "		<A HREF='../index.html'>Vignettes pr&eacute;c&eacute;dentes</A>  OU  <A HREF='#{@iconePathSave}index.html'>D&eacute;part</A>"
   	else
   		@fich.puts "		<A HREF='../index.html'>Vignettes pr&eacute;c&eacute;dentes</A>  OU  <A HREF='#{@urlDisqueDepart}index.html'>D&eacute;part</A>"
   	end
   else
   	@fich.puts "<?xml version='1.0' encoding='UTF-8'?><!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.0 Transitional//EN'>"
   	@fich.puts "<HTML>"
   	@fich.puts "	<HEAD>"
   	@fich.puts "		<TITLE>" + @repDuHaut + "</TITLE>"
   	@fich.puts "	</HEAD>"
   	@fich.puts "	<BODY TEXT='#000000' BGCOLOR='##{@couleur}' LINK='##{@linkColor}' VLINK='##{@linkColor}' ALINK='##{@linkColor}'>"
   	@fich.puts "		<font size='+2'>" + @repDuHaut + "</font><hr>"
   	if not @urlDisqueDepart.empty?
   		@fich.puts "		<A HREF='#{@urlDisqueDepart}index.html'>D&eacute;part</A>"
   	end
		# À corriger manuellement quand ce programme aura été exécuté
		if not @urlAutreDisk.empty?
			@fich.puts "<!-- Ajouter au dessous au bon endroit, pour référencer les vignettes de l'autre serveur -->" 
			@fich.puts "<!-- 			<TD ALIGN=CENTER><A HREF='#{@urlAutreDisk}path1Choisi/index.html'><IMG SRC='#{@urlAutreDisk}path2Choisi/.VIGNETTES/image2.jpg' ALT='image2.htm'><BR>image2</A></TD> -->"
		end
   	
   end
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def insere_refTableauPourPhotos
   @fich.puts "		<TABLE WIDTH='90%' CELLSPACING=4><TR>"
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def insere_refTableauPourMultimedias
		@fich.puts "		<TABLE BORDER=0 WIDTH='100%'><TR>"
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def insere_FinRefTableau
		@fich.puts "		</TR></TABLE>"
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def insere_codeFinal
   @fich.puts "	</BODY>"
   @fich.puts "</HTML>"
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def insere_codeRelatif_repertoires
	if @repAvant_Images
		@nbRep.times do |i|
		@fich.puts "			<TD ALIGN=CENTER><A HREF='#{@listeRep[i]}/index.html'><IMG SRC='#{@iconePath}#{@iconeName}/Suite.png' ALT='#{@listeRep[i]}/index.html'><BR>#{@listeRep[i]}</A></TD>"                          
		@fich.puts "			</TR><TR>" if ((i+1) % @modulo == 0) & ((i+1) < @max)
		end
	else
		@nbRep.times do |i|
			@fich.puts "			<TD ALIGN=CENTER><A HREF='#{@listeRep[i]}/index.html'><IMG SRC='#{@iconePath}#{@iconeName}/Suite.png' ALT='#{@listeRep[i]}/index.html'><BR>#{@listeRep[i]}</A></TD>"                          
			@fich.puts "			</TR><TR>" if ((i+1+@nbPhotos) % @modulo == 0) & ((i+1+@nbPhotos) < @max)
		end
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def insere_codeRelatif_photos
	if @repAvant_Images
		@nbPhotos.times do |i|
			@baseNamePhotoEnCours = File.basename("#{@listePhotos[i]}", ".*")
			@fich.puts "			<TD ALIGN=CENTER><A HREF='.CALIBRAGE/#{@baseNamePhotoEnCours}.htm'><IMG SRC='.VIGNETTES/#{@listePhotos[i]}' ALT='.CALIBRAGE/#{@baseNamePhotoEnCours}.htm'><BR>#{@baseNamePhotoEnCours}</A></TD>"
			@fich.puts "			</TR><TR>" if ((i+1+@nbRep) % @modulo == 0) & ((i+1+@nbRep) < @max)
		end
	else
		@nbPhotos.times do |i|
			@baseNamePhotoEnCours = File.basename("#{@listePhotos[i]}", ".*")
			@fich.puts "			<TD ALIGN=CENTER><A HREF='.CALIBRAGE/#{@baseNamePhotoEnCours}.htm'><IMG SRC='.VIGNETTES/#{@listePhotos[i]}' ALT='.CALIBRAGE/#{@baseNamePhotoEnCours}.htm'><BR>#{@baseNamePhotoEnCours}</A></TD>"
			@fich.puts "			</TR><TR>" if ((i+1) % @modulo == 0) & ((i+1) < @max)
		end
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def insere_codeRelatif_Multimedias

		insere_refTableauPourMultimedias if @nbMultimedias > 0
  	@nbMultimedias.times do |i|
  		x = i.to_s
  		y = ".index" + x + ".html"
  		if @infos.typeAudio_ou_Video(@pathDir + @listeAudioVideo[i]) == "Video"
  			z = "#{@iconePath}" + "#{@iconeName}/film.png"
  		else
  			z = "#{@iconePath}" + "#{@iconeName}/loudspeaker.png"
  		end
   		nomBase = File.basename(@listeAudioVideo[i], ".*")
   		@fich.puts "			<TD ALIGN=CENTER><A HREF='#{y}'><IMG SRC='#{z}' ALT='film introuvable'><BR>#{nomBase}</A></TD>"
    	@fich.puts "			</TR><TR>" if ((i+1) % @modulo == 0)  & ((i+1) < @nbMultimedias)
    end
    insere_FinRefTableau if @nbMultimedias > 0    
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def insere_codeRelatif_PDF

		insere_refTableauPourMultimedias if @nbPDF > 0
  	@nbPDF.times do |i|
  		z = "#{@iconePath}" + "#{@iconeName}/adobe.png"
    	@fich.puts "			<TD ALIGN=CENTER><A HREF='#{@listeDesPDF[i]}' target=_blank><IMG SRC='#{z}' ALT='#{@listeDesPDF[i]} introuvable'><BR>#{@listeDesPDF[i]}</A></TD>"
    	@fich.puts "			</TR><TR>" if ((i+1) % @modulo == 0)  & ((i+1) < @nbPDF)
    end
    insere_FinRefTableau if @nbPDF > 0  
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def insere_codeRelatif_ZIP

		insere_refTableauPourMultimedias if @nbZIP > 0
  	@nbZIP.times do |i|
  		z = "#{@iconePath}" + "#{@iconeName}/download.png"
    	@fich.puts "			<TD ALIGN=CENTER><A HREF='#{@listeDesZIP[i]}'><IMG SRC='#{z}' ALT='#{@listeDesZIP[i]} introuvable'><BR>#{@listeDesZIP[i]}</A></TD>"
    	@fich.puts "			</TR><TR>" if ((i+1) % @modulo == 0)  & ((i+1) < @nbZIP)
    end
    insere_FinRefTableau if @nbZIP > 0  
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
  def dirCourantCorrespondant
    # Recherche du nom du répertoire en cours (upDir)
    repEnCours = "#{@pathDir}".split('/')["#{@pathDir}".split('/').length - 1]
    if repEnCours == nil
      repEnCours = Pathname.new(Dir.pwd).basename.to_s
    end
    return repEnCours
  end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
end 

