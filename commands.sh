#############################################################
# git
#############################################################
git checkout feat/KULADM-1198-migrate-from-create-react-app-to-vite
git branch -u origin/develop feat/KULADM-1198-migrate-from-create-react-app-to-vite
git add . -v
git commit -m "message"
git pull
git commit -m "merge"
git push -u origin feat/KULADM-1198-migrate-from-create-react-app-to-vite

#############################################################
# Musescore / pdfunite
#############################################################
brew install poppler
brew install ruby
gem install pdfunite

cd ~/Documents/Music

# generate titles from filenames (remove composer)
ls ~/Documents/MuseScore4/Scores/ | awk -F ' - '  '{print $1}' | grep -v _Cover > titles.txt

# generate recipe from titles
true > recipe.toml && for i in (cat titles.txt); pdfxmeta -a 1 in.pdf "$i" >> recipe.toml; end

# generate TOC
pdftocgen in.pdf < recipe.toml > toc

# add TOC to PDF
pdftocio -o out.pdf in.pdf < toc

#############################################################
# Fixes / troubleshooting
# macOS says App is damaged and can't be opened
#############################################################
xattr -d com.apple.quarantine path-to-app
sudo xattr -cr com.apple.quarantine ~/Downloads/Whisky.app
sudo spctl --master-enable
sudo spctl --master-disable


#############################################################
# Bootable OSX installer
#############################################################
sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume


#############################################################
# Brew
#############################################################
Get Xcode command line tools from https://developer.apple.com/downloads/index.action?=command%20line%20tools#
bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install fish httpie node yarn wget watch htop bat rename aria2 fswatch b2-tools
brew install jpeg libpng libxtiff libyaml openssl  webp brew
# bun
brew tap oven-sh/bun && brew install bun
# image compression utils
brew install pngquant oxipng
# mkcert (nss needed for certificates to work in Firefox)
brew install mkcert nss
# cmake is needed for yarn when binaries for current architecture needs to be compiled
brew install cmake
# innoextract for extract GOG games offline installers (https://constexpr.org/innoextract/)
brew install innoextract
# buf (required for protobuf linting in VSCode)
# https://marketplace.visualstudio.com/items?itemName=bufbuild.vscode-buf
brew install bufbuild/buf/buf


#############################################################
# grpcurl
#############################################################
brew install grpcurl
grpcurl -plaintext -import-path ./proto -proto ./proto/flow.proto list
grpcurl -plaintext -import-path ./proto -proto ./proto/flow.proto describe flow
grpcurl -plaintext -import-path ./proto -proto ./proto/flow.proto describe flow.FlowService
grpcurl -plaintext -import-path ./proto -proto ./proto/flow.proto describe flow.FlowService.GetById
grpcurl -plaintext -import-path ./proto -proto ./proto/user.proto -d '{"user_id": "GX6o50DN9KexiG6b9UZsn5s1gzs1", "id_token": "xxxxx"}' localhost:9090 user.UserService.SignIn
grpcurl -plaintext -import-path ./proto -proto ./proto/endpoint.proto -H "jwt-sub: GX6o50DN9KexiG6b9UZsn5s1gzs1" -d '{"owner_id": "GX6o50DN9KexiG6b9UZsn5s1gzs1", "project_id": "1kpkmdvdrls"}' localhost:9090 endpoint.EndpointService.GetByProjectId
grpcurl -plaintext -import-path ./proto -proto ./proto/flow.proto -H "jwt-sub: GX6o50DN9KexiG6b9UZsn5s1gzs1" -d '{"owner_id": "GX6o50DN9KexiG6b9UZsn5s1gzs1", "project_id": "1kpkmdvdrls"}' localhost:9090 flow.FlowService.GetByProjectId


#############################################################
# 1Password CLI
#############################################################
brew install --cask 1password/tap/1password-cli
op signin


#############################################################
# yarn (global packages)
#############################################################
# ncu: node package version checker
# underscore-cli: json prettifier for CLI
yarn global add ncu underscore-cli


#############################################################
# fish shell
#############################################################
brew install fish
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish

#
# fisher (fish shell plugin manager)
# https://github.com/jorgebucaran/fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

