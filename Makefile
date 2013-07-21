dir_name="accessway_ios"
app_name="AccessWay"
plist=${dir_name}/${app_name}/${app_name}-Info.plist

bump_build:
	cd $(dir_name); ./Jenkins/bump_build.sh

build:
	cd ${dir_name}; ./Jenkins/create_build.sh

dist: build
	cd ${dir_name}; ./Jenkins/distribute_build.sh