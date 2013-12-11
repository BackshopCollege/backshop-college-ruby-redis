class PasswordMD5Cipher

  def self.cipher!(password, digest = Digest::MD5)
    digest.hexdigest(password)
  end

end