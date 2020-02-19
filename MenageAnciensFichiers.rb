#!/usr/bin/ruby -wU

# Cet utilitaire efface les anciens répertoires VIGNETTES et CALIBRAGE ainsi que
# les fichiers ayant un suffixe html et css. Cela s'effectue dans toute la hiérarchie
# du répertoire à partir duquel ce programme est lancé. Donc ATTENTION !
# Guy Béchet 13 novembre 2013

require 'pathname'
require 'fileutils'

def grosMenage()
	# Effacement des index.html
	Dir.glob('**/*').grep(/html$/).each { |index_html|
		File.delete("#{index_html}")
	}

	# Effacement des répertoire CALIBRAGE
	Dir.glob('**/CALIBRAGE').each { |repCal|
		FileUtils.rm_r "#{repCal}"
	}

	# Effacement des répertoire VIGNETTES
	Dir.glob('**/VIGNETTES').each { |repVignettes|
		FileUtils.rm_r "#{repVignettes}"
	}
	
	# Effacement des fichiers style.css
	Dir.glob('**/*.css').each { |fichcss|
		FileUtils.rm_r "#{fichcss}"
	}

end
# +++++++++++++++
puts "Cet utilitaire efface les anciens répertoires VIGNETTES et CALIBRAGE ainsi que"
puts "les fichiers ayant un suffixe html et css. Cela s'effectue dans toute la hiérarchie"
puts "du répertoire " + Pathname.new(Dir.pwd).basename.to_s + " à partir duquel ce programme est lancé. Donc ATTENTION !"
puts " Voulez-vous continuer ? O"

if gets.chomp == 'O'
	grosMenage()
else
	puts "Vous avez arrêté."
end

