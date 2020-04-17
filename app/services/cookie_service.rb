class CookieService
  def self.data(user)
    {
      value: user.id.to_s,
      expires: 1.year,
      httponly: true # hide from javascript
    }
  end
end
