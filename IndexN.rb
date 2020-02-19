#!/usr/bin/ruby -wU

class IndexN

# Cette classe sert à fabriquer tous les fichiers .indexn.html référençant les audios ou vidéos
# invocation : generateurIndexN = IndexN.new("./", "../")
# Le 1er paramètre est l'endroit d'où est lancé le programme et le second le chemin relatif du répertoire des Icônes
# Guy Béchet gabechet@gmail.com : 28/10/2013
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def initialize(pathDir, iconePath, iconeName)
  @repDuHaut = pathDir.split('/')[0]
  
  # J'ai pathDir du style : Vacances2014/   Vacances2014/camping/   Vacances2014/camping/mer/
  # Pour avoir @pathDir avec des chemins du style ./   ./camping/   ./camping/mer/
  # J'utilise la méthode slice(start, length) : "abcdefghijklm".slice(5,3) => "fgh"
  @pathDir = "." + pathDir.slice(pathDir.split('/')[0].length, pathDir.length)
  @iconePath = iconePath
	@infos = RecupList.new(@pathDir)
	@multimediasDansCeDir = @infos.listeAudioVideo	
	@nbMultimedias = @infos.nbAudioVideo
	@iconeName = iconeName
end
# pathDir est par exemple un/deux/trois/ qui va servir à s'occuper des ./un/deux/trois/.index03.html
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
def genere_code
	@nbMultimedias.times do |i|
  	type = @infos.typeAudio_ou_Video(@pathDir + @multimediasDansCeDir[i])
  	#puts "Fabrication de " + @pathDir + ".index" + i.to_s + ".html" + " qui référencie " + @multimediasDansCeDir[i] + " de type " + type

		fich = File.new(@pathDir + ".index" + i.to_s + ".html", "a+")
		fich.puts "<!DOCTYPE HTML>"
		fich.puts "<HTML lang='fr'>"
		fich.puts "	<HEAD>"
		fich.puts "		<meta charset='utf-8' />"
		fich.puts "		<TITLE>#{@multimediasDansCeDir[i]}</TITLE>"
		fich.puts "		<link rel='stylesheet' type='text/css' HREF='#{@iconePath}#{@iconeName}/style.css'>"
		fich.puts "	</HEAD>"

		fich.puts "	<BODY>"
		fich.puts "		<H2>#{@multimediasDansCeDir[i]}</H2>"
		fich.puts "		<A HREF='index.html'>Vignettes pr&eacute;c&eacute;dentes</A>"

		fich.puts "		<#{type} controls autoplay>" 
 		fich.puts "   		<source src='#{@multimediasDansCeDir[i]}'/>"
#		fich.puts "   		<source src='#{@multimediasDansCeDir[i]}' type='#{type}/#{"#{@multimediasDansCeDir[i]}".split('.')[1]}' />"  #Pour ajouter par exemple : type='video/webm'
		fich.puts "		</#{type}>"

		fich.puts "	</BODY>"
		fich.puts "</HTML>"
		fich.close
	end
end
# eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
end
