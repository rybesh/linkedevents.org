#!/usr/bin/env python
# encoding: utf-8

import os
import re
import sys
import cherrypy

class Model:
    @cherrypy.expose
    def default(self):
        raise cherrypy.HTTPRedirect('../ontology/', status=301)

class Ontology:
    @cherrypy.expose
    def default(self, version_or_term=None, format=None):
        term = None
        version = 'current'
        if version_or_term:
            if re.match(r'\d{4}-\d{2}-\d{2}', version_or_term):
                version = version_or_term
            else:
                term = version_or_term
        if not format:
            if 'application/rdf+xml' in cherrypy.request.headers['Accept']:
                format = 'rdfxml'
            else:
                format = 'html'
        if format == 'html':
            if term:
                raise cherrypy.HTTPRedirect('./#term-' + term)
            return cherrypy.lib.static.serve_file(
                os.path.join(cwd, 'static', 'ontology', version, 'index.html'))
        if format == 'rdfxml':
            return cherrypy.lib.static.serve_file(
                os.path.join(cwd, 'static', 'ontology', version, 'index.rdf'),
                content_type='application/rdf+xml')
 
class Root:
    @cherrypy.expose
    def index(self):
        raise cherrypy.HTTPRedirect('http://view.linkedevents.org/session/browse')

def _init_webapp():
    root = Root()
    root.model = Model()
    root.ontology = Ontology()
    return root

if __name__ == "__main__":
    import doctest
    doctest.testmod()
else:
    cwd = os.path.dirname(os.path.abspath(__file__))
    sys.stdout = sys.stderr
    # site configuration
    cherrypy.server.unsubscribe()
    cherrypy.config.update({ 
            'environment': 'embedded',
            'request.show_tracebacks': True, 
            })
    # application configuration
    application = cherrypy.Application(_init_webapp(), None)
    application.config['/'] = {
        'tools.staticdir.root': os.path.join(cwd, 'static') }
    application.config['/img'] = {
        'tools.staticdir.on': True,
        'tools.staticdir.dir': 'img' }
    for path, file in static_content.iteritems():
        application.config[path] = { 
            'tools.staticfile.on': True,
            'tools.staticfile.filename': os.path.join(cwd, 'static', file) }

