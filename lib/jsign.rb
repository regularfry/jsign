# encoding: utf-8

require 'tempfile'
require 'base64'
require 'openssl'


module Jsign

  class << self

    def check_for_keyfile!(key_filename)
      raise "Key #{key_filename.inspect} doesn't exist!" unless
        File.file?(key_filename)
    end
    private :check_for_keyfile!


    # Given a json serialisation of a hash, return another json
    # serialisation which includes a key "_jsign" and a value which is
    # the Base64-encoded signature of the *original* json. Well,
    # nearly - any internal whitespace after the last value in the
    # original json is stripped.
    #
    # @param [String] json The json serialisation to sign.
    # @param [String] key_filename The filename of the private key to
    #  sign with.
    # @return [String] another json string containing the signature,
    #  which can be passed to Jsign.verify.
    def sign(json, key_filename)
      check_for_keyfile!(key_filename)

      # Remove any whitespace inside the last bracket.
      stripped_json = json.sub(/\s+}\Z/, "}")
      sig = ""
      # Use openssl -sha256 to do the signing. This will probably
      # be configurable in a future version, but it'll do for now
      digest = OpenSSL::Digest::SHA256.new
      key = OpenSSL::PKey::RSA.new(File.read(key_filename))
      sig = key.sign(digest, stripped_json)

      # Use the urlsafe version so we don't get newline literals
      enc_sig = Base64.urlsafe_encode64(sig).strip
      return stripped_json.sub(/}\Z/, %Q[,"_jsign":"#{enc_sig}"}])
    end


    # Given a string of json and the filename of a public key,
    # see if the json string contains a signature which the public
    # key validates.  This doesn't actually do any JSON decoding.
    #
    # @param [String] json The putative JSON string
    # @param [String] pubkey_filename The filename of the public key
    # @return [Boolean] true if the public key validates the
    #   signature, false otherwise.
    def verify(json, pubkey_filename)
      check_for_keyfile!(pubkey_filename)
      
      # Note that we mirror the whitespace stripping here:
      # this is so that we have a chance to survive being 
      # deserialised and reserialised.
      if m = json.match(/\A(.+?)\s*,"_jsign":"([^"]+)"}/)
        enc_sig = m[2]

        sig = Base64.urlsafe_decode64(enc_sig)
        reconstructed_json = m[1]+"}"

        digest = OpenSSL::Digest::SHA256.new
        key = OpenSSL::PKey::RSA.new(File.read(pubkey_filename))
        return key.verify(digest, sig, reconstructed_json)
        
      else
        return false
      end
    end


  end # class << self
end # module Jsign
