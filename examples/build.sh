#!/bin/sh

lambda2ymap() {
	echo "Building ${2}..."
	xsltproc ../lambda2ymap.xsl "$1" > "$2"
}

lambda2ymap gladiator/gladiator.xml gladiator/stream/gladiator.ymap
lambda2ymap fishermans_bay/Guarma_Fisherman_Bar.xml fishermans_bay/stream/guarma_fisherman_bar.ymap
lambda2ymap guarma_stilt_house/Guarma_Stilt_House_Complete.xml guarma_stilt_house/stream/guarma_stilt_house.ymap
