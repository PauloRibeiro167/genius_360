# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "RESTful"
  inflect.irregular "instituicao", "instituicoes"
end

ActiveSupport::Inflector.inflections(:pt) do |inflect|
  inflect.clear

  # Regras gerais
  inflect.plural(/(s)$/i, '\1')
  inflect.plural(/(z|r)$/i, '\1es')
  inflect.plural(/al$/i, "ais")
  inflect.plural(/el$/i, "eis")
  inflect.plural(/ol$/i, "ois")
  inflect.plural(/ul$/i, "uis")
  inflect.plural(/([^aeou])il$/i, '\1is')
  inflect.plural(/m$/i, "ns")
  inflect.plural(/^(japon|escoc|ingl|dinamarqu|fregu|portugu)ês$/i, '\1eses')
  inflect.plural(/^(|g)ás$/i, '\1ases')
  inflect.plural(/ão$/i, "ões")
  inflect.plural(/^(irm|m)ão$/i, '\1ãos')
  inflect.plural(/^(alem|c|p)ão$/i, '\1ães')

  # Regras específicas
  inflect.irregular("instituicao", "instituicoes")
end
