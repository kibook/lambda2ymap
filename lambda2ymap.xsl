<?xml version="1.0"?>
<xsl:transform
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	xmlns:math="http://exslt.org/math"
	version="1.0"
	exclude-result-prefixes="exsl math">
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
	<xsl:template name="to-quaternion">
		<xsl:param name="pitch"/>
		<xsl:param name="roll"/>
		<xsl:param name="yaw"/>
		<xsl:variable name="p" select="$pitch * -1 * ($pi div 180.0)"/>
		<xsl:variable name="r" select="$yaw   * -1 * ($pi div 180.0)"/>
		<xsl:variable name="y" select="$roll  * -1 * ($pi div 180.0)"/>
		<xsl:variable name="cy" select="math:cos($y * 0.5)"/>
		<xsl:variable name="sy" select="math:sin($y * 0.5)"/>
		<xsl:variable name="cr" select="math:cos($r * 0.5)"/>
		<xsl:variable name="sr" select="math:sin($r * 0.5)"/>
		<xsl:variable name="cp" select="math:cos($p * 0.5)"/>
		<xsl:variable name="sp" select="math:sin($p * 0.5)"/>
		<x><xsl:value-of select="$cy * $sp * $cr + $sy * $cp * $sr"/></x>
		<y><xsl:value-of select="$sy * $cp * $cr - $cy * $sp * $sr"/></y>
		<z><xsl:value-of select="$cy * $cp * $sr - $sy * $sp * $cr"/></z>
		<w><xsl:value-of select="$cy * $cp * $cr + $sy * $sp * $sr"/></w>
	</xsl:template>
	<xsl:template match="Object">
		<xsl:variable name="quat">
			<xsl:call-template name="to-quaternion">
				<xsl:with-param name="pitch" select="@Rotation_x"/>
				<xsl:with-param name="roll"  select="@Rotation_y"/>
				<xsl:with-param name="yaw"   select="@Rotation_z"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="q" select="exsl:node-set($quat)"/>
		<xsl:variable name="hash" select="@Hash"/>
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