# fish theme
fisher install dracula/fish


#############################################################
# nvm (install with fisher; see fish shell above)
#############################################################
# fish-nvm (node manager)
# https://github.com/jorgebucaran/fish-nvm
fisher install jorgebucaran/nvm.fish

# or this one (does not support .nvmrc)
# fisher install FabioAntunes/fish-nvm edc/bass

nvm ls
# Install the latest LTS (long-term support) Node release.
nvm install lts
# use latest node version
nvm use latest
# use latest LTS version
nvm use lts
# store current version
node -v > .nvmrc
nvm


#############################################################
# Backblaze B2
#############################################################
# install
brew install b2-tools
# auth <appKeyId> <appKey>
b2 authorize-account 00172e3cdc11ad30000000002 K001SjY8E7g4+p
# upload <bucket> <local path> <remote path>
b2 upload-file efossvold-movies ./S1Bonus_Cannibals_And_Crampons.mkv "Tribe/S1Bonus_Cannibals_And_Crampons.mkv"
# sync <local path> <b2 bucket path>
b2 sync . b2://efossvold-movies
b2 sync --excludeRegex \.DS_Store . b2://efossvold-movies/stuff


#############################################################
# pkgutil (Extract GoG games)
#############################################################
pkgutil --extract beneath_a_steel_sky_enUS_1_0_33348.pkg [path to extract]


#############################################################
# Tresorit sync
#############################################################
cat > ~/Library/LaunchAgents/com.sync.development.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.sync.development</string>
	<key>Program</key>
	<string>/Users/erikfossvold/Development/sync.sh</string>
	<key>RunAtLoad</key>
	<true/>
	<key>StartInterval</key>
	<integer>900</integer>
</dict>
</plist>
launchctl load ~/Library/LaunchAgents/com.sync.development.plist
launchctl start ~/Library/LaunchAgents/com.sync.development.plist


#############################################################
# Hostname
#############################################################
sudo scutil --set HostName MBP


#############################################################
# Run apps from CLI
#############################################################
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime


#############################################################
# git
#############################################################
# http://git-scm.com/book/en/Git-Branching-Basic-Branching-and-Merging
# https://www.w3docs.com/snippets/git/best-and-safe-way-to-merge-a-git-branch-into-master.html
git commit -m 'always commit before branching!'
# create a new branch
git checkout -b new-branch
# make some changes
git commit -m 'changes made'
# fetch changes on master
git fetch 
# incorporate the latest commits of master to your branch
git rebase origin/master
# switch to master
git checkout master
# merge branch into master
git merge new-branch-name
# delete branch
git branch -d new-branch

# new git tag
# REMEMBER: Update package.json with version first
git tag -a 1.0.0 -m "Support for dotenv-expand"
git push origin --tags

# git diff revisions
git diff --no-prefix master d218c9cc73baab3c03f8d2458cdf624d26b6064a > ../my.patch
cd newdir
patch -R -p0 < ../my.patch

git clone -b docker https://Pj1nBbR8n4gSfJJzPRr8Bcqm0vIVBPq7:git@bitbucket.org:fanbooster/fanbooster-mom.git fanbooster-mom/


#############################################################
# npm
#############################################################
npm publish

# patch
diff -u ./partials/account.html ../../Dropbox/Fennek/ifrapp20/partials/account.html > patch.account.html
cat patch.account.html
patch ./partials/account.html < patch.account.html


#############################################################
# Rename
#############################################################
# Add -n for dry run
rename 's/\.js/\.es6\.js/g' **/*.js


#############################################################
# aria2c Download Manager
#############################################################
aria2c -s10 -x 10 -k 1M https://az412801.vo.msecnd.net/vhd/VMBuild_20141027/Parallels/IE9/Mac/IE9.Win7.For.Mac.Parallels.zip
aria2c --enable-rpc --rpc-listen-all=true --rpc-allow-origin-all=true -s10 -x 10 -k 1M https://az412801.vo.msecnd.net/vhd/VMBuild_20141027/Parallels/IE9/Mac/IE9.Win7.For.Mac.Parallels.zip


#############################################################
# Grep
#############################################################
egrep -Hnr --exclude 'node_modules/*' 'redactor_custom' **/*.{sass,html}


