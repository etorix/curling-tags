# curling-tags
Finding some tags

Script will take every tag available under $repo and check if manifests are available -- no manifests available = imgs aren't pulled

Either save your own output or check /tmp/missing.txt for the output log

Example to find all missing manifests for ruby:

bash missman.sh ruby
