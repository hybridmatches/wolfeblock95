#!/bin/sh -e
site=../site
content=content
headerA=../../inc/header-top.htm
headerB=../../inc/header-bottom.htm
sitenav=../../inc/nav.htm
meta=meta.htm
contentFile=content.htm
foottop=../../inc/footer-top.htm
foot=../../inc/footer.htm
footbot=../../inc/footer-bottom.htm
bottom=../../inc/html-bottom.htm
tally=0

rm -rf $site
mkdir -p $site

# List the index
setupindex() {
	echo "<h1>INDEX PAGE</h1>" > ../permanav/index/content.htm;
	for f in *; do #PREBERE MAPO PHOTOGRAPHY
		echo "<h2>${f}</h2><ul>" >> ../permanav/index/content.htm;
		cd $f;
		for f in *; do #ZDAJ PREBERE PODMAPO PHOTOGRAPHY
			echo "<li><a href='${site}/${f}.html'>{${f}}</a></li>" >> ../../permanav/index/content.htm; ##IN GENERIRA LINK PODMAPE
		done
		cd ..
		echo "</ul>" >> ../permanav/index/content.htm;
	done
	echo "Setup index -- DONE"
}

setupgungalarc() {
	for f in *; do
		categoryname=$f;
		mkdir -p ../permanav/index_${categoryname}
		echo "<ul>" > ../permanav/index_${categoryname}/content.htm
		cd $f;
		for f in *; do #ZDAJ GREV PODMAPO PHOTOGRAPHY
			echo "<li><a href='${site}/${f}.html'>{${f}}</a></li>" >> ../../permanav/index_${categoryname}/content.htm; ##IN GENERIRA LINK PODMAPE
		done
		cd ..
		echo "</ul>" >> ../permanav/index_${categoryname}/content.htm;
	echo "setup gungalarc -- DONE"
	done
}

sitenav() {
	echo "<nav class='sitenav'>" > ../inc/nav.htm;
	echo "<a href='home.html'>HOME</a>" >> ../inc/nav.htm;
	for f in *; do
		if [ $f != 'index' ]; then
			echo "<a href='index_${f}.html'>${f}</a>" >>../inc/nav.htm;
		fi
	done
	echo "<a href='index.html'>INDEX</a>" >> ../inc/nav.htm;
	echo "<a href='about.html'>ABOUT</a>" >> ../inc/nav.htm;
	echo "</nav>" >> ../inc/nav.htm;
	echo "nav"
}


footy() {
	datum=$(date +%d-%m-%Y);
	letina=$(date +%Y);
	
	#echo "<footer><a>Ganga 95© ${letina} </a> <a>Gangad: ${datum}</a></footer></main>" >../inc/footer.htm;

	echo "<span><a href="about.html">Piarhija</a> &copy; ${letina} <a><small> Last change: ${datum} </small></a></span>"  >../inc/footer.htm;

	

}

# Setup topics
cd $content
footy;
sitenav;
setupindex;
setupgungalarc;

for f in *; do
	cd $f;
	for f in *; do
		cd $f;
		markup=''
		topPart=$(cat ../$headerA $meta ../$headerB);
		nav=$(cat ../$sitenav);
		contentText=$(cat $contentFile);
		footer=$(cat ../$foottop ../$foot ../$footbot);
		closefile=$(cat ../$bottom);
		mainContent="<main>${contentText}</main>";
		sideBar="<aside>${markup}</aside>";
		echo ${topPart}${nav}"${mainContent}"${sideBar}${footer}${closefile} > ../../../$site/${f}.html
		cd ..
		tally=$((tally+1))
	done
	cd ..
done
cd ..
cd permanav
for f in *; do
	cd $f;
	markup=''
	topPart=$(cat $headerA $meta $headerB);
	nav=$(cat $sitenav);
	contentText=$(cat $contentFile);
	footer=$(cat $foottop $foot $footbot);
	closefile=$(cat $bottom);
	mainContent="<main>${contentText}</main>";
	sideBar="<aside>${markup}</aside>";
	echo ${topPart}${nav}"${mainContent}"${sideBar}${footer}${closefile} > ../../$site/${f}.html
	cd ..
done
echo "${tally} topics built"



