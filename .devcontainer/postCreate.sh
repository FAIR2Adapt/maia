#!/bin/bash
set -euxo pipefail

# Clone the Skosmos source
if [ ! -d "skosmos-src" ]; then
  git clone --depth 1 https://github.com/NatLibFi/Skosmos.git skosmos-src
# If we rebuild the dev container, undo the changes we made to the config
else
  git -C skosmos-src restore -- dockerfiles/config/config-docker-compose.ttl
  rm -f skosmos-src/dockerfiles/config/config-docker-compose.ttl.bak
  echo ''
fi

# Delete default vocabulary blocks
sed -i.bak -e '/^:unesco /,/^ *\.$/d' -e '/^:stw /,/^ *\.$/d' skosmos-src/dockerfiles/config/config-docker-compose.ttl

# Append the vocabulary block info
cat <<'EOF' >> skosmos-src/dockerfiles/config/config-docker-compose.ttl
:MAIA a skosmos:Vocabulary, void:Dataset ;
  dc:title "MAIA"@en ;
  skosmos:shortName "MAIA" ;
  skosmos:defaultLanguage "en" ;
  void:uriSpace "http://connectivity-hub.com/terms/" ;
  skosmos:sparqlEndpoint <http://fuseki:3030/skosmos/sparql> ;
  skosmos:sparqlGraph <http://example.org/graph/dev> ;
  skosmos:showTopConcepts true ;
  skosmos:fullAlphabeticalIndex true .
EOF

# Run docker compose
docker compose -f skosmos-src/docker-compose.yml up -d --build

# Wait until SPARQL endpoint is ready
for i in {1..60}; do
  if curl -sS -G 'http://localhost:9030/skosmos/sparql' --data-urlencode 'query=ASK{}' -H 'Accept: text/boolean' -o /dev/null; then break; fi
  sleep 1
done

# Load TTL into the graph
curl --retry 6 --retry-delay 2 --retry-connrefused -sSf -X PUT -H "Content-Type: text/turtle;charset=utf-8" --data-binary @concepts.ttl "http://localhost:9030/skosmos/data?graph=http://example.org/graph/dev"

