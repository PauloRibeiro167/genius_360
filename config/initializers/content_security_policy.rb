# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self
  policy.font_src    :self, :data, :unsafe_inline, "data:"  # Adicionado "data:" explicitamente
  policy.img_src     :self, :data
  policy.style_src   :self, :unsafe_inline
  policy.script_src  :self, :unsafe_inline
  policy.connect_src :self
  policy.object_src  :none
end

Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }
Rails.application.config.content_security_policy_nonce_directives = %w(style-src)
