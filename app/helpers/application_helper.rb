require 'hmac-sha1'

module ApplicationHelper
  def paginate(collection, params= {})
    will_paginate collection, params.merge(:renderer => RemoteLinkPaginationHelper::LinkRenderer)
  end

  def urlSafeBase64Decode(base64String)
    return Base64.decode64(base64String.tr('-_','+/'))
  end

  def urlSafeBase64Encode(raw)
    return Base64.encode64(raw).tr('+/','-_')
  end

  def signURL(key, url)
    parsedURL = URI.parse(url)
    urlToSign = parsedURL.path + '?' + parsedURL.query

    # Decode the private key
    rawKey = urlSafeBase64Decode(key)

    # create a signature using the private key and the URL
    sha1 = HMAC::SHA1.new(rawKey)
    sha1 << urlToSign
    rawSignature = sha1.digest()

    # encode the signature into base64 for url use form.
    signature =  urlSafeBase64Encode(rawSignature)

    # prepend the server and append the signature.
    signedUrl = parsedURL.scheme+"://"+ parsedURL.host + urlToSign + "&signature=#{signature}"
    return signedUrl
  end

  def get_namespace
    params[:controller].split("/")[0]
  end
end
