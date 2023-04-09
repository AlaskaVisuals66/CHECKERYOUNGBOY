#!/bin/sh

echo "\n[+] Input": $1
echo "\n[+] Output:" 

curl=`cat <<EOS
curl -s https://api.openai.com/v1/completions \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer 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" \
  -d '{
  "model": "text-davinci-003",
  "prompt": "$1",
  "max_tokens": 4000,
  "temperature": 1.0
}' \
--insecure | jq -r '.choices[].text'
EOS`
eval ${curl}
