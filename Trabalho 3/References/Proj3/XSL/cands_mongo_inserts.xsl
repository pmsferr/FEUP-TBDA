<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

	<xsl:template match="cands">
		<xsl:text>db.cands.insert([</xsl:text>
			<xsl:apply-templates select="//cand" />
		<xsl:text>]);</xsl:text>
	</xsl:template>

	<xsl:template match="cand">
		<xsl:text>{bi: "</xsl:text><xsl:value-of select="./bi" /><xsl:text>", </xsl:text>
		<xsl:text>curso: </xsl:text>
			<xsl:choose>
				<xsl:when test="./curso/text() != '' ">
					<xsl:value-of select="./curso" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>null</xsl:text>		
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>, </xsl:text>
		<xsl:text>ano_lectivo: </xsl:text><xsl:value-of select="./ano_lectivo" /><xsl:text>, </xsl:text>
		<xsl:text>resultado: "</xsl:text><xsl:value-of select="./resultado" /><xsl:text>", </xsl:text>
		<xsl:text>media: </xsl:text>
			<xsl:choose>
				<xsl:when test="./media/text() != ''">
					<xsl:value-of select="./media" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>null</xsl:text>		
				</xsl:otherwise>
			</xsl:choose>
		<xsl:text>}, </xsl:text>
	</xsl:template>

</xsl:stylesheet>