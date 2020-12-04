prodFolder="../publishedsite"
#copy website to the other folder
cp -Tr ./website $prodFolder

#add all changes in git
cd $prodFolder
git add **

#commit
git commit -m "Updated site on $(date +%m-%d-%y)"

#push changes
git push origin main