#############################################################
# Screenshot
#############################################################
defaults write com.apple.screencapture location ~/Downloads/Screenshots && killall SystemUIServer


#############################################################
# gcloud
#############################################################
sudo apt-get install htop


#############################################################
# Python
#############################################################
brew install pyenv
pyenv install --list
pyenv install 3.11.8
# list installed versions
pyenv versions
# set global version
pyenv global 3.11.8

# add to config.fish
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
# status is-interactive; and source (pyenv init --path | psub)
pyenv init - | source
pyenv shell 3.11.8


#############################################################
# Kubernetes / gcloud / Docker
#############################################################
gcloud config set disable_prompts true
gcloud config set app/promote_by_default false
gcloud components install app-engine-python

gcloud compute zones list
gcloud config list

gcloud container clusters list
gcloud container clusters create strings-dev --machine-type g1-small --num-nodes 1
gcloud container clusters describe strings-dev

# Switch cluster (for kubectl command)
gcloud config set project fanbooster-mother-machine
gcloud config set container/cluster strings-dev
gcloud container clusters get-credentials strings-dev

gcloud config set project curious-graph
gcloud config set container/cluster frontend-prod-1
gcloud container clusters get-credentials frontend-prod-1


# Run a k8s container
k8s run example --image=nginx

# SSH into a k8s container
k8s exec -ti nginx-3449338310-ksv8y bash

# Get cluster info (IP of k8s UI +++)
kubectl cluster-info

# Get container log
k8s logs strings-dev-deploy-3503576652-m00xd strings-dev-initializer

# Autoscale
kubectl autoscale deployment strings-dev-deploy --cpu-percent=40 --min=1 --max=10


#############################################################
# Docker
#############################################################
docker build -t us.gcr.io/fanbooster-mother-machine/python:2.7.12-alpine -f Dockerfile .
docker rmi us.gcr.io/fanbooster-mother-machine/python:2.7.12-alpine


#############################################################
# Transform images
#############################################################
sips -Z 800 *.jpg


#############################################################
# Rsync
#############################################################
rsync -ahv Dropbox/ ~/Dropbox/


#############################################################
# gsutil
#############################################################
sudo pip install gsutil
sudo gsutil -m rsync -drp bin/ gs://efossvold/bin/


#############################################################
# Curl
#############################################################
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"signed_request": "5kpGfGubDqDbwxySUdgTrHxLOoFKyeqh0vdrOp30kEg.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImlzc3VlZF9hdCI6MTQzMDIxODU5NCwidXNlciI6eyJjb3VudHJ5Ijoibm8iLCJsb2NhbGUiOiJlbl9VUyJ9LCJ1c2VyX2lkIjoiNTg4MjUwNDc1In0"}' http://localhost:8080/api/deauthorize/
curl --data "signed_request=5kpGfGubDqDbwxySUdgTrHxLOoFKyeqh0vdrOp30kEg.eyJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImlzc3VlZF9hdCI6MTQzMDIxODU5NCwidXNlciI6eyJjb3VudHJ5Ijoibm8iLCJsb2NhbGUiOiJlbl9VUyJ9LCJ1c2VyX2lkIjoiNTg4MjUwNDc1In0" http://localhost:8080/api/deauthorize/
curl -v -H 'content-length: 0' -X POST http://dnb-pensjon.fennek.com/mm/make-test-data-async
curl -v -H "Accept: application/json" -H "Content-type: application/json" --cookie "user=588250475" \
  -X POST -d @create_user.json http://localhost:8080/api/create_braintree_client_token/
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"search": "1"}' http://localhost:8080/admin/search_users/


#############################################################
# MySQL
#############################################################
bash
bash <(curl -Ls http://git.io/eUx7rg)
mysql -h localhost -u root -p

mysqldump -u root -p --databases wp_lotusfroet > ~/Downloads/lotusfroet.sql
select * from mysql.general_log order by event_time desc limit 50;


#############################################################
# Password generation
#############################################################
openssl rand -base64 24
