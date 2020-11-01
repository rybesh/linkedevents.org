<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
                xmlns:foaf="http://xmlns.com/foaf/0.1/" 
                xmlns:wot="http://xmlns.com/wot/0.1/" 
                xmlns:dcterm="http://purl.org/dc/terms/" 
                xmlns:owl="http://www.w3.org/2002/07/owl#" 
                xmlns="http://www.w3.org/1999/xhtml" 
                xmlns:vann="http://purl.org/vocab/vann/"
                xmlns:cc="http://web.resource.org/cc/"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:py="http://python.org/"
                >
  <!--
This stylesheet was authored by Ian Davis (http://purl.org/NET/iand) and is in the public domain

Brief notes on the kind of RDF/XML this schema requires:

* Add an owl:Ontology element as child of rdf:RDF with rdf:about=""
* To owl:Ontology element
  o Add a dcterm:date attribute with date of schema version in YYYY-MM-DD format
  o Add dcterm:title element containing title of schema
  o Add as many rdfs:comment elements as necessary - these become the introductory text for the schema
  o Add a dcterm:identifier element containing the URI of the schema version
  o Add a dcterm:isVersionOf with an rdf:resource attribute containing the URI of the namespace for the vocabulary
  o Add a dcterm:creator element for each author
  o Add a dcterm:rights element containing a copyright statement
  o If schema is a revision of another then add dcterm:replaces element with rdf:resource attribute pointing to URI of previous version (without file type)
  o Add vann:preferredNamespaceUri containing literal value of the schema URI
  o Add vann:preferredNamespacePrefix containing a short namespace prefix (e.g. bio)
  o Add links to formats: 

<dcterm:hasFormat>
  <dctype:Text rdf:about="&vocabid;.html">
    <dcterm:format>
      <dcterm:IMT>
        <rdf:value>text/html</rdf:value>
        <rdfs:label xml:lang="en">HTML</rdfs:label>
      </dcterm:IMT>
    </dcterm:format>
  </dctype:Text>
</dcterm:hasFormat>

<dcterm:hasFormat>
  <dctype:Text rdf:about="&vocabid;.rdf">
    <dcterm:format>
      <dcterm:IMT>
        <rdf:value>application/rdf+xml</rdf:value>
        <rdfs:label xml:lang="en">RDF</rdfs:label>
      </dcterm:IMT>
    </dcterm:format>
  </dctype:Text>
</dcterm:hasFormat>

* Add dcterm:issued with the date the schema was first issued 
* For each property and class definition:
  o Important: add an rdfs:isDefinedBy element with rdf:resource attribute with value of schema namespace URI (whatever appeared in isVersionOf)
  o Add an rdfs:label element containing the short label for the term
  o Add a skos:defnition element containing the definition of the term. (Note when deciding on phrasing for the definition, property definitions will be prefixed with the phrase 'The value of this property is')
  o Add as many rdfs:comment elements as necessary to document the term
  o Add a dcterm:issued element containing the date the term was first issued in YYYY-MM-DD format
  o For each editorial change to previous version add a skos:changeNote elements with an rdf:value attribute describing the change, a dcterm:date attribute containing the date of the change in YYYY-MM-DD format and a dcterm:creator attribute containing the name of the change author
  o For each semantic change to previous version add a skos:historyNote elements with an rdf:value attribute describing the change, a dcterm:date attribute containing the date of the change in YYYY-MM-DD format and a dcterm:creator attribute containing the name of the change author 

  -->

  <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" standalone="no" indent="no"/>
  <xsl:param name="term" select="''"/>
  
  <xsl:variable name="vocabUri">
    <xsl:value-of select="/*/*[@rdf:about='']/dcterm:isVersionOf/@rdf:resource"/>
  </xsl:variable>


  <xsl:variable name="classes" select="/*/rdfs:Class[rdfs:isDefinedBy/@rdf:resource=$vocabUri]|/*/owl:Class[rdfs:isDefinedBy/@rdf:resource=$vocabUri]"/>
  <xsl:variable name="properties" select="/*/rdf:Property[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:TransitiveProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:SymmetricProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:AnnotationProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:DatatypeProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:FunctionalProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:InverseFunctionalProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:ObjectProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri] | /*/owl:OntologyProperty[rdfs:isDefinedBy/@rdf:resource=$vocabUri]"/>


  <xsl:template match="rdf:RDF">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      <head>
        <title>
          <xsl:value-of select="*[@rdf:about='']/dcterm:title|*[@rdf:about='']/@dcterm:title"/>
        </title>
        <link rel="alternate" type="application/rdf+xml">
          <xsl:attribute name="title">
            <xsl:value-of select="*[@rdf:about='']/dcterm:title|*[@rdf:about='']/@dcterm:title"/>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="concat(*[@rdf:about='']/dcterm:identifier, 'rdfxml/')"/>
          </xsl:attribute>
        </link>
        <xsl:call-template name="output-style"/>
      </head>

      <body>

        <h1>
          <xsl:value-of select="*[@rdf:about='']/dcterm:title|*[@rdf:about='']/@dcterm:title"/>
        </h1>
        <dl class="doc-info">
          <dt>This Version</dt>
          <dd>
            <a href="{*[@rdf:about='']/dcterm:identifier}">
              <xsl:value-of select="*[@rdf:about='']/dcterm:identifier"/>
            </a>
            <xsl:for-each select="*[@rdf:about='']/dcterm:hasFormat">
              <xsl:variable name="formatUri">
                <xsl:value-of select="@rdf:resource"/>
              </xsl:variable>
              <xsl:text> [</xsl:text>
              <a href="{../dcterm:identifier}{$formatUri}">
                <xsl:value-of select="/rdf:RDF/rdf:Description[@rdf:about=$formatUri]/dcterm:format/dcterm:IMT/rdfs:label"/>
              </a>
              <xsl:text>]</xsl:text>
            </xsl:for-each>
          </dd>

          <dt>Latest Version</dt>
          <dd>
            <a href="{py:resolve-uri(*[@rdf:about='']/dcterm:isVersionOf/@rdf:resource)}">
              <xsl:value-of select="py:resolve-uri(*[@rdf:about='']/dcterm:isVersionOf/@rdf:resource)"/>
            </a>
          </dd>

          <xsl:if test="*[@rdf:about='']/dcterm:replaces/@rdf:resource">
            <dt>Previous Version</dt>
            <dd>
              <a href="{py:resolve-uri(*[@rdf:about='']/dcterm:replaces/@rdf:resource)}">
                <xsl:value-of select="py:resolve-uri(*[@rdf:about='']/dcterm:replaces/@rdf:resource)"/>
              </a>
            </dd>
          </xsl:if>

          <xsl:if test="*[@rdf:about='']/dcterm:isPartOf/@rdf:resource">
            <dt>Part Of</dt>
            <xsl:for-each select="*[@rdf:about='']/dcterm:isPartOf">
              <dd>
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="removeExtension">
                      <xsl:with-param name="uri" select="@rdf:resource"/>
                    </xsl:call-template>                                                           
                  </xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="@dcterm:title">
                      <xsl:value-of select="@dcterm:title"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@rdf:resource"/>
                    </xsl:otherwise>                                  
                  </xsl:choose>
                </a>
              </dd>
            </xsl:for-each>
          </xsl:if>

          <dt>Authors</dt>
          <xsl:for-each select="*[@rdf:about='']/dcterm:creator">
            <dd>
              <a href="{*/foaf:homepage/@rdf:resource}">
                <xsl:value-of select="*/foaf:name"/>
              </a>
            </dd>
          </xsl:for-each>
          <dt>Contributors</dt>
          <xsl:for-each select="*[@rdf:about='']/dcterm:contributor">
            <dd>
              <a href="{*/foaf:homepage/@rdf:resource}">
                <xsl:value-of select="*/foaf:name"/>
              </a>
            </dd>
          </xsl:for-each>
        </dl>
        
        <xsl:if test="*[@rdf:about='']/dcterm:rights">
          <p class="rights">
            <xsl:value-of select="*[@rdf:about='']/dcterm:rights"/>
          </p>
        </xsl:if>
        
        <xsl:if test="*[@rdf:about='']/cc:license">
          <xsl:for-each select="*[@rdf:about='']/cc:license">
            <xsl:variable name="licenseUri">
              <xsl:value-of select="@rdf:resource"/>
            </xsl:variable>
            <p class="license">
              <xsl:text>This work is licensed under a </xsl:text>
              <a href="{$licenseUri}">Creative Commons License</a>
              <xsl:text>.</xsl:text>
            </p>
          </xsl:for-each>
        </xsl:if>


        <xsl:choose>
          <xsl:when test="$term">
            <xsl:apply-templates select="*[@rdf:about=$term]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="generate-html"/>
          </xsl:otherwise>
        </xsl:choose>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="generate-html">
    
    <h2 id="toc">Table of Contents</h2>
    <ul class="toc">
      <li>
        <a href="#sec-introduction">Introduction</a>
      </li>
      
      <xsl:if test="*[@rdf:about='']/dcterm:replaces">
        <li>
          <a href="#sec-changes">Changes From Previous Version</a>
        </li>
      </xsl:if> 
      
      <xsl:if test="*[@rdf:about='']/vann:preferredNamespaceUri">
        <li>
          <a href="#sec-namespace">Namespace</a>
        </li>
      </xsl:if>

      <li>
        <a href="#sec-terms">Summary of Terms</a>
      </li>

      <xsl:if test="count($classes) &gt; 0">
        <li>
          <a href="#sec-classes">Vocabulary Classes</a>
        </li>
      </xsl:if>

      <xsl:if test="count($properties) &gt; 0">
        <li>
          <a href="#sec-properties">Vocabulary Properties</a>
        </li>
      </xsl:if>
      
      <xsl:if test="count(*[@rdf:about='']/vann:example|*[@rdf:about='']/skos:example) &gt; 0">
        <li>
          <a href="#sec-examples">Examples</a>
        </li>
      </xsl:if>

      <xsl:if test="*[@rdf:about='']/cc:license">
        <li>
          <a href="#sec-license">License</a>
        </li>
      </xsl:if>
    </ul>
    
    
    
    <h2 id="sec-introduction">Introduction</h2>
    <xsl:apply-templates select="*[@rdf:about='']/dcterm:description|*[@rdf:about='']/rdfs:comment"/>


    <xsl:if test="*[@rdf:about='']/dcterm:replaces">
      <h2 id="sec-changes">Changes From Previous Version</h2>
      <ul>
        <xsl:if test="dcterm:issued|@dcterm:issued">
          <li><span class="date"><xsl:value-of select="*[@rdf:about='']/dcterm:issued|*[@rdf:about='']/@dcterm:issued"/></span> - first issued</li>
        </xsl:if>
        <xsl:apply-templates select="*[@rdf:about='']/skos:changeNote|*[@rdf:about='']/skos:historyNote" />
      </ul>
    </xsl:if>

    <xsl:if test="*[@rdf:about='']/vann:preferredNamespaceUri">
      <h2 id="sec-namespace">Namespace</h2>
      <p>The URI for this vocabulary is </p>
      <pre><code><xsl:value-of select="*[@rdf:about='']/vann:preferredNamespaceUri"/></code></pre>
      
      <xsl:if test="*[@rdf:about='']/vann:preferredNamespacePrefix">
        <p>
          When used in RDF or XML documents the suggested prefix is <code><xsl:value-of select="*[@rdf:about='']/vann:preferredNamespacePrefix"/></code>
        </p>
      </xsl:if>
      <p>Each class or property in the vocabulary has a URI constructed by appending a term name to the vocabulary URI. For example:</p>
      <pre><code><xsl:value-of select="py:resolve-uri($classes[1]/@rdf:about)"/><xsl:text>
</xsl:text><xsl:value-of select="py:resolve-uri($properties[1]/@rdf:about)"/></code></pre>        
<!--
      <p>The term name for a class always starts with an uppercase character. Where the term name is comprised of multiple 
      concatenated words, the leading character of each word will be an uppercase character. For example:
      </p>
      <pre><code>
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="$classes[1]/@rdf:about"/>
          </xsl:call-template><xsl:text>
        </xsl:text>
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="$classes[2]/@rdf:about"/>
      </xsl:call-template></code></pre>

      <p>The term name for a property always starts with an lowercase character. Where the term name is comprised of multiple 
      concatenated words, the leading character of the second and each subsequent word will be an uppercase character. For example:
      </p>
      <pre><code>
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="$properties[1]/@rdf:about"/>
          </xsl:call-template><xsl:text>
        </xsl:text>
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="$properties[2]/@rdf:about"/>
      </xsl:call-template></code></pre>
-->

    </xsl:if>

    <h2 id="sec-terms">Summary of Terms</h2>
    <p>This vocabulary defines

    <xsl:choose>
      <xsl:when test="count($classes) = 0">
        no classes
      </xsl:when>
      <xsl:when test="count($classes) = 1">
        one class
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count($classes)"/> classes 
      </xsl:otherwise>
    </xsl:choose>
    and 
    <xsl:choose>
      <xsl:when test="count($properties) = 0">
        no properties
      </xsl:when>
      <xsl:when test="count($properties) = 1">
        one property
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count($properties)"/> properties 
      </xsl:otherwise>
    </xsl:choose>
    .
    </p>
    <table>
      <thead>
        <tr>
          <th>Term Name</th>
          <th>Type</th>
          <th>Definition</th>
        </tr>    
      </thead>

      <xsl:for-each select="$classes">
        <xsl:sort select="@rdf:about"/>

        <xsl:variable name="termName">
          <xsl:call-template name="filename">
            <xsl:with-param name="fullPath" select="@rdf:about"/>
          </xsl:call-template>
        </xsl:variable>

        <tr>
          <td>
            <a>
              <xsl:attribute name="href"><xsl:text>#term-</xsl:text><xsl:value-of select="$termName"/></xsl:attribute>
              <xsl:attribute name="title"><xsl:value-of select="@rdf:about"/></xsl:attribute>
              <xsl:value-of select="$termName"/>
            </a>
          </td>
          <td><em>class</em></td>
          <td>
            <xsl:choose>
              <xsl:when test="skos:definition">
                <xsl:value-of select="skos:definition[1]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="rdfs:comment[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:for-each>

      <xsl:for-each select="$properties">
        <xsl:sort select="@rdf:about"/>

        <xsl:variable name="termName">
          <xsl:call-template name="filename">
            <xsl:with-param name="fullPath" select="@rdf:about"/>
          </xsl:call-template>
        </xsl:variable>

        <tr>
          <td>
            <a>
              <xsl:attribute name="href"><xsl:text>#term-</xsl:text><xsl:value-of select="$termName"/></xsl:attribute>
              <xsl:attribute name="title"><xsl:value-of select="@rdf:about"/></xsl:attribute>
              <xsl:value-of select="$termName"/>
            </a>
          </td>
          <td><em>property</em></td>
          <td>
            <xsl:choose>
              <xsl:when test="skos:definition">
                <xsl:value-of select="skos:definition[1]"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="rdfs:comment[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:for-each>

    </table>

    <xsl:if test="count($classes) &gt; 0">
      <h2 id="sec-classes">Vocabulary Classes</h2>
      <xsl:apply-templates select="$classes">
        <xsl:sort select="@rdf:about"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:if test="count($properties) &gt; 0">
      <h2 id="sec-properties">Vocabulary Properties</h2>
      <xsl:apply-templates select="$properties">
        <xsl:sort select="@rdf:about"/>
      </xsl:apply-templates>
    </xsl:if>

    <xsl:if test="count(*[@rdf:about='']/vann:example|*[@rdf:about='']/skos:example) &gt; 0">
      <h2 id="sec-examples">Examples</h2>
      <xsl:apply-templates select="*[@rdf:about='']/vann:example|*[@rdf:about='']/skos:example"/>
    </xsl:if>

    <xsl:if test="*[@rdf:about='']/cc:license">
      <h2 id="sec-license">License</h2>
      <xsl:for-each select="*[@rdf:about='']/cc:license">
        <xsl:variable name="licenseUri">
          <xsl:value-of select="@rdf:resource"/>
        </xsl:variable>
        <p class="license">
          <xsl:text>This work is licensed under a </xsl:text>
          <a href="{$licenseUri}">Creative Commons License</a>
          <xsl:text>.</xsl:text>
          <xsl:apply-templates select="/rdf:RDF/cc:License[@rdf:about=$licenseUri]"/>
        </p>
      </xsl:for-each>
    </xsl:if>

  </xsl:template>

  
  <xsl:template match="rdf:Property|owl:TransitiveProperty|owl:SymmetricProperty|owl:AnnotationProperty|owl:DatatypeProperty|owl:FunctionalProperty|owl:InverseFunctionalProperty|owl:ObjectProperty|owl:OntologyProperty">
    <xsl:variable name="uri" select="@rdf:about"/>

    <div class="property">

      <h3>
        <xsl:attribute name="id"><xsl:text>term-</xsl:text><xsl:call-template name="filename"><xsl:with-param name="fullPath" select="@rdf:about"/></xsl:call-template></xsl:attribute>
        <xsl:text>Property: </xsl:text>
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="@rdf:about"/>
        </xsl:call-template>
        
      </h3>
      <div class="description">
        <xsl:apply-templates select="skos:definition">
          <xsl:with-param name="prelude" select="'[The value of this property is] '"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="rdfs:comment|@rdfs:comment" />
        
        <table class="properties">  
          <tbody>
            <tr>
              <th>URI:</th>
              <td>
                <xsl:value-of select="py:resolve-uri($uri)"/>
              </td>
            </tr>
            <xsl:for-each select="rdfs:label|@rdfs:label">
              <tr>
                <th>Label:</th>
                <td>
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>


            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="rdfs:domain"/>
              <xsl:with-param name="label" select="'Domain'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="rdfs:range"/>
              <xsl:with-param name="label" select="'Range'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="rdfs:subPropertyOf"/>
              <xsl:with-param name="label" select="'Subproperty of'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="owl:inverseOf"/>
              <xsl:with-param name="label" select="'Inverse of'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="owl:sameAs"/>
              <xsl:with-param name="label" select="'Same as'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="rdfs:seeAlso"/>
              <xsl:with-param name="label" select="'See also'"/>
            </xsl:call-template>
<!--
            <xsl:if test="count(rdfs:domain) &gt; 0">
              <tr>
                <th>Paraphrase (experimental)</th>
                <td>
                  Having a <xsl:call-template name="makeTermReference"><xsl:with-param name="uri" select="@rdf:about"/></xsl:call-template>
                  implies being
                  <xsl:apply-templates select="rdfs:domain" mode="paraphrase" />
                </td>
              </tr>
            </xsl:if>
-->
          </tbody>
        </table>

        <h4>History</h4>
        <ul class="historyList">
          <xsl:if test="dcterm:issued|@dcterm:issued">
            <li><span class="date"><xsl:value-of select="dcterm:issued|@dcterm:issued"/></span> - first issued</li>
          </xsl:if>
          <xsl:apply-templates select="skos:changeNote|skos:historyNote" />
        </ul>

      </div>                    
      
      
    </div>
  </xsl:template>



  <xsl:template match="rdfs:Class|owl:Class">
    <div class="class">
      <h3>
        <xsl:attribute name="id"><xsl:text>term-</xsl:text><xsl:call-template name="filename"><xsl:with-param name="fullPath" select="@rdf:about"/></xsl:call-template></xsl:attribute>
        <xsl:text>Class: </xsl:text>
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="@rdf:about"/>
        </xsl:call-template>
      </h3>
      <div class="description">
        <xsl:apply-templates select="skos:definition" />
        <xsl:apply-templates select="rdfs:comment|@rdfs:comment" />

        <table class="properties">  
          <tbody>
            <tr>
              <th>URI:</th>
              <td>
                <xsl:value-of select="py:resolve-uri(@rdf:about)"/>
              </td>
            </tr>
            <xsl:for-each select="rdfs:label|@rdfs:label">
              <tr>
                <th>Label:</th>
                <td>
                  <xsl:value-of select="."/>
                </td>
              </tr>
            </xsl:for-each>
            
            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="rdfs:subClassOf"/>
              <xsl:with-param name="label" select="'Subclass of'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="owl:disjointWith"/>
              <xsl:with-param name="label" select="'Disjoint with'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="owl:equivalentClass"/>
              <xsl:with-param name="label" select="'Equivalent to'"/>
            </xsl:call-template>

            <xsl:call-template name="resourceList">
              <xsl:with-param name="properties" select="owl:sameAs"/>
              <xsl:with-param name="label" select="'Same as'"/>
            </xsl:call-template>
<!--
            <xsl:if test="count(owl:disjointWith|rdfs:subClassOf|owl:equivalentClass) &gt; 0">
              <tr>
                <th>Paraphrase (experimental)</th>
                <td>
                  
                  A <xsl:call-template name="makeTermReference"><xsl:with-param name="uri" select="@rdf:about"/></xsl:call-template>
                  is something that, amongst other things, 
                  <xsl:apply-templates select="rdfs:subClassOf" mode="paraphrase" />
                  <xsl:if test="count(owl:disjointWith) &gt; 0 and count(rdfs:subClassOf) &gt; 0">
                    <xsl:text> but  </xsl:text>
                  </xsl:if>
                  <xsl:apply-templates select="owl:disjointWith" mode="paraphrase" />
                  <xsl:if test="count(owl:disjointWith|rdfs:subClassOf) &gt; 0 and count(owl:equivalentClass) &gt; 0">
                    <xsl:text> and must be </xsl:text>
                  </xsl:if>
                  <xsl:apply-templates select="owl:equivalentClass" mode="paraphrase" />
                </td>
              </tr>
            </xsl:if>
-->
          </tbody>
        </table>

        <h4>History</h4>
        <ul class="historyList">
          <xsl:if test="dcterm:issued|@dcterm:issued">
            <li><span class="date"><xsl:value-of select="dcterm:issued|@dcterm:issued"/></span> - first issued</li>
          </xsl:if>
          <xsl:apply-templates select="skos:changeNote|skos:historyNote" />
        </ul>

      </div>


    </div>      
  </xsl:template>

  <!-- ======================================================================== -->
  <!--                                                                          PROPERTIES                                                                                 -->
  <!-- ======================================================================== -->


  <xsl:template name="resourceList">
    <xsl:param name="properties"/>
    <xsl:param name="label"/>
    <xsl:if test="count($properties) &gt; 0">
      <tr>
        <th><xsl:value-of select="$label"/>:</th>
        <td>
          <xsl:apply-templates select="$properties" mode="property"/>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[@rdf:resource]" mode="property">
    <xsl:variable name="name" select="name(.)"/>
    <xsl:if test="count(preceding-sibling::*[name() = $name]) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*[name() = $name]) = 0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:call-template name="makeTermReference">
      <xsl:with-param name="uri" select="@rdf:resource"/>
      <xsl:with-param name="label" select="@rdfs:label"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="*[owl:Class]" mode="property">
    <xsl:variable name="name" select="name(.)"/>
    <xsl:if test="count(preceding-sibling::*[name() = $name]) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*[name() = $name]) = 0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:apply-templates select="owl:Class" mode="reference"/>
  </xsl:template>

  <xsl:template match="*" mode="property">
    <xsl:if test="count(preceding-sibling::*) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*) = 0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

    <xsl:text>(a composite term, see schema)</xsl:text>
  </xsl:template>


  <xsl:template match="owl:Class" mode="reference">
    <!-- Describes a reference to an owl:Class -->
    <xsl:choose>
      <xsl:when test="owl:unionOf[@rdf:parseType='Collection']/owl:Class">
        <xsl:text>Union of </xsl:text>
        <xsl:apply-templates mode="reference"/>
      </xsl:when>
      <xsl:when test="owl:intersectionOf[@rdf:parseType='Collection']/owl:Class">
        <xsl:text>Intersection of </xsl:text>
        <xsl:apply-templates mode="reference"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>(composite term, see schema)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="owl:unionOf/owl:Class" mode="reference">
    <!-- Describes a reference to an owl:Class that is part of a union with other classes -->
    <xsl:if test="count(preceding-sibling::*) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*) = 0">
          <xsl:text> or a </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:call-template name="makeTermReference">
      <xsl:with-param name="uri" select="@rdf:about"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="owl:intersectionOf/owl:Class" mode="reference">
    <!-- Describes a reference to an owl:Class that is part of an intersection with other classes -->
    <xsl:if test="count(preceding-sibling::*) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*) = 0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="owl:complementOf/@rdf:resource">
        <xsl:text>everything that is not a </xsl:text>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="owl:complementOf/@rdf:resource"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="@rdf:about"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="owl:intersectionOf/owl:Restriction" mode="reference">
    <xsl:if test="count(preceding-sibling::*) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*) = 0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text> things that have </xsl:text>
    <xsl:choose>
      <xsl:when test="owl:minCardinality">
        <xsl:text> at least </xsl:text>
        <xsl:value-of select="owl:minCardinality"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="owl:onProperty/@rdf:resource"/>
        </xsl:call-template>
        <xsl:text> property</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        (a complex restriction, see schema)
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================== -->
  <!--                                     PARAPHRASE                           -->
  <!-- ======================================================================== -->

  <xsl:template match="owl:disjointWith" mode="paraphrase">
    <xsl:if test="count(preceding-sibling::owl:disjointWith) &gt; 0">
      <xsl:text > and </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@rdf:resource">
        is not a
        <xsl:call-template name="makeTermReference"><xsl:with-param name="uri" select="@rdf:resource"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="paraphrase" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="rdfs:subClassOf" mode="paraphrase">
    <xsl:if test="count(preceding-sibling::rdfs:subClassOf) &gt; 0">
      <xsl:text > and </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@rdf:resource">
        is a
        <xsl:call-template name="makeTermReference"><xsl:with-param name="uri" select="@rdf:resource"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="paraphrase" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rdfs:domain" mode="paraphrase">
    <xsl:if test="count(preceding-sibling::rdfs:domain) &gt; 0">
      <xsl:text > and a </xsl:text>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@rdf:resource">
        <xsl:text> something that, amongst other things, is a </xsl:text>
        <xsl:call-template name="makeTermReference"><xsl:with-param name="uri" select="@rdf:resource"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="paraphrase" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="owl:Class" mode="paraphrase">
    <xsl:choose>
      <xsl:when test="@rdf:about">
        <xsl:if test="count(preceding-sibling::*) &gt; 0">
          <xsl:text >, </xsl:text>
        </xsl:if>
        <xsl:call-template name="makeTermReference"><xsl:with-param name="uri" select="@rdf:about"/></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        something that, amongst other things, is a 
        <xsl:apply-templates mode="paraphrase" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template match="*|text()" mode="paraphrase">
    <xsl:apply-templates mode="paraphrase" />
  </xsl:template>

  <xsl:template match="text()" mode="head"/>
  <xsl:template match="text()" mode="body"/>
  <xsl:template match="rdf:Description[@rdf:about='']/dcterm:title" mode="head">
    <title>
      <xsl:value-of select="."/>
    </title>
  </xsl:template>
  <xsl:template match="rdf:Description[@rdf:about='']/dcterm:contributor" mode="body">
    <h1>
      <xsl:value-of select="."/>
    </h1>
  </xsl:template>

  <xsl:template match="owl:unionOf/owl:Class" mode="paraphrase">
    <!-- Describes a reference to an owl:Class that is part of a union with other classes -->
    <xsl:if test="count(preceding-sibling::*) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*) = 0">
          <xsl:text> or a </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:call-template name="makeTermReference">
      <xsl:with-param name="uri" select="@rdf:about"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="owl:intersectionOf/owl:Class" mode="paraphrase">
    <!-- Describes a reference to an owl:Class that is part of an intersection with other classes -->
    <xsl:if test="count(preceding-sibling::*) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*) = 0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="owl:complementOf/@rdf:resource">
        <xsl:text>everything that is not a </xsl:text>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="owl:complementOf/@rdf:resource"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="@rdf:about"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="owl:intersectionOf/owl:Restriction|rdfs:subClassOf/owl:Restriction" mode="paraphrase">
    <xsl:if test="count(preceding-sibling::*) &gt; 0">
      <xsl:choose>
        <xsl:when test="count(following-sibling::*) = 0">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text> has </xsl:text>
    <xsl:choose>
      <xsl:when test="owl:minCardinality">
        <xsl:text> at least </xsl:text>
        <xsl:value-of select="owl:minCardinality"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="owl:onProperty/@rdf:resource"/>
        </xsl:call-template>
        <xsl:text> property</xsl:text>
      </xsl:when>
      <xsl:when test="owl:cardinality">
        <xsl:text> exactly </xsl:text>
        <xsl:value-of select="owl:cardinality"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="owl:onProperty/@rdf:resource"/>
        </xsl:call-template>
        <xsl:text> property</xsl:text>
      </xsl:when>
      <xsl:when test="owl:maxCardinality">
        <xsl:text> no more than </xsl:text>
        <xsl:value-of select="owl:maxCardinality"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="makeTermReference">
          <xsl:with-param name="uri" select="owl:onProperty/@rdf:resource"/>
        </xsl:call-template>
        <xsl:text> property</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        (a complex restriction, see schema)
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>





  <!-- -->

  <xsl:template match="skos:definition|@skos:definition">
    <xsl:param name="prelude"/>
    <p class="definition">
      <strong>Definition: </strong>
      <xsl:value-of select="$prelude"/>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="skos:scopeNote|@skos:scopeNote">
    <p class="scopeNote">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="rdfs:comment|@rdfs:comment">
    <p class="comment">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="skos:changeNote">
    <li class="changeNote">
      <xsl:value-of select="@dcterm:date|*/dcterm:date"/> - editorial change by <xsl:value-of select="@dcterm:creator|*/dcterm:creator"/>:
      "<xsl:value-of select="@rdf:value|*/rdf:value"/>"
    </li>
  </xsl:template>

  <xsl:template match="skos:historyNote">
    <li class="historyNote">
      <xsl:value-of select="@dcterm:date|*/dcterm:date"/> - semantic change by <xsl:value-of select="@dcterm:creator|*/dcterm:creator"/>:
      "<xsl:value-of select="@rdf:value|*/rdf:value"/>"
    </li>
  </xsl:template>


  <xsl:template match="dcterm:description">
    <p class="description">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="vann:example|skos:example">
    <div class="example">
      <h3>
        <xsl:choose>
          <xsl:when test="dcterm:title|@dcterm:title">
            <xsl:value-of select="dcterm:title|@dcterm:title"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="document(@rdf:resource)/*[local-name() = 'html'][1]/*[local-name() = 'head'][1]/*[local-name() = 'title'][1]"/>
          </xsl:otherwise>
        </xsl:choose>
      </h3>
      <xsl:copy-of select="document(@rdf:resource)/*[local-name() = 'html'][1]/*[local-name() = 'body'][1]"/>
    </div>
  </xsl:template>

  
  
  <xsl:template match="vann:usageNote"  >
    <div class="usage-note">
      <xsl:variable name="filename">
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="@rdf:resource" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy-of select="document(@rdf:resource)/*[local-name() = 'html'][1]/*[local-name() = 'body'][1]"/>
    </div>
  </xsl:template>


  <xsl:template match="vann:changes">
    <div class="changes">
      <xsl:variable name="filename">
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="@rdf:resource" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy-of select="document(@rdf:resource)/*[local-name() = 'html'][1]/*[local-name() = 'body'][1]"/>
    </div>
  </xsl:template>

  <xsl:template match="cc:License">
    <p>The following section is informational only, please refer to the 
    <a href="{@rdf:about}">Original License</a> for complete license terms.
    </p>
    <xsl:if test="count(cc:permits) &gt; 0">
      <p>This license grants the following rights:</p>
      <ul>
        <xsl:for-each select="cc:permits">
          <xsl:variable name="uri" select="@rdf:resource" />
          <li>
            <xsl:value-of select="document('cc-schema.rdfs')//*[@rdf:about = $uri]/dcterm:description"/>
            (<a href="{$uri}"><xsl:value-of select="$uri"/></a>)
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    <xsl:if test="count(cc:requires) &gt; 0">
      <p>This license imposes the following restrictions:</p>
      <ul>
        <xsl:for-each select="cc:requires">
          <xsl:variable name="uri" select="@rdf:resource" />
          <li>
            <xsl:value-of select="document('cc-schema.rdfs')//*[@rdf:about = $uri]/dcterm:description"/>
            (<a href="{$uri}"><xsl:value-of select="$uri"/></a>)
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>           
    <xsl:if test="count(cc:prohibits) &gt; 0">
      <p>This license prohibits the following:</p>
      <ul>
        <xsl:for-each select="cc:prohibits">
          <xsl:variable name="uri" select="@rdf:resource" />
          <li>
            <xsl:value-of select="document('cc-schema.rdfs')//*[@rdf:about = $uri]/dcterm:description"/>
            (<a href="{$uri}"><xsl:value-of select="$uri"/></a>)
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>


  <xsl:template name="output-style">
    <link rel="stylesheet" type="text/css" href="/style.css" />
  </xsl:template>


  <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
  <!--          U T I L I T Y    T E M P L A T E S                                  -->
  <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
  <xsl:template name="filename">
    <xsl:param name="fullPath"/>
    <xsl:choose>
      <xsl:when test="contains($fullPath,'#')">
        <xsl:value-of select="substring-after($fullPath,'#')"/>
      </xsl:when>
      <xsl:when test="contains($fullPath,'/')">
        <xsl:call-template name="filename">
          <xsl:with-param name="fullPath" select="substring-after($fullPath,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fullPath"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- ............................................................................ -->
  <xsl:template name="replaceString">
    <xsl:param name="input"/>
    <xsl:param name="searchFor"/>
    <xsl:param name="replaceWith"/>
    <xsl:choose>
      <xsl:when test="contains($input, $searchFor)">
        <xsl:value-of select="substring-before($input, $searchFor)"/>
        <xsl:value-of select="$replaceWith"/>
        <xsl:value-of select="substring-after($input, $searchFor)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$input"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="rdfToHtmlExtension">
    <xsl:param name="uri"/>
    <xsl:choose>
      <xsl:when test="contains($uri, '.rdf')">
        <xsl:value-of select="substring-before($uri, '.rdf')"/>
        <xsl:text>.html</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$uri"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name="removeExtension">
    <xsl:param name="uri"/>
    <xsl:choose>
      <xsl:when test="contains($uri, '.rdf')">
        <xsl:value-of select="substring-before($uri, '.rdf')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$uri"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template name="removeLeadingAnd">
    <xsl:param name="text"/>
    <xsl:choose>
      <xsl:when test="starts-with($text, ' and ')">
        <xsl:value-of select="substring-after($text, ' and ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template name="indent">
    <xsl:param name="depth" select="0"/>
    <xsl:if test="$depth &gt; 0">
      <xsl:text> </xsl:text>
      <xsl:call-template name="indent">
        <xsl:with-param name="depth" select="$depth - 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>



  <xsl:template name="termList">
    <xsl:param name="termUris"/>
    <xsl:param name="listConjunction"/>

    <xsl:call-template name="makeTermReference">
      <xsl:with-param name="uri" select="$termUris[1]"/>
    </xsl:call-template>

    <xsl:if test="count($termUris) &gt; 1">
      <xsl:if test="count($termUris) &gt; 2">
        <xsl:for-each select="$termUris[position() &gt; 1 and position() &lt; count($termUris)]">
          <xsl:text>, </xsl:text>
          <xsl:call-template name="makeTermReference">
            <xsl:with-param name="uri" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <xsl:text> </xsl:text> 
      <xsl:value-of select="$listConjunction"/>
      <xsl:text> </xsl:text>
      <xsl:call-template name="makeTermReference">
        <xsl:with-param name="uri" select="$termUris[position() = last()]"/>
      </xsl:call-template>
    </xsl:if>

  </xsl:template>

  <xsl:template name="makeTermReference">
    <xsl:param name="uri" />

    <xsl:choose>
      <xsl:when test="$uri">

        <xsl:variable name="termQName">
          <xsl:choose>
            <xsl:when test="string-length($vocabUri) and starts-with($uri, $vocabUri) and count ( //*[@rdf:about='']/vann:preferredNamespacePrefix )">
              <xsl:value-of select="//*[@rdf:about='']/vann:preferredNamespacePrefix"/>
              <xsl:text>:</xsl:text>
              <xsl:value-of select="substring-after($uri, $vocabUri)"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2002/07/owl#')">
              <xsl:text>owl:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2002/07/owl#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://purl.org/dc/dcmitype/')">
              <xsl:text>dctype:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://purl.org/dc/dcmitype/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2003/01/geo/wgs84_pos#')">
              <xsl:text>geo:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2003/01/geo/wgs84_pos#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.w3.org/2006/time#')">
              <xsl:text>time:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.w3.org/2006/time#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.cidoc-crm.org/cidoc-crm/')">
              <xsl:text>crm:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.cidoc-crm.org/cidoc-crm/')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://purl.org/NET/c4dm/event.owl#')">
              <xsl:text>event:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://purl.org/NET/c4dm/event.owl#')"/>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#')">
              <xsl:text>dul:</xsl:text>
              <xsl:value-of select="substring-after($uri, 'http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#')"/>
            </xsl:when>

            <xsl:otherwise>
              <xsl:value-of select="$uri" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
          <xsl:when test="//*[@rdf:about=$uri]/rdfs:label">
            <xsl:variable name="termName">
              <xsl:call-template name="filename">
                <xsl:with-param name="fullPath" select="$uri"/>
              </xsl:call-template>
            </xsl:variable>
            <a>
              <xsl:attribute name="href"><xsl:text>#term-</xsl:text><xsl:value-of select="$termName"/></xsl:attribute>
              <xsl:attribute name="title"><xsl:value-of select="$uri"/></xsl:attribute>
              <xsl:value-of select="$termQName"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a>
              <xsl:attribute name="href"><xsl:value-of select="$uri"/></xsl:attribute>
              <xsl:value-of select="$termQName"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:otherwise>
        <xsl:text>(composite term ref, see schema)</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
