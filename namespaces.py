import RDF

dbr = RDF.NS('http://dbpedia.org/resource/')
dbp = RDF.NS('http://dbpedia.org/property/')
dbo = RDF.NS('http://dbpedia.org/ontology/')
dcterm = RDF.NS('http://purl.org/dc/terms/')
dctype = RDF.NS('http://purl.org/dc/dcmitype/')
foaf = RDF.NS('http://xmlns.com/foaf/0.1/')
geo = RDF.NS('http://www.geonames.org/ontology#') 
geoR = RDF.NS('http://www.mindswap.org/2003/owl/geo/geoRelations.owl#')
ler = RDF.NS('http://linkedevents.org/resource/')
leo = RDF.NS('http://linkedevents.org/ontology/')
owl = RDF.NS('http://www.w3.org/2002/07/owl#')
rdf = RDF.NS('http://www.w3.org/1999/02/22-rdf-syntax-ns#')
rdfs = RDF.NS('http://www.w3.org/2000/01/rdf-schema#')
skos = RDF.NS('http://www.w3.org/2004/02/skos/core#')
time = RDF.NS('http://www.w3.org/2006/time#')
umbel = RDF.NS('http://umbel.org/umbel/sc/')
wgs84 = RDF.NS('http://www.w3.org/2003/01/geo/wgs84_pos#')
xsd = RDF.NS('http://www.w3.org/2001/XMLSchema#')
yago = RDF.NS('http://dbpedia.org/class/yago/')
vann = RDF.NS('http://purl.org/vocab/vann/')

import sys
import inspect

namespaces = dict(inspect.getmembers(sys.modules[__name__], 
                                     lambda o: isinstance(o, RDF.NS)))
prefixes = ''
for prefix, ns in namespaces.iteritems():
    prefixes += 'PREFIX %s: <%s>\n' % (prefix, ns._prefix)
