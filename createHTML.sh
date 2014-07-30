function makeIntroPage  ( ){
	echo "Creating Intro Page"
	title="$1"
	coverimage=$2
	link=$3
	htmlout=$4
	zipireport=$5
	
	echo -e "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">
<html>
	<head>
	</head>
	<body>
		<!-- dummy intro page, since first page will not have any javascript/css features enabled unless specified in universe_wsgi.ini file, but subsequent pages will -->
		<br/>
		<br/>
		<center>
		<b><font size=\"15\"> iReport: ${title} </font></b><br/>
		<br/>
		<br/>
		<a href=\"$link\">  Click here to view report	</a> <br/><br/>
		<a href=\"$link\"> <img src="$coverimage" width=\"50%\" alt=\"loading image..\"/> </a><br/><br/>		
		<a href=\"$zipireport\">  Click here to download a copy of this iReport </a> <br/><br/>
		</center>
	</body>
</html>" > $htmlout

}


function makeTabContent ( ){
	tab=$1			#name of current tab
	itemslist=$2	#list of all items
	contentline="<br/>"
	imgcount=0
	#echo -e "\n Creating items. itemslist: $itemslist"
	
	for item in $itemslist
	do
		#echo -e "\n -> item : $item"
		item=${item/::/:emptycol:}
		declare -a myarr=(`echo $item |sed 's/:/ /g'`)
		#echo "break: ${myarr[3]}"
		if [ ${myarr[0]} == $tab ]
		then
			
			## add contents of text field to page####
			if [ ${myarr[1]} == "text" ]
			then
				text=${myarr[2]}
				## allow some html formatting tags
				text=${text//==lt==strong==gt==/<strong>}  # search for strong tags
				text=${text//==lt====slash==strong==gt==/<\/strong>}  # search for strong tags
				text=${text//==lt==em==gt==/<em>}  # search for strong tags
				text=${text//==lt====slash==em==gt==/<\/em>}  # search for strong tags
				
				text=${text//==lt==b==gt==/<strong>}  # search for strong tags
				text=${text//==lt====slash==b==gt==/<\/strong>}  # search for strong tags
				text=${text//==lt==i==gt==/<em>}  # search for strong tags
				text=${text//==lt====slash==i==gt==/<\/em>}  # search for strong tags
				
				text=${text//==lt==br==gt==/<br\/>}  # search for strong tags
				text=${text//==lt====br==slash==gt==/<br\/>}  # search for strong tags
				text=${text//==lt==h1==gt==/<h1>}  # search for h1-h6 tags
				text=${text//==lt==h2==gt==/<h2>}  # search for h1-h6 tags
				text=${text//==lt==h3==gt==/<h3>}  # search for h1-h6 tags
				text=${text//==lt==h4==gt==/<h4>}  # search for h1-h6 tags
				text=${text//==lt==h5==gt==/<h5>}  # search for h1-h6 tags
				text=${text//==lt==h6==gt==/<h6>}  # search for h1-h6 tags
				text=${text//==lt====slash==h1==gt==/<\/h1>}  # search for h1-h6 closing tags
				text=${text//==lt====slash==h2==gt==/<\/h2>}  # search for h1-h6 closing tags
				text=${text//==lt====slash==h3==gt==/<\/h3>}  # search for h1-h6 closing tags
				text=${text//==lt====slash==h4==gt==/<\/h4>}  # search for h1-h6 closing tags
				text=${text//==lt====slash==h5==gt==/<\/h5>}  # search for h1-h6 closing tags
				text=${text//==lt====slaxh==h6==gt==/<\/h6>}  # search for h1-h6 closing tags
				
				## display everything else verbatim
				text=${text//==space==/ }
				text=${text//==colon==/:}
				text=${text//==comma==/,}
				text=${text//==slash==/\/}
				text=${text//==lt==/&lt;}
				text=${text//==gt==/&gt;}
				text=${text//==apos==/&apos;}
				text=${text//==quote==/&quot;}
				text=${text//&&/&amp;}
				text=${text//\\n/<br/>}
				text=${text//\\t/&emsp;}
				text=${text//\&r\&n/<br/>}
				text=${text//\&r/<br/>}
				text=${text//\&n/<br/>}
				text=${text//\&c/:}
				contentline="${contentline}${text}"
			fi
			
			## add contents of a text file to page
			if [ ${myarr[1]} == "textfile" ]
			then
				tfile=${myarr[2]}
				fname=`basename ${tfile}`
				fname=${fname%.*}
				fname="${fname}.txt"
				cp ${tfile} "${galaxypath}/${fname}"
				
				#estimate height for iframe based on number oflines in the file
				numlines=`wc -l ${tfile} | cut -d" " -f1`
				minheight=$[$numlines*17]
				
				contentline="${contentline}<iframe class=\"invisibleframe\" src=\"${fname}\" width=\"100%\" height=\"$minheight\"> </iframe>"
			fi
			
			## add image file to page
			if [ ${myarr[1]} == "image" ]
			then
				imgcount=$[$imgcount+1]
				#restore file suffix for html
				ftype=`file ${myarr[2]}`
				zoomlevel=${myarr[4]}
				zoomenable=${myarr[5]}
				align=${myarr[6]}
				#####echo "zoomenable:${zoomenable}, align:${align}"
				if [[ $ftype == *JPEG* ]]
				then
					suffix=".jpg"
				fi
				if [[ $ftype == *SVG* ]]
				then
					suffix=".svg"
				fi
				if [[ $ftype == *PNG* ]]
				then
					suffix=".png"
				fi
				
				image=`basename ${myarr[2]}`
				image=${image%.dat}
				image="${image}${suffix}"
				cp ${myarr[2]} ${galaxypath}/${image}
				
				if [[ ${align} == "none" ]]
				then
					alignstring=""
					alignstring2=""
				else 
					alignstring="<div float=\"${align}\">"
					alignstring2="</div>"
					
					alignstring="align=\"${align}\""
					alignstring2=""
				fi
				
				
				if [[ ${zoomlevel} -eq 0 ]]
				then
					widthstring=""
				else
					widthstring="width=\"${zoomlevel}\""
				fi
				
				if [[ ${zoomlevel} -eq 0 || ${zoomenable} == "N" ]]
				then
					contentline="${contentline}<span id=\"img${imgcount}\"> <img src=\"${image}\" ${alignstring} ${widthstring} alt=\"loading image..\"/></span>"
				else				
					contentline="${contentline}<span class=\"zoomme\" id=\"img${imgcount}\"> <img src=\"${image}\" ${alignstring} ${widthstring} alt=\"loading image..\"/></span>"
				fi
				
			fi
			if [ ${myarr[1]} == "table" ]
			then
				maxlines=50000
				tsvfile_orig=${myarr[2]}
				tsvfile="tablehead.tsv"
				fname=`basename ${tsvfile_orig}`
				fname=${fname%.*}
				fancy=${myarr[4]}
				makelinks=${myarr[5]}
				#echo "\nmakelinks: $makelinks fancy: $fancy <br>"
				
				#TODO client side database for large files. For now only display first section of file and add download link
				numlines=`wc -l ${tsvfile_orig} |cut -d" " -f1`
								
				head -${maxlines} ${tsvfile_orig} > tsvtmpfile
				
				#remove any empty or header lines (lines starting with #, unless vcf file, then keep #CHROM line)
				awk 'BEGIN{
					FS="\t"
					OFS="\t"
				}{
					if((index($0,"#")==1 && index($0,"#CHROM")!=1) || $0==""){ 
						headerlines++
					}
					else print $0
						
				}END{}' tsvtmpfile > ${tsvfile}
				
				if [[ $makelinks == "Y" ]]
				then
					col=${myarr[6]}
					prefix=${myarr[7]}
					suffix=${myarr[8]}					
					suffix=${suffix/emptycol/}
					suffix=${suffix/==quote==/&}
					prefix=${prefix/emptycol/}
					prefix=${prefix/==quote==/&}
					prefix=${prefix/==colon==/:}
					#echo "prefix: $prefix"
					
					#edit the table to include links
					awk 'BEGIN{
						FS="\t"
						OFS="\t"
						url="'"$prefix"'"
						url2="'"$suffix"'"
						prefix="<a href=\42"
						suffix="\42>"
						col="'"$col"'"
						end="</a>"
					}{
						if(FNR==1)
							print $0
						else{
							$col=prefix""url""$col""url2""suffix""$col""end
							print $0
						}
					}END{}' ${tsvfile} > ${tsvfile}2
					#echo "converted file: "
					#cat ${tsvfile}2
				else
					cp ${tsvfile} ${tsvfile}2
				fi
				
				if [ $fancy == "Y" ]
				then
					perl ${repositorypath}/tsv2html.pl < ${tsvfile}2 > ${galaxypath}/htmltable_${fname}.html
					#contentline="${contentline}\n<div class=\"resizable\" id=\"iframe${iframecount}\"><iframe src=\"htmltable_${fname}.html\" style=\"max-width: 100%;vertical-align: top;\" onload=\"resizeIframe(this)\"></iframe></div>"
					#contentline="${contentline}\n<iframe class=\"resizable\" id=\"iframe${iframecount}\" src=\"htmltable_${fname}.html\" style=\"max-width: 100%;vertical-align: top;\" onload=\"resizeIframe(this)\"></iframe>"
					contentline="${contentline}\n<iframe class=\"invisibleframe fancyiframe\" src=\"htmltable_${fname}.html\" width=\"100%\" style=\"min-height: 300px; overflow-y: hidden; overflow-x: scroll\" ></iframe>"
					
					iframecount=$[$iframecount+1]
				else
					perl ${repositorypath}/tsv2html_simple.pl < ${tsvfile}2 > ${galaxypath}/htmltable_${fname}.html
					#contentline="${contentline}\n<iframe class=\"invisibleframe\" id=\"iframe${iframecount}\" style=\"max-width: 100%; vertical-align: top;\" src=\"htmltable_${fname}.html\" onload=\"resizeIframe(this)\"></iframe>"
					contentline="${contentline}\n<iframe class=\"unfancyiframe invisibleframe\" src=\"htmltable_${fname}.html\" scrolling=\"no\" style=\"max-width: 100%; vertical-align: top;\" onload=\"resizeIframe(this)\"></iframe>"
					iframecount=$[$iframecount+1]
				fi
				
				if [[ $numlines -gt ${maxlines} ]]
				then
					tablename=`basename ${tsvfile_orig}`
					cp ${tsvfile_orig} ${galaxypath}/$tablename
					contentline="${contentline}<br/>\nLarge tables will be supported soon. The first ${maxlines} lines are shown here, and you can download the full file <a href=\"${tablename}\">here</a>."					
				fi
			fi
			
			if [[ ${myarr[1]} == "pdf" ]]
			then
				pdffile=${myarr[2]}
				fname=`basename ${pdffile}`
				fname=${fname%.dat}
				pdfname="${fname}.pdf"
				cp ${pdffile} "${galaxypath}/${pdfname}"
				
				width=1000
				height=800
				#contentline="${contentline}<object data=\"${fname}\" type=\"application/pdf\" width=\"1000\" height=\"1000\"><p>It appears you have no PDF plugin for your browser. No biggie... you can <a href=\"${fname}\">click here to	download the PDF file.</a></p></object>"
				echo -e "<html><body><object data=\"${pdfname}\" type=\"application/pdf\" width=\"$width\"  height=\"$height\"><embed src=\"${pdfname}\" type=\"application/pdf\" /><p>It appears you have no PDF plugin for your browser. No biggie... you can <a href=\"${pdfname}\">click here to	download the PDF file.</a></p></object></body></html>" > "${galaxypath}/${fname}.html"
				width=$[$width+10]
				height=$[$height+10]
				contentline="${contentline}<iframe src=\"${fname}.html\" width=\"${width}\"  height=\"${height}\"></iframe>\n"
				
			fi
			## link to a location on the web, open in new window
			if [ ${myarr[1]} == "weblink" ]
			then
				url=${myarr[2]}
				linktext=${myarr[4]}				
				url=${url/==colon==/:}
				url=${url/==quote==/&}
				
				contentline="${contentline}<a href=\"${url}\" target=\"_blank\">${linktext}</a>"
			fi
			
			## link to a file in the history
			if [ ${myarr[1]} == "link" ]
			then
				linkfile=${myarr[2]}
				apiid=${myarr[4]}
				isireport=${myarr[5]}
				linkfilename=`basename ${linkfile}`
				linktext=${myarr[6]}
				
				
				#check for some basic filetypes
				ftype=`file $linkfile`
				if [[ $ftype == *HTML* ]]
				then
					linkfilename=${linkfilename%.dat}
					linkfilename=${linkfilename}.html
				fi
				if [[ $ftype == *PNG* ]]
				then
					linkfilename=${linkfilename%.dat}
					linkfilename=${linkfilename}.png
				fi
				if [[ $ftype == *SVG* ]]
				then
					linkfilename=${linkfilename%.dat}
					linkfilename=${linkfilename}.svg
				fi
				if [[ $ftype == *JPEG* ]]
				then
					linkfilename=${linkfilename%.dat}
					linkfilename=${linkfilename}.jpg
				fi
				
				
				if [[ ${isireport} == "Y" ]]
				then					
					linkfilename="/datasets/${apiid}/display/"
				else
					cp ${linkfile} "${galaxypath}/${linkfilename}"
				fi
			
				contentline="${contentline}<a href=\"${linkfilename}\">${linktext}</a>"
			fi
			
			## link to files in an archive in the history item 
			if [[ ${myarr[1]} == "links" ]]
			then
				#echo "making links:"
				archive=${myarr[2]}
				fname=`basename ${archive}`
				fname=${fname%.dat}
				ftype=`file $archive`
				mkdir ${galaxypath}/archive_${fname}/
				
				#echo "archive type: `file $archive`"
				# decompress archive
				if [[ $ftype == *Zip* ]]
				then
					#echo "detected zip file"
					cp $archive ${galaxypath}/archive_${fname}/${fname}.zip
					wd=`pwd`
					cd ${galaxypath}/archive_${fname}/
					unzip -q ${fname}.zip
					rm ${fname}.zip
					cd $wd
				fi
				if [[ $ftype == *tar* ]]
				then
					cp $archive ${galaxypath}/archive_${fname}/${fname}.tar
					wd=`pwd`
					cd ${galaxypath}/archive_${fname}/
					tar xf ${fname}.tar
					rm ${fname}.tar
					cd $wd
				fi
				if [[ $ftype == *gzip* ]]
				then
					cp $archive ${galaxypath}/archive_${fname}/${fname}.gz
					gunzip ${galaxypath}/archive_${fname}/${fname}.gz
					#ls ${galaxypath}/archive_${fname}/
					
					# check for tar.gz
					ftype=`file ${galaxypath}/archive_${fname}/${fname}`
					if [[ $ftype == *tar* ]]
					then
						# turns out it was tar.gz
						rm -Rf ${galaxypath}/archive_${fname}/*
						ls ${galaxypath}/archive_${fname}/
						cp $archive ${galaxypath}/archive_${fname}/${fname}.tar.gz
						
						wd=`pwd`
						cd ${galaxypath}/archive_${fname}/
						tar xzf ${fname}.tar.gz 
						cd $wd
					fi
					wait
					rm -f ${galaxypath}/archive_${fname}/*.tar
					rm -f ${galaxypath}/archive_${fname}/*.tar.gz
				fi
				if [[ $ftype == *bzip2* ]]
				then
					cp $archive ${galaxypath}/archive_${fname}/${fname}.gz
					gunzip2 ${galaxypath}/archive_${fname}/${fname}.gz
				fi
				
				
				
				# add links to webpage
				# separate line for each folder, files within folder on same line
				for linkfile in `ls ${galaxypath}/archive_${fname}/ |sort -V`
				do
					#echo  "<br/> ->making link to file: $linkfile "
					if [ -d ${galaxypath}/archive_${fname}/$linkfile ]  # if directory, add break, and list all contained files, max level 1 deep
					then
						#echo  "<br/> ->is directory, entering: $linkfile "
						#ls ${galaxypath}/archive_${fname}/$linkfile
						contentline="${contentline}"
						for linkfile2 in `ls ${galaxypath}/archive_${fname}/$linkfile | sort -V`
						do
							#echo  "<br/> ->making link to file: ${galaxypath}/archive_${fname}/$linkfile2"
							if [ -f ${galaxypath}/archive_${fname}/$linkfile/$linkfile2 ]  # if directory, add break, and list all contained files, max level 1 deep
							then
								#echo  "<br/> ->is file, making link: $linkfile "
								label=`basename $linkfile2`
								label=${label%.*}
								contentline="${contentline}<a class=\"mylinks\" href=\"archive_${fname}/${linkfile}/${linkfile2}\">${label}</a>&nbsp;\n "
							fi
						done
					elif [ -f ${galaxypath}/archive_${fname}/$linkfile ]
					then
						label=`basename ${galaxypath}/archive_${fname}/$linkfile`
						label=${label%.*}
						contentline="${contentline}<a class=\"mylinks\" href=\"archive_${fname}/${linkfile}\">$label</a>&nbsp;\n"
					fi
				done
				
				
			fi
			
			if [[ ${myarr[3]} == "Y" ]]
			then
				contentline="${contentline}<br/>"
			fi		
		fi
	done
	
	echo "${contentline}"
}


createMainPage (){
	page=$1
	tabtitles=$2  #comma-separated list of tab titles
	tabitems=$3
	iframecount=1
	minwidth=$4
	
	echo "createMainPage: tabitems: $tabitems. tabtitles: $tabtitles"
	# create correct number of tabs
	count=0
	
	tabtitles=${tabtitles//,/ }
	tabtitles=${tabtitles//==colon==/:}
	tabslist="<ul>\n"
	mytabs=""
	for title in $tabtitles
	do
		#create list of tabs
		
		count=$[count+1]
		title2=${title//_s_/ }
		tabslist="${tabslist} <li><a href=\"#tabs-${count}\">${title2}</a></li>\n"
		
		#create tabs with content
		tabcontent=$(makeTabContent $title "$tabitems")
		mytabs="${mytabs}\n<div id=\"tabs-${count}\">\n"
		mytabs="${mytabs}${tabcontent}"
		mytabs="${mytabs}\n</div>\n"
	done
	tabslist="${tabslist}</ul>"
	
	#output the webpage
	echo -e "<!doctype html>
<head>
  <meta charset=\"utf-8\">
  <title>jQuery UI Tabs - Default functionality</title>
  
  
  <link rel=\"stylesheet\" href=\"jquery-ui.css\">  
  <script src=\"jquery-1.10.2.js\"></script>
  <script src=\"jquery-ui.js\"></script>
  <script type=\"text/javascript\" src=\"iframe-resizer/src/iframeResizer.js\"></script> 
  <script type=\"text/javascript\" src=\"jquery.zoom.js\"></script>
  
  <script>
  \$(function() {
    \$( \"#tabs\" ).tabs();
  });

  \$(function() {
    \$( \".resizable\" ).resizable();
  });

  \$(document).ready(function(){
       \$('.zoomme').zoom();
       \$('#ex2').zoom({ on:'grab' });
       \$('#ex3').zoom({ on:'click' });
       \$('#ex4').zoom({ on:'toggle' });
       \$('.fancyiframe').iFrameResize({
							heightCalculationMethod: 'max',
							minHeight: 250,
							scrolling: true,
							checkOrigin: false,
							bodyMargin: 15
		});
		\$('.unfancyiframe').iFrameResize({
							heightCalculationMethod: 'max',
							scrolling: false,
							checkOrigin: false
		});
  });
 
  </script>


  <script language=\"javascript\" type=\"text/javascript\">
    function resizeIframe(obj) {
	  oldheight=obj.style.height
	  oldwidth=obj.style.width
      obj.style.height = obj.contentWindow.document.body.scrollHeight + 4 + 'px';
      obj.style.width = obj.contentWindow.document.body.scrollWidth + 4 + 'px';
      
      if(obj.style.height < 50){
       obj.style.height=oldheight
      }
    }
  </script>
<style type=\"text/css\">
	body { 
		min-width: ${minwidth}px; 
		width: ${minwidth}px; 
		min-height: 100%;
	}
	.invisibleframe{
		border: 0px;
		overflow: hidden
	}
	.mylinks{
		color: blue !important;
	}
	.mylinks:visited {	
		color: #551A8B !important;
	}
</style>
 <style >
  .zoomme {
    display: inline-block;
  }
</style>


</head>
<body>
 
<div id=\"tabs\" style=\"display:inline-block; min-height:100%; min-width:${minwidth}px\">
$tabslist

$mytabs
</div>
 
 
</body>
</html>" > $page



}