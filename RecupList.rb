#!/usr/bin/ruby -wU

class RecupList

# Classe les éléments du répertoire donné en argument dans un tableau de cette façon : AudioVideo puis Photos puis Répertoires
# Cette classe fournit nbRep, nbPhotos, nbAudioVideo, listeRep, listeDesPhotos, listeAudioVideo, listeDesPDF, nbPDF en readers
# invocation : info = RecupList.new("/chemin/Rep1/")  ===> ATTENTION de bien mettre le dernier "/" !!!!!!!!!!

# Guy Béchet gabechet@gmail.com : 28/10/2013
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

attr_reader :nbRep, :nbPhotos, :nbAudioVideo, :listeRep, :listeDesPhotos, :listeAudioVideo, :listeDesPDF, :nbPDF, :listeDesZIP, :nbZIP		


	def initialize(repAvecChemin)
		
		d = Dir.open(repAvecChemin)

		# Évaluation de la liste des pdf : @listeDesPDF
		@listeDesPDF = (d.grep(/pdf$/i)).human_sort
		
		# Évaluation de la liste des zip : @listeDesZIP. Les autres formats de compression ne sont pas pris en compte
		@listeDesZIP = (d.grep(/zip$/i)).human_sort
		
		# Évaluation de la liste des photos : @listeDesPhotos
		liste_exclus = ["index.html"] + @listeDesPDF
		@listeDesPhotos = (d.grep(/jpg$/i) + d.grep(/jpeg$/i) + d.grep(/png$/i) + d.grep(/webp$/i) + d.grep(/gif$/i)).human_sort


		# Évaluation de la liste des répertoires : @listeRep
		avecChemins = Dir.glob(repAvecChemin + "*") # tableau avec chemin/fichier
		sansChemins = Array.new
		i = -1
		avecChemins.each { |fichierWithPath| sansChemins[i += 1] = File.basename(fichierWithPath) }
		@listeRep = (sansChemins - d.grep(/\..*/)).human_sort
		d.close

		# Évaluation de la liste des audio video : @listeAudioVideo
		liste_DeTout = sansChemins - liste_exclus
		@listeAudioVideo = (liste_DeTout - @listeRep - @listeDesPhotos - @listeDesPDF - @listeDesZIP).human_sort

		# Évaluation des longueurs
		@nbRep = @listeRep.length
		@nbPhotos = @listeDesPhotos.length
		@nbAudioVideo = @listeAudioVideo.length
		@nbPDF = @listeDesPDF.length
		@nbZIP = @listeDesZIP.length
	end

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	def typeAudio_ou_Video(media) # Retourne le type Audio ou Video du media donné avec son chemin
		`ffmpeg -i "#{media}" 2>&1 | grep Video`.empty? ? "Audio" : "Video"
	end
end # Fin de la classe RecupList
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class Array
# J'ai des photos avec des noms alphanumériques. L'ordre du classement n'est pas bon. D'où cette classe étendue
# J'ai trouvé cette solution ici : https://www.ruby-forum.com/topic/3940438
  def human_sort
    sort_by { |item| item.to_s.split(/(\d+)/).map { |e| [e.to_i, e] } }
  end
end
