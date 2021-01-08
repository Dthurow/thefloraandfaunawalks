#!/bin/bash
OIFS="$IFS"
IFS=$'\n'
#pull in the templates for creating the individual posts and the home page
postTemplate=$(cat ./postFormat.html)
indexTemplate=$(cat ./indexFormat.html)
imageTemplate=$(cat ./imageFormat.html)
linkTemplate=$(cat ./indexLinkFormat.html)

#the folder name to publish the site to
websiteFolder="website"

index=$indexTemplate


#make folder structure again for website
if [ ! -d $websiteFolder ]; then
    mkdir $websiteFolder
    mkdir $websiteFolder/images
fi

#copy all css
for i in $(ls *.css)
do
    cp $i $websiteFolder
done

#copy all jpg images
for i in $(ls *.jpg)
do
    cp $i $websiteFolder
done


#loop through posts and create the individual pages
for i in $(ls -cd */)
do 
    if [ $i = "$websiteFolder/" ]; then
        continue
    fi

    description=$(cat $i/description.txt)
    
    images=""
    #loop through the images and add them into the post template
    for image in $(cd $i && ls *.jpg)
    do
        imagePiece=${imageTemplate//\{src\}/"images/$image"}
        images="$images $imagePiece"
        cp "$i/$image" "$websiteFolder/images"
    done

    #add the description
    post=${postTemplate//\{description\}/$description}
    #add the photos
    post=${post/\{images\}/$images}

    #print out the post into its own html file
    echo $post > "$websiteFolder/$(basename $i) post.html"

    #add a link to this page on the index page
    link=${linkTemplate//\{page\}/"$(basename $i) post.html"}
    link=${link//\{plant\}/"$(basename $i)"}
    index=${index//\{link\}/$link}
    
done

#get rid of the final trailing {link} and write it out to a file
index=${index//\{link\}/""}
echo $index > "$websiteFolder/index.html"

IFS="$OIFS"