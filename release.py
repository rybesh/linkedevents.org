#! ./venv/bin/python3

"""
Utility for generating HTML documentation of the LODE ontology.
"""
import datetime
import os
import sys
from urllib.parse import urljoin
from lxml import etree
from rdflib import Graph, Literal, Namespace
from rdflib.namespace import RDF, OWL, DCTERMS, XSD

LODE = Namespace('http://linkedevents.org/ontology/')


def run(date):
    # Load current base ontology.
    g = Graph()
    g.parse('linkedevents.ttl', publicID=str(LODE), format='turtle')
    ontology = g.value(predicate=RDF.type, object=OWL.Ontology)
    g.add((ontology, DCTERMS.date, Literal(date, datatype=XSD.date)))
    g.add((ontology, DCTERMS.modified, Literal(date, datatype=XSD.date)))
    g.add((ontology, DCTERMS.identifier, Literal(f'{LODE}{date}/')))
    g.add((ontology, OWL.versionInfo, Literal(date)))

    # Write released ontology.
    release_dir = os.path.join('ontology', date)
    release_file = os.path.join(release_dir, 'index.rdf')
    if not os.path.isdir(release_dir):
        os.makedirs(release_dir)
    g.serialize(release_file, base=str(LODE), format='pretty-xml', max_depth=1)

    # Generate HTML documentation.
    def resolve_uri(context, relative_uri):
        return urljoin(context.context_node.base, relative_uri[0])
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
