<?xml version="1.0"?>
<xsl:transform
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:math="http://exslt.org/math"
	xmlns:func="http://exslt.org/functions"
	extension-element-prefixes="exsl math func">
	<xsl:variable name="pi" select="3.1415926535898"/>
	<xsl:variable name="objects" select="document('objects.xml')"/>
	<xsl:output indent="yes"/>
	<xsl:template match="Map">
		<CMapData>
			<flags value="2"/>
			<contentFlags value="65"/>
			<streamingExtentsMin
				x="{math:min(//Object/@Position_x) - 400}"
				y="{math:min(//Object/@Position_y) - 400}"
				z="{math:min(//Object/@Position_z) - 400}"/>
			<streamingExtentsMax
				x="{math:max(//Object/@Position_x) + 400}"
				y="{math:max(//Object/@Position_y) + 400}"
				z="{math:max(//Object/@Position_z) + 400}"/>
			<entitiesExtentsMin
				x="{math:min(//Object/@Position_x)}"
				y="{math:min(//Object/@Position_y)}"
				z="{math:min(//Object/@Position_z)}"/>
			<entitiesExtentsMax
				x="{math:max(//Object/@Position_x)}"
				y="{math:max(//Object/@Position_y)}"
				z="{math:max(//Object/@Position_z)}"/>
			<entities>
				<xsl:apply-templates select="Object"/>
			</entities>
		</CMapData>
	</xsl:template>
	<func:function name="func:to-quaternion">
		<!-- ZYX Euler angles in degrees -->
		<xsl:param name="x"/>
		<xsl:param name="y"/>
		<xsl:param name="z"/>
		<!-- Convert degree values to radians -->
		<xsl:variable name="rx" select="-$x * ($pi div 180.0)"/>
		<xsl:variable name="ry" select="-$y * ($pi div 180.0)"/>
		<xsl:variable name="rz" select="-$z * ($pi div 180.0)"/>
		<!-- Calculate cos and sin of half x, y and z -->
		<xsl:variable name="cx" select="math:cos($rx * 0.5)"/>
		<xsl:variable name="sx" select="math:sin($rx * 0.5)"/>
		<xsl:variable name="cy" select="math:cos($ry * 0.5)"/>
		<xsl:variable name="sy" select="math:sin($ry * 0.5)"/>
		<xsl:variable name="cz" select="math:cos($rz * 0.5)"/>
		<xsl:variable name="sz" select="math:sin($rz * 0.5)"/>
		<!-- Calculate w, x, y and z of the quaternion -->
		<xsl:variable name="q">
			<x><xsl:value-of select="format-number($sx * $cy * $cz + $cx * $sy * $sz, '#.#####')"/></x>
			<y><xsl:value-of select="format-number($cx * $sy * $cz - $sx * $cy * $sz, '#.#####')"/></y>
			<z><xsl:value-of select="format-number($cx * $cy * $sz + $sx * $sy * $cz, '#.#####')"/></z>
			<w><xsl:value-of select="format-number($cx * $cy * $cz - $sx * $sy * $sz, '#.#####')"/></w>
		</xsl:variable>
		<func:result select="exsl:node-set($q)"/>
	</func:function>
	<xsl:template match="Object">
		<xsl:variable name="hash" select="@Hash"/>
		<xsl:variable name="q" select="func:to-quaternion(@Rotation_x, @Rotation_y, @Rotation_z)"/>
		<Item type="CEntityDef">
			<archetypeName>
				<xsl:value-of select="$objects//object[@hash = $hash]/@name"/>
			</archetypeName>
			<flags value="1572865"/>
			<position x="{@Position_x}" y="{@Position_y}" z="{@Position_z}"/>
			<rotation w="{$q/w}" x="{$q/x}" y="{$q/y}" z="{$q/z}"/>
			<scaleXY value="1"/>
			<scaleZ value="1"/>
			<parentIndex value="-1"/>
			<lodDist value="500"/>
			<childLodDist value="500"/>
			<lodLevel>LODTYPES_DEPTH_HD</lodLevel>
			<numChildren value="0"/>
			<ambientOcclusionMultiplier value="255"/>
			<artificialAmbientOcclusion value="255"/>
		</Item>
	</xsl:template>
</xsl:transform>
