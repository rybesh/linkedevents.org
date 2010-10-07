This is a tiny webapp for serving the LODE ontology as HTML and RDF/XML. 


The following installation procedure is intended to be run on a local machine, 
targeting a remote web server. It assumes that the remote web server is running
Apache and [mod_wsgi][], and that the `linkedevents.org` domain and 
`view.linkedevents.org` subdomain are pointed to the remote web server's IP 
address.

To install:


1. Install [Fabric][] on your local machine.
2. Install [virtualenv][] on your remote web server.
3. Check out this project to a directory on your local machine, and `cd` to that directory.
4. Edit the configuration section of `fabfile.py` to suit your situation.
5. Run `fab deploy`. You will be prompted for the hostname of your remote web server.

[mod_wsgi]: http://code.google.com/p/modwsgi/
[Fabric]: http://fabfile.org/
[virtualenv]: http://pypi.python.org/pypi/virtualenv
