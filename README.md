# Dujudu

Doodle
https://www.figma.com/file/yVrIf79Tpo7CUEKwUgS85A/Dujudu%3F-%2F-Wasmachtmanmit%3F

## Executing things in the docker container

Running migrations:

    $ docker-compose run web mix ecto.migrate


## Querying Wikidata

https://query.wikidata.org/

Slightly adjusted "cat" example, with filter for `wd:Q25403900` - "Food ingredient" https://www.wikidata.org/wiki/Q25403900

```
#Ingredients
SELECT ?item ?itemLabel
WHERE
{
  ?item wdt:P31 wd:Q25403900. # <span lang="en" dir="ltr" class="mw-content-ltr">Must be of a cat</span>
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". } # <span lang="en" dir="ltr" class="mw-content-ltr">Helps get the label in your language, if not, then en language</span>
}
```
