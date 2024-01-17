#! ./venv/bin/python3

"""
Utility for generating HTML documentation of the LODE ontology.
"""
import datetime
import os
import re
import sys
from glob import glob
from urllib.parse import urljoin
from lxml import etree
from rdflib import Graph, URIRef, Literal, Namespace
from rdflib.namespace import (
    RDF,
    OWL,
    DCTERMS,
    XSD,
)

LODE = Namespace("http://linkedevents.org/ontology/")
LODE_SECURE = Namespace("https://linkedevents.org/ontology/")


def run(date, previous_date):
    # Load current base ontology.
    g = Graph()
    g.parse("linkedevents.ttl", publicID=str(LODE), format="turtle")
    ontology = g.value(predicate=RDF.type, object=OWL.Ontology)
    g.add((ontology, DCTERMS.date, Literal(date, datatype=XSD.date)))  # type: ignore
    g.add((ontology, DCTERMS.modified, Literal(date, datatype=XSD.date)))  # type: ignore
    g.add((ontology, DCTERMS.identifier, Literal(f"{LODE_SECURE}{date}/")))  # type: ignore
    g.add((ontology, OWL.versionInfo, Literal(date)))  # type: ignore
    if previous_date:
        g.add((ontology, DCTERMS.replaces, URIRef(f"{LODE}{previous_date}/")))  # type: ignore

    # Write released ontology.
    release_dir = os.path.join("ontology", date)
    rdfxml_file = os.path.join(release_dir, "index.rdf")
    turtle_file = os.path.join(release_dir, "index.ttl")
    if not os.path.isdir(release_dir):
        os.makedirs(release_dir)
    g.serialize(rdfxml_file, base=str(LODE), format="pretty-xml", max_depth=1)
    g.serialize(turtle_file, base=str(LODE), format="turtle")

    # Generate HTML documentation.
    def resolve_uri(context, relative_uri):
        base = context.context_node.base
        relative_uri = relative_uri[0]
        if len(relative_uri) == 0 or re.match(r"^\d{4}-\d{2}-\d{2}/$", relative_uri):
            base = base.replace("http", "https", 1)
        return urljoin(base, relative_uri)

    ns = etree.FunctionNamespace("http://python.org/")
    ns["resolve-uri"] = resolve_uri
    transform = etree.XSLT(etree.parse("vocab-toolchain/html-docs.xsl"))
    html = transform(etree.parse(rdfxml_file))
    html.write(os.path.join(release_dir, "index.html"), method="html")


def parse_date(string):
    return datetime.datetime.strptime(string, "%Y-%m-%d").date()


def find_previous(date):
    def path_to_date(path):
        return parse_date(path.split("/")[1])

    previous_dates = list(
        filter(lambda d: d < date, map(path_to_date, glob("ontology/????-??-??")))
    )
    if len(previous_dates) == 0:
        return None
    else:
        return max(previous_dates).isoformat()


if __name__ == "__main__":
    date = datetime.date.today()
    if len(sys.argv) > 1:
        try:
            date = parse_date(sys.argv[1])
        except ValueError:
            sys.exit("Usage: %s [YYYY-MM-DD]" % sys.argv[0])
    run(date.isoformat(), find_previous(date))
