<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
	<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

	<xsl:template match="alunos">
		<xsl:text>db.alus.insert([</xsl:text>
			<xsl:apply-templates select="//aluno" />
		<xsl:text>]);</xsl:text>
	</xsl:template>

	<xsl:template match="aluno">
		<xsl:text>{numero: </xsl:text><xsl:value-of select="./numero" /><xsl:text>, </xsl:text>
		<xsl:text>bi: "</xsl:text><xsl:value-of select="./bi" /><xsl:text>", </xsl:text>
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

		<xsl:text>a_lect_matricula: </xsl:text>
			<xsl:choose>
				<xsl:when test="./a_lect_matricula/text() != '' ">
					<xsl:value-of select="./a_lect_matricula" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>null</xsl:text>		
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>, </xsl:text>

		<xsl:text>estado: "</xsl:text><xsl:value-of select="./estado" /><xsl:text>", </xsl:text>

		<xsl:text>a_lect_conclusao: </xsl:text>
			<xsl:choose>
				<xsl:when test="./a_lect_conclusao/text() != '' ">
					<xsl:value-of select="./a_lect_conclusao" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>null</xsl:text>		
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>, </xsl:text>

		<xsl:text>med_cand: </xsl:text>
			<xsl:choose>
				<xsl:when test="./media_candidatura/text() != '' ">
					<xsl:value-of select="./media_candidatura" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>null</xsl:text>		
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>, </xsl:text>

		<xsl:text>med_final: </xsl:text>
			<xsl:choose>
				<xsl:when test="./med_final/text() != '' ">
					<xsl:value-of select="./med_final" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>null</xsl:text>		
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>}, </xsl:text>

	</xsl:template>

</xsl:stylesheet>