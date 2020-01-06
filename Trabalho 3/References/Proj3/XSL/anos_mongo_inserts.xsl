<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

	<xsl:template match="anos">
		<xsl:text>db.anos.insert([</xsl:text>
			<xsl:apply-templates select="//ano" />
		<xsl:text>]);</xsl:text>
	</xsl:template>

	<xsl:template match="ano">
		<xsl:text>{ano: </xsl:text><xsl:value-of select="." /><xsl:text>}, </xsl:text>
	</xsl:template>

</xsl:stylesheet>



