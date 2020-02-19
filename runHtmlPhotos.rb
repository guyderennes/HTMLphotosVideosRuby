#!/usr/bin/ruby

##!/usr/bin/ruby -wU

# CONTIENT LE PROGRAMME PRINCIPAL DE GÉNÉRATION DE FIFIERS html POUR VISUALISER MES PHOTOS ET VIDÉOS
# Guy Béchet gabechet@gmail.com : 30/10/2013


# Mes autres fichiers
require_relative 'String.rb'
require_relative 'Calibrage.rb'
require_relative 'Index.rb'
require_relative 'IndexN.rb'
require_relative 'RecupList.rb'
require_relative 'Reglages.rb'

# Pour l'utilisation d'une classe ruby
require 'pathname'

# Pour la génération des vignettes
RMAGICK_BYPASS_VERSION_TEST = true
#require 'rmagick' # Car prend trop de place mémoire
#include Magick
require 'mini_magick'
include MiniMagick

# Pour éventuellement effacer les répertoires .VIGNETTES et .CALIBRAGE
require 'fileutils'

# oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
@delCalibrage = Reglages::DELETE_CALIBRAGE
@delVignettes = Reglages::DELETE_VIGNETTES
@webIcones = Reglages::ICONES_SUR_LE_WEB
@iconeNameLocal = Reglages::ICONE_NAME_LOCAL
# oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
def grosMenage()
	# Effacement des index.html
	Dir.glob('**/*').grep(/html$/).each { |index_html|
		File.delete("#{index_html}")
	}
	
	# Effacement des .indexN.html
	Dir.glob('**/.*').grep(/html$/).each { |index_html|
		File.delete("#{index_html}")
	}

	if @delCalibrage
		Dir.glob('**/.CALIBRAGE').each { |repCal|
			FileUtils.rm_r "#{repCal}"
		}
	end

	if @delVignettes
		Dir.glob('**/.VIGNETTES').each { |repVignettes|
			FileUtils.rm_r "#{repVignettes}"
	}
	end
end
# oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
def accueil()
	puts " "
	Dir.glob('**/Video*').each { |repertoireAvecNomInterdit|
		if File.exist?("#{repertoireAvecNomInterdit}" + "/")
			puts "Cet utilitaire ne fonctionne pas avec ce nom de répertoire : " + "#{repertoireAvecNomInterdit}"
			puts "Donnez un autre nom."
			exit()
		end
	}
	if not Reglages::URL_DISK_DEPART.empty? and not Reglages::URL_AUTRE_DISK.empty?
		puts "Dans Reglages.rb il est interdit d'avoir en même temps URL_DISK_DEPART et URL_AUTRE_DISK"
		exit()
	end
	puts "Visualise photos (jpg, png, gif, webp), audios, vidéos, pdf et zip dans un navigateur web à partir de : " + Pathname.new(Dir.pwd).basename.to_s
	puts ""
	puts "Les répertoires .VIGNETTES et .CALIBRAGE sont d'abord éventuellemnt effacés selon la configuration inscrite dans Reglages.rb, soit :"
	puts "		DELETE_CALIBRAGE = " + @delCalibrage.to_s
	puts "		DELETE_VIGNETTES = " + @delVignettes.to_s
	puts "		REP_AVANT_IMAGES = " + Reglages::REP_AVANT_IMAGES.to_s
	puts ""

	if not @delCalibrage
		puts "ATTENTION avec DELETE_CALIBRAGE == false, l'ordre d'affichage des photos pourra être perturbé pour les flèches !!!"
		puts ""
	end
		
	if not File.exist?("./" + @iconeNameLocal + "/Suite.png")
		puts "Le répertoire " + @iconeNameLocal + "/ n'exite pas ici dans " + Pathname.new(Dir.pwd).basename.to_s
		puts "Les icônes seront donc référencés par rapport au serveur ORANGE." # car https://serveurOrange/ICONES/ 
		puts ""
		puts "Si upload envisagé vers serveur ORANGE, alors il faut d'abord évoquer" 
		puts "le script AdaptePourServeurOrange à chaque niveau de la hierrarchie,"
		puts "puis uploader via FTP avec filezilla."
		puts "Dans ce cas le site sera : http://guyvac.pagesperso-orange.fr/" + Pathname.new(Dir.pwd).basename.to_s + "/"
		puts ""
		puts "LECTURE POSSIBLE LOCALEMENT DANS TOUS LES CAS"
		puts ""
		puts "Voulez-vous continuer ? O"
		if gets.chomp != 'O'
			puts "Vous avez arrêté."
			exit()
		else
			puts "Patience, ce peut être long, s'il y a beaucoup de photos ..."
			grosMenage()
			(Dir.pwd + "/").genereHTML(@webIcones)
		end
	else
		puts "Les icônes seront référencés en local."   # car ../../.Icones/
		puts "Lectures des photos possible UNIQUEMENT en local."  # car ../../.Icones/
		puts "Donc inutile de lancer le script AdaptePourServeurOrange."
		puts ""
		puts "Voulez-vous continuer ? O"
		if gets.chomp != 'O'
			puts "Vous avez arrêté."
			exit()
		else
			puts "Patience, ce peut être long, s'il y a beaucoup de photos ..."
			grosMenage()
			(Dir.pwd + "/").genereHTML("")
		end
	end
	
end
	
# oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
# ooo PROGRAMME PRINCIPAL DE GÉNÉRATION DE FIFIERS html POUR VISUALISER MES PHOTOS ET VIDÉOS oooo
# oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo

accueil()
