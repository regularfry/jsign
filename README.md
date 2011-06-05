# Jsign #

For signing your JSON serialisations.

Jsign presents a dead-simple API for generating and verifying
private-RSA-key-signed JSON serialisations.  It is minimally intrusive
into the serialised object, adding a single top-level key-value pair.

For now, the digest is hard-coded to sha256, and the key algorithm is
fixed as RSA. I'll loosen these when there's a need.

## Howto ##

    require 'jsign'
    
    json = '{"a":1}'
    private_keyfile = "~/sekrit/mykey.pem"
    signed_json = Jsign.sign(json, private_keyfile)
    
    # somewhere else, a short time later
    
    public_keyfile = "~/public/mypub.pem"
    if Jsign.verify(signed_json, public_keyfile)
      puts "All is well with the world."
    else
      raise "DIUERSE ALARUMS!"
    end
    
## How it works ##

Jsign signing does the simplest thing that can possibly work: it
rewrites the json string with the signature without actually parsing the
JSON at all.  The only requirement for this to work is that the JSON
serialisation finishes with a '}' character.

## TODO ##

* Figure out an API to support more than one key type
* add a Jsign.unsign method to get rid of the superfluous key/value pair

## License ##

Public domain.
