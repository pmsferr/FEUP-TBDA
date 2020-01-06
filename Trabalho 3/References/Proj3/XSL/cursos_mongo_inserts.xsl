<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

	<xsl:template match="lics">
		<xsl:text>db.lics.insert([</xsl:text>
			<xsl:apply-templates select="//lic" />
		<xsl:text>]);</xsl:text>
	</xsl:template>

	<xsl:template match="lic">
		<xsl:text>{codigo: </xsl:text><xsl:value-of select="./cod" /><xsl:text>, </xsl:text>
		<xsl:text>sigla: "</xsl:text><xsl:value-of select="./sigla" /><xsl:text>", </xsl:text>
		<xsl:text>nome: "</xsl:text><xsl:value-of select="./nome" /><xsl:text>"},</xsl:text>
	</xsl:template>

</xsl:stylesheet>



