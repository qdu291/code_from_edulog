# Users Patch
# Endpoint: https://developers.google.com/admin-sdk/directory/v1/reference/users/patch?apix=true#try-it
# userKey: tan.khuu@karrostech.com
{
  "customSchemas": {
    "AWSSSO": {
      "role": [
        {
          "type": "custom",
          "customType": "ATH-Developers",
          "value": "arn:aws:iam::690893158275:role/iam-athena-AthGsuiteDeveloperRole-16EYE5OB9EN8Z,arn:aws:iam::690893158275:saml-provider/KarrosGsuite"
        },
        {
          "type": "custom",
          "customType": "ATH-Developers",
          "value": "arn:aws:iam::696952606624:role/athena-iam-AthGsuiteDeveloperRole-1CUN0RU8UPHK9,arn:aws:iam::696952606624:saml-provider/KarrosGsuiteSSO"
        }
      ]
    }
  }
}
