# Ship data from JSON file into AWS ES

## Input

filePath
'/tmp/sites/site-nonprod-profiling.json'

## Output

New Document is indexed into ES

## How it works

- load file from filePath
- parse the necessary information from fileName
  - index: `site`
  - docId: `nonprod-profiling`
  - document: file content
- call lambda function to index document
