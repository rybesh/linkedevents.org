#!/usr/bin/env python
# encoding: utf-8
"""
Utility for deploying new releases of the LODE ontology.
"""
import RDF
import datetime
import os
import sys
import urlparse
from lxml import etree
from namespaces import *

def run(date):
    # Load current master ontology.
    m = RDF.Model()
    parser = RDF.Parser(name='turtle')
    base_uri = leo._prefix
    parser.parse_string_into_model(m, open('linkedevents.ttl').read(), base_uri)
    ontology = m.get_source(rdf.type, owl.Ontology)
    m.append(RDF.Statement(
            ontology, dcterm.date, 
            RDF.Node(literal=date, datatype=xsd.date.uri)))
    m.append(RDF.Statement(
            ontology, dcterm.modified, 
            RDF.Node(literal=date, datatype=xsd.date.uri)))
    m.append(RDF.Statement(
            ontology, dcterm.identifier, 
            RDF.Node(literal=(base_uri + date + '/'))))
    m.append(RDF.Statement(
            ontology, owl.versionInfo, 
            RDF.Node(literal=date)))
    # Write released ontology.
    serializer = RDF.Serializer(name='rdfxml-abbrev')
    for prefix, ns in namespaces.iteritems():
        serializer.set_namespace(prefix, ns._prefix)
    release_dir = os.path.join('static', 'ontology', date)
    if not os.path.isdir(release_dir):
        os.makedirs(release_dir)
    release_file = os.path.join(release_dir, 'index.rdf')
    serializer.serialize_model_to_file(release_file, m, base_uri=base_uri)
    # Generate HTML documentation.
    def resolve_uri(context, relative_uri):
        return urlparse.urljoin(context.context_node.base, relative_uri[0])
    ns = etree.FunctionNamespace('http://python.org/')
    ns['resolve-uri'] = resolve_uri
    transform = etree.XSLT(etree.parse('vocab-toolchain/html-docs.xsl'))
    html = transform(etree.parse(release_file))
    html.write(os.path.join(release_dir, 'index.html'), method='html')
    

if __name__ == '__main__':
    date = datetime.date.today()
    if len(sys.argv) > 1:
        try:
            date = datetime.datetime.strptime(sys.argv[1], '%Y-%m-%d').date()
        except ValueError:
            sys.exit('Usage: %s [YYYY-MM-DD]' % sys.argv[0])
    run(date.isoformat())